// Security rules tests. Run with `npm test` in this folder; it starts the
// Firestore emulator. Uses the demo- project prefix, so nothing touches a
// real Firebase project.
import { readFileSync } from 'node:fs';
import { afterAll, beforeAll, beforeEach, describe, test } from 'vitest';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  query,
  setDoc,
  Timestamp,
  updateDoc,
  where,
} from 'firebase/firestore';

let env;

const hour = 60 * 60 * 1000;
const inHours = (h) => Timestamp.fromMillis(Date.now() + h * hour);

const child = (nickname, extra = {}) => ({
  nickname,
  role: 'child',
  ageBand: 'age6to9',
  hasOwnDevice: true,
  uid: null,
  pinHash: null,
  consentAt: Timestamp.now(),
  consentByUid: 'owner',
  ...extra,
});

const parent = (nickname, uid) => ({
  nickname,
  role: 'parent',
  ageBand: 'adult',
  hasOwnDevice: true,
  uid,
  pinHash: null,
  consentAt: null,
  consentByUid: null,
});

const habit = (name, ownerMemberId) => ({
  name,
  ownerMemberId,
  category: 'study',
  subcategory: null,
  timesPerWeek: 7,
});

const check = (habitId, day, checkedInBy) => ({ habitId, day, checkedInBy });

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-family-habits',
    firestore: { rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8') },
  });
});

afterAll(() => env.cleanup());

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    const put = (path, data) => setDoc(doc(db, path), data);
    await put('families/f1', { name: 'Levis', ownerUid: 'owner', weekStart: null });
    await put('families/f2', { name: 'Others', ownerUid: 'other', weekStart: null });
    await put('users/owner', { familyId: 'f1', role: 'parent', memberId: 'dad' });
    await put('users/coparent', { familyId: 'f1', role: 'parent', memberId: 'mom', inviteCode: 'USEDCODE' });
    await put('users/tablet', { familyId: 'f1', role: 'device', memberIds: ['maya'], inviteCode: 'MAYACODE' });
    await put('users/other', { familyId: 'f2', role: 'parent', memberId: 'x' });
    await put('families/f1/members/dad', parent('Dad', 'owner'));
    await put('families/f1/members/mom', parent('Mom', 'coparent'));
    await put('families/f1/members/maya', child('Maya'));
    await put('families/f1/members/itai', child('Itai'));
    await put('families/f1/habits/dinner', habit('Family dinner', null));
    await put('families/f1/habits/read', habit('Read', 'maya'));
    await put('families/f1/habits/bed', habit('Make bed', 'itai'));
    await put('pairingCodes/DEVICE22', {
      familyId: 'f1', kind: 'device', memberIds: ['itai'], createdBy: 'owner', expiresAt: inHours(24),
    });
    await put('pairingCodes/OLDCODE2', {
      familyId: 'f1', kind: 'device', memberIds: ['itai'], createdBy: 'owner', expiresAt: inHours(-1),
    });
    await put('pairingCodes/INVITE22', {
      familyId: 'f1', kind: 'coParent', memberIds: [], createdBy: 'owner', expiresAt: inHours(24),
    });
  });
});

const as = (uid) => env.authenticatedContext(uid).firestore();
const anon = () => env.unauthenticatedContext().firestore();

describe('reading a family', () => {
  test('members of the family can read it', async () => {
    for (const uid of ['owner', 'coparent', 'tablet']) {
      await assertSucceeds(getDoc(doc(as(uid), 'families/f1')));
      await assertSucceeds(getDocs(collection(as(uid), 'families/f1/habits')));
      await assertSucceeds(getDocs(collection(as(uid), 'families/f1/members')));
    }
  });

  test('outsiders cannot', async () => {
    for (const db of [as('stranger'), as('other'), anon()]) {
      await assertFails(getDoc(doc(db, 'families/f1')));
      await assertFails(getDocs(collection(db, 'families/f1/members')));
      await assertFails(getDocs(collection(db, 'families/f1/checkIns')));
    }
  });

  test('pairing codes cannot be listed by outsiders', async () => {
    await assertFails(getDocs(collection(as('stranger'), 'pairingCodes')));
    await assertSucceeds(getDocs(query(collection(as('owner'), 'pairingCodes'), where('familyId', '==', 'f1'))));
  });
});

describe('check-ins', () => {
  const put = (db, id, data) => setDoc(doc(db, `families/f1/checkIns/${id}`), data);

  test('a child device checks in its own habit', async () => {
    await assertSucceeds(put(as('tablet'), 'read_2026-09-30', check('read', '2026-09-30', 'maya')));
  });

  test('a child device cannot check in for a sibling or the family', async () => {
    await assertFails(put(as('tablet'), 'bed_2026-09-30', check('bed', '2026-09-30', 'maya')));
    await assertFails(put(as('tablet'), 'read_2026-09-30', check('read', '2026-09-30', 'itai')));
    await assertFails(put(as('tablet'), 'dinner_2026-09-30', check('dinner', '2026-09-30', 'maya')));
  });

  test('a parent checks in the family habit and any child habit', async () => {
    await assertSucceeds(put(as('coparent'), 'dinner_2026-09-30', check('dinner', '2026-09-30', 'mom')));
    await assertSucceeds(put(as('owner'), 'bed_2026-09-30', check('bed', '2026-09-30', 'dad')));
  });

  test('the id must match the habit and day', async () => {
    await assertFails(put(as('owner'), 'something', check('dinner', '2026-09-30', 'dad')));
    await assertFails(put(as('owner'), 'dinner_30-09-2026', check('dinner', '30-09-2026', 'dad')));
  });

  test('check-ins for a habit that does not exist are refused', async () => {
    await assertFails(put(as('owner'), 'nope_2026-09-30', check('nope', '2026-09-30', 'dad')));
  });

  test('outsiders cannot check in', async () => {
    await assertFails(put(as('other'), 'dinner_2026-09-30', check('dinner', '2026-09-30', 'x')));
  });
});

describe('habits and members', () => {
  test('parents manage habits; devices cannot', async () => {
    await assertSucceeds(setDoc(doc(as('owner'), 'families/f1/habits/h1'), habit('Swim', 'maya')));
    await assertFails(setDoc(doc(as('tablet'), 'families/f1/habits/h2'), habit('Games all day', 'maya')));
    await assertFails(deleteDoc(doc(as('tablet'), 'families/f1/habits/read')));
  });

  test('a habit must belong to a real member', async () => {
    await assertFails(setDoc(doc(as('owner'), 'families/f1/habits/h1'), habit('Swim', 'ghost')));
  });

  test('a child profile needs consent recorded by the parent adding it', async () => {
    const db = as('owner');
    await assertSucceeds(setDoc(doc(db, 'families/f1/members/noa'), child('Noa')));
    await assertFails(setDoc(doc(db, 'families/f1/members/ben'), child('Ben', { consentAt: null })));
    await assertFails(setDoc(doc(db, 'families/f1/members/ben'), child('Ben', { consentByUid: 'someone' })));
  });

  test('consent cannot be rewritten later', async () => {
    await assertFails(updateDoc(doc(as('owner'), 'families/f1/members/maya'), { consentAt: inHours(-100) }));
    await assertSucceeds(updateDoc(doc(as('owner'), 'families/f1/members/maya'), { nickname: 'Mayush' }));
  });

  test('a parent cannot add a parent profile for someone else', async () => {
    await assertFails(setDoc(doc(as('owner'), 'families/f1/members/fake'), parent('Fake', 'stranger')));
  });

  test('a co-parent cannot remove the other parent', async () => {
    await assertFails(deleteDoc(doc(as('coparent'), 'families/f1/members/dad')));
    await assertSucceeds(deleteDoc(doc(as('coparent'), 'families/f1/members/mom')));
  });

  test('devices cannot add members', async () => {
    await assertFails(setDoc(doc(as('tablet'), 'families/f1/members/z'), child('Z', { consentByUid: 'tablet' })));
  });
});

describe('creating and joining families', () => {
  test('a new parent creates a family they own and links to it', async () => {
    const db = as('newbie');
    await assertSucceeds(setDoc(doc(db, 'families/f3'), { name: 'New', ownerUid: 'newbie', weekStart: null }));
    await assertSucceeds(setDoc(doc(db, 'users/newbie'), { familyId: 'f3', role: 'parent', memberId: 'm' }));
    await assertSucceeds(setDoc(doc(db, 'families/f3/members/m'), parent('Me', 'newbie')));
  });

  test('nobody can create a family owned by someone else', async () => {
    await assertFails(setDoc(doc(as('newbie'), 'families/f3'), { name: 'New', ownerUid: 'owner', weekStart: null }));
  });

  test('nobody can link themselves to a family they do not own', async () => {
    await assertFails(setDoc(doc(as('newbie'), 'users/newbie'), { familyId: 'f1', role: 'parent', memberId: 'm' }));
  });

  test('nobody can write another account record', async () => {
    await assertFails(setDoc(doc(as('newbie'), 'users/owner'), { familyId: 'f1', role: 'parent', memberId: 'm' }));
  });

  test('account records cannot be changed, only deleted', async () => {
    await assertFails(updateDoc(doc(as('tablet'), 'users/tablet'), { memberIds: ['maya', 'itai'] }));
    await assertFails(updateDoc(doc(as('tablet'), 'users/tablet'), { role: 'parent' }));
    await assertSucceeds(deleteDoc(doc(as('tablet'), 'users/tablet')));
  });

  test('a device pairs with a valid code, then deletes it', async () => {
    const db = as('ipad');
    await assertSucceeds(setDoc(doc(db, 'users/ipad'), {
      familyId: 'f1', role: 'device', memberIds: ['itai'], inviteCode: 'DEVICE22',
    }));
    await assertSucceeds(deleteDoc(doc(db, 'pairingCodes/DEVICE22')));
  });

  test('a device cannot widen its profiles, use an expired code or become a parent', async () => {
    const db = as('ipad');
    const record = { familyId: 'f1', role: 'device', memberIds: ['itai'], inviteCode: 'DEVICE22' };
    await assertFails(setDoc(doc(db, 'users/ipad'), { ...record, memberIds: ['itai', 'maya'] }));
    await assertFails(setDoc(doc(db, 'users/ipad'), { ...record, inviteCode: 'OLDCODE2' }));
    await assertFails(setDoc(doc(db, 'users/ipad'), { ...record, inviteCode: 'NOTACODE' }));
    await assertFails(setDoc(doc(db, 'users/ipad'), { familyId: 'f1', role: 'parent', memberId: 'z', inviteCode: 'DEVICE22' }));
    await assertFails(setDoc(doc(db, 'users/ipad'), { ...record, familyId: 'f2' }));
  });

  test('someone who did not use a code cannot delete it', async () => {
    await assertFails(deleteDoc(doc(as('stranger'), 'pairingCodes/DEVICE22')));
  });

  test('a second parent joins with an invite code', async () => {
    const db = as('ima');
    await assertSucceeds(setDoc(doc(db, 'users/ima'), {
      familyId: 'f1', role: 'parent', memberId: 'ima', inviteCode: 'INVITE22',
    }));
    await assertSucceeds(setDoc(doc(db, 'families/f1/members/ima'), parent('Ima', 'ima')));
  });

  test('only parents make codes, and codes last at most a day', async () => {
    const code = (h) => ({ familyId: 'f1', kind: 'device', memberIds: ['maya'], createdBy: 'owner', expiresAt: inHours(h) });
    await assertSucceeds(setDoc(doc(as('owner'), 'pairingCodes/ABCDEFGH'), code(24)));
    await assertFails(setDoc(doc(as('owner'), 'pairingCodes/ABCDEFGJ'), code(24 * 30)));
    await assertFails(setDoc(doc(as('tablet'), 'pairingCodes/ABCDEFGK'), { ...code(24), createdBy: 'tablet' }));
    await assertFails(setDoc(doc(as('other'), 'pairingCodes/ABCDEFGM'), { ...code(24), createdBy: 'other' }));
  });
});

describe('deleting', () => {
  test('only the owner deletes the family', async () => {
    await assertFails(deleteDoc(doc(as('coparent'), 'families/f1')));
    await assertFails(deleteDoc(doc(as('tablet'), 'families/f1')));
    await assertSucceeds(deleteDoc(doc(as('owner'), 'families/f1')));
  });

  test('the owner removes other accounts when deleting the family', async () => {
    const db = as('owner');
    const others = await assertSucceeds(getDocs(query(collection(db, 'users'), where('familyId', '==', 'f1'))));
    // Like the app: everyone else first, then the owner's own record.
    for (const d of others.docs.filter((d) => d.id !== 'owner')) {
      await assertSucceeds(deleteDoc(d.ref));
    }
    await assertSucceeds(deleteDoc(doc(db, 'users/owner')));
  });

  test('a co-parent cannot remove other accounts', async () => {
    await assertFails(deleteDoc(doc(as('coparent'), 'users/tablet')));
  });
});

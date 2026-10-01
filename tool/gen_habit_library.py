# Habit Library V1: the categories and habits, as Gilad specified them.
# Edit here, then run: python3 tool/gen_habit_library.py
# Each habit: (name, audience, recommended, keywords)
# audience: all | adult | parent | child | family
A,AD,P,C,F='all','adult','parent','child','family'
CATS = [
 ('health','HEALTH','Health',[
  ('Drink enough water',A,1,'water hydrate hydration drink thirsty bottle'),
  ('Take medication',A,1,'medicine meds pills prescription'),
  ('Take vitamins',A,1,'vitamin supplement supplements'),
  ('Take screen breaks',A,1,'eyes eye screen computer rest'),
  ('Maintain good posture',AD,0,'posture back sit straight'),
  ('Spend time in daylight',A,0,'daylight sun light morning'),
  ('Health check',AD,0,'blood pressure weight check glucose health'),
  ('Dental care',A,0,'teeth dental mouthwash'),
 ]),
 ('breakHabit','BREAK','Break a Habit',[
  ('Stay within screen-time limit',A,1,'screen screens phone tv television tablet'),
  ('Stay within social-media limit',A,1,'social instagram tiktok facebook scrolling'),
  ('No smoking or vaping',AD,1,'smoke smoking cigarette cigarettes vape vaping nicotine quit'),
  ('No alcohol',AD,1,'alcohol drink drinking beer wine sober'),
  ('No junk food',A,1,'junk fast food diet chips fries unhealthy'),
  ('No sweets',A,1,'sugar sweets candy chocolate dessert diet'),
  ('No late-night snacking',A,0,'snack snacking night diet'),
  ('No nail biting',A,0,'nails nail biting'),
  ('No swearing',A,0,'swear swearing curse words language'),
  ('No impulse purchases',AD,0,'shopping impulse buying spend money'),
  ('No phone in bed',A,0,'phone bed bedroom night'),
  ('No unnecessary phone use',A,0,'phone mobile scrolling'),
 ]),
 ('nutrition','NUTRITION','Nutrition',[
  ('Eat fruit',A,1,'fruit fruits apple healthy'),
  ('Eat vegetables',A,1,'vegetables veggies salad greens healthy diet'),
  ('Eat enough protein',AD,0,'protein meat eggs muscle'),
  ('Eat a balanced breakfast',A,1,'breakfast morning meal'),
  ('Eat a home-cooked meal',A,0,'cook cooking home meal'),
  ('Eat mindfully',A,1,'diet mindful slowly eating weight portion'),
  ('Try a new food',C,0,'new food taste picky'),
  ('HEALTH_001',None,0,''),
  ('Prepare food for tomorrow',AD,0,'meal prep lunch lunchbox tomorrow'),
 ]),
 ('sleep','SLEEP','Sleep',[
  ('Go to bed on time',A,1,'bed bedtime sleep early night'),
  ('Wake up on time',A,1,'wake alarm morning early'),
  ('No screens before bed',A,1,'screens phone bed night'),
  ('Complete bedtime routine',A,0,'bedtime routine night'),
  ('Wind down before bed',A,0,'relax wind down calm night'),
  ('Get enough sleep',A,1,'sleep rest tired hours'),
  ('Take a nap',C,0,'nap rest'),
  ('Prepare for tomorrow before bed',A,0,'prepare tomorrow night'),
 ]),
 ('sport','SPORT','Sport',[
  ('Walk',A,1,'walk walking steps'),
  ('Run',A,1,'run running jog jogging'),
  ('Gym workout',AD,1,'gym workout exercise fitness training'),
  ('Strength training',AD,0,'strength weights lifting muscle'),
  ('Team sport',A,0,'football soccer basketball team game'),
  ('Swim',A,0,'swim swimming pool'),
  ('Cycle',A,0,'bike biking bicycle cycling ride'),
  ('Martial arts',A,0,'karate judo taekwondo martial'),
  ('Yoga',A,0,'yoga pilates'),
  ('Stretch',A,0,'stretch stretching flexibility'),
  ('Reach step goal',A,1,'steps step pedometer walk'),
  ('Other workout',A,0,'workout exercise sport training fitness'),
 ]),
 ('selfCare','SELF_CARE','Self-Care & Hygiene',[
  ('Brush teeth',A,1,'teeth brush toothbrush dental'),
  ('Floss',A,0,'floss teeth dental'),
  ('Shower',A,1,'shower bath wash clean'),
  ('Skincare',A,0,'skin skincare face cream'),
  ('Apply sunscreen',A,0,'sunscreen sun cream spf'),
  ('Get dressed',C,1,'dress dressed clothes'),
  ('Complete morning routine',A,1,'morning routine'),
  ('Complete evening routine',A,0,'evening routine night'),
  ('Hair care',A,0,'hair comb brush'),
  ('Prepare clothes for tomorrow',C,0,'clothes outfit tomorrow'),
 ]),
 ('mindfulness','MINDFUL','Mindfulness',[
  ('Meditate',A,1,'meditate meditation mindful calm'),
  ('Breathing exercise',A,1,'breathe breathing breath calm stress'),
  ('Practice gratitude',A,1,'gratitude grateful thankful thanks'),
  ('Prayer',A,0,'pray prayer god faith'),
  ('Reflect',A,0,'reflect think reflection'),
  ('Journal',A,0,'journal diary write feelings'),
  ('Check in with my mood',A,0,'mood feelings emotions'),
  ('Quiet time',A,0,'quiet silence calm alone'),
  ('Positive reflection',A,0,'positive good things happy'),
 ]),
 ('familyTime','FAMILY_TIME','Family Quality Time',[
  ('Spend one-on-one time with my child',P,1,'child kid kids son daughter one-on-one together'),
  ('Spend one-on-one time with my partner',AD,1,'partner wife husband spouse date couple'),
  ('Play with my child',P,1,'play child kid kids son daughter'),
  ('Play a family game',F,1,'game games board family play'),
  ('Read a bedtime story',P,1,'book books read reading story bedtime kid kids child'),
  ('Talk about the day',A,1,'talk conversation day dinner'),
  ('Have a meaningful conversation',A,0,'talk conversation deep'),
  ('Call grandparents',A,0,'grandma grandpa grandparents call phone'),
  ('Call a family member',A,0,'call phone family'),
  ('Take a family trip or outing',F,0,'trip outing vacation holiday travel family'),
  ('Have device-free family time',F,0,'device phone free family'),
  ('Do something fun together',F,0,'fun together family'),
 ]),
 ('familyCare','FAMILY_CARE','Family Care & Parenting',[
  ('Help my child with homework',P,1,'homework school child kid kids help'),
  ('Help my child prepare for school',P,1,'school morning child kid bag'),
  ('Prepare something for my child',P,0,'prepare child kid lunch'),
  ("Check my child's school tasks",P,0,'school tasks child kid homework'),
  ('Help a family member',A,0,'help family'),
  ('Check in on a family member',A,0,'check call family'),
  ('Take care of something for my partner',AD,0,'partner wife husband spouse'),
  ('Take care of something for my parents',AD,0,'parents mom dad mother father'),
  ('Help with bedtime routine',P,0,'bedtime routine child kid'),
  ('Help with morning routine',P,0,'morning routine child kid'),
  ('Teach my child something',P,0,'teach child kid learn'),
  ('Encourage my child',P,0,'encourage praise child kid'),
  ('Do something kind for a family member',A,0,'kind kindness family'),
 ]),
 ('familyMeals','FAMILY_MEALS','Family Meals & Gatherings',[
  ('Eat dinner together',F,1,'dinner supper together family meal'),
  ('Eat a family meal',F,1,'meal lunch family together'),
  ('Have weekend breakfast together',F,0,'breakfast weekend brunch'),
  ('Cook together',F,1,'cook cooking bake baking kitchen'),
  ('Have a phone-free meal',F,1,'phone free meal dinner'),
  ('Host family or relatives',F,0,'host guests relatives'),
  ('Attend a family gathering',F,0,'gathering party relatives'),
  ('Have a holiday meal together',F,0,'holiday shabbat christmas festive'),
 ]),
 ('homeTasks','HOME','Home Tasks',[
  ('Make the bed',A,1,'bed make'),
  ('Tidy room',A,1,'tidy room clean mess toys'),
  ('Clean the house',AD,0,'clean cleaning house vacuum'),
  ('Wash dishes',A,1,'dishes wash dishwasher'),
  ('Do laundry',AD,0,'laundry washing clothes'),
  ('Fold laundry',A,0,'fold laundry clothes'),
  ('Take out trash',A,0,'trash garbage bin rubbish'),
  ('Recycle',A,0,'recycle recycling'),
  ('Take care of pet',A,1,'pet dog cat feed walk fish'),
  ('Water plants',A,0,'plants water flowers'),
  ('Work in the garden',A,0,'garden gardening yard'),
  ('Pack school bag',C,1,'school bag backpack pack'),
  ('Prepare for tomorrow',A,0,'prepare tomorrow plan'),
  ('Organize something',A,0,'organize organise declutter'),
 ]),
 ('study','STUDY','Study',[
  ('Do homework',C,1,'homework school assignment'),
  ('Read',A,1,'read reading book books novel'),
  ('Study',A,1,'study learn exam school'),
  ('Practice a language',A,0,'language english spanish hebrew duolingo'),
  ('Prepare for an exam',A,0,'exam test quiz'),
  ('Take an online course',AD,0,'course online class'),
  ('Practice coding',A,0,'code coding programming'),
  ('Practice a skill',A,0,'skill practice learn'),
  ('Review school material',C,0,'school review material'),
  ('Complete an assignment',A,0,'assignment project'),
 ]),
 ('work','WORK','Work',[
  ('Plan my day',AD,1,'plan planning day schedule'),
  ('Complete my top priority',AD,1,'priority important focus productive'),
  ('Do focused work',AD,1,'focus deep work productive'),
  ('Process email',AD,0,'email inbox mail'),
  ('Complete an important task',AD,0,'task important'),
  ('Learn a professional skill',AD,0,'professional skill career'),
  ('Work on a side project',AD,0,'side project'),
  ('HOME_013',None,0,''),
 ]),
 ('finance','FINANCE','Finance',[
  ('Check spending',AD,1,'spending money expenses'),
  ('Follow my budget',AD,1,'budget money'),
  ('Save money',A,1,'save saving money'),
  ('Save toward a goal',A,0,'save goal money'),
  ('Have a no-spend day',AD,0,'spend money no-spend'),
  ('Manage pocket money',C,1,'pocket money allowance'),
  ('Invest',AD,0,'invest investing stocks'),
  ('Pay bills',AD,0,'bills pay'),
  ('Review finances',AD,0,'finances money review'),
  ('Give or donate',A,0,'donate charity give'),
  ('Avoid unnecessary purchases',A,0,'shopping purchases buy'),
 ]),
 ('outdoor','OUTDOOR','Outdoor Activities',[
  ('Go for a walk',A,1,'walk park stroll outside'),
  ('Go hiking',A,1,'hike hiking trail nature mountain'),
  ('Visit a park',A,1,'park nature garden'),
  ('Go to playground',C,1,'playground park swings slide'),
  ('Go to the beach',A,0,'beach sea ocean'),
  ('Spend time outdoors',A,1,'outdoors outside nature fresh air'),
  ('Spend time in sunlight',A,0,'sun sunlight'),
  ('Explore somewhere new',A,0,'explore new place adventure'),
  ('Outdoor family activity',F,0,'outdoor family activity park'),
 ]),
 ('art','ART','Art & Creativity',[
  ('Draw',A,1,'draw drawing sketch'),
  ('Paint',A,0,'paint painting'),
  ('Practice music',A,1,'music practice'),
  ('Play an instrument',A,0,'instrument piano guitar violin drums'),
  ('Write',A,0,'write writing story'),
  ('Journal creatively',A,0,'journal creative'),
  ('Do crafts',A,0,'crafts craft diy'),
  ('Take photos',A,0,'photo photos photography camera'),
  ('Dance',A,0,'dance dancing'),
  ('Practice performing arts',A,0,'theatre theater drama acting perform'),
  ('Create something',A,0,'create make build'),
 ]),
 ('hobbies','HOBBIES','Hobbies & Fun',[
  ('Play a board game',A,1,'board game games'),
  ('Play a video game',A,0,'video game gaming console'),
  ('Watch a movie',A,1,'movie film cinema'),
  ('Watch a series',A,0,'series tv show netflix'),
  ('Do a puzzle',A,0,'puzzle jigsaw'),
  ('Build something',A,0,'build lego'),
  ('Do a hobby',A,1,'hobby'),
  ('Learn something for fun',A,0,'learn fun'),
  ('Play with building toys',C,0,'lego blocks building toys'),
  ('Work on a collection',A,0,'collection collect stamps cards'),
 ]),
]
def build():
    out=[]; cats=[]
    for ci,(key,prefix,label,habits) in enumerate(CATS,1):
        ids=[]
        n=0
        for name,aud,rec,kw in habits:
            if aud is None: ids.append(name); continue
            n+=1; hid=f'{prefix}_{n:03d}'
            out.append(dict(id=hid,category=key,name=name,order=n,recommended=bool(rec),audience=aud,keywords=kw.split()))
            ids.append(hid)
        cats.append(dict(key=key,number=ci,label=label,habits=ids))
    return cats,out

# Generates lib/models/habit_library.dart and habit_library_l10n.dart from
# the library below and tool/habit_translations.json.
import json, os
HERE=os.path.dirname(os.path.abspath(__file__))
R=os.path.join(HERE,'..','lib','models')+'/'
cats,habits=build()
lib={'categories':cats,'habits':habits}
tr=json.load(open(os.path.join(HERE,'habit_translations.json')))
def q(s): return "'" + s.replace('\\','\\\\').replace("'","\\'") + "'"
L=[]
L.append("// Generated by tool/gen_habit_library.py from the Habit Library V1 spec.")
L.append("// Edit the list there and run `python3 tool/gen_habit_library.py`.")
L.append("import 'category.dart';\n")
L.append("/// Who a template suits. Used to leave out habits that don't fit a child.")
L.append("enum Audience { all, adult, parent, child, family }\n")
L.append("/// A ready-made habit people can pick. Every habit is a daily yes or no.")
L.append("class HabitTemplate {")
L.append("  const HabitTemplate(this.id, this.category, this.name, this.order, this.audience, {this.recommended = false, this.keywords = const []});\n")
L.append("  /// Stable id such as `FAMILY_CARE_001`, stored on habits made from it.")
L.append("  final String id;\n  final BuiltInCategory category;\n\n  /// English name. Use [habitTemplateName] for the user's language.")
L.append("  final String name;\n  final int order;\n  final Audience audience;\n\n  /// Shown among the first suggestions.")
L.append("  final bool recommended;\n\n  /// Extra English words that should find this habit in search.")
L.append("  final List<String> keywords;\n\n  bool get isActive => true;\n}\n")
L.append("const habitTemplates = <HabitTemplate>[")
for h in lib['habits']:
    kw=', '.join(q(k) for k in h['keywords'])
    rec=', recommended: true' if h['recommended'] else ''
    L.append(f"  HabitTemplate({q(h['id'])}, BuiltInCategory.{h['category']}, {q(h['name'])}, {h['order']}, Audience.{h['audience']}{rec}, keywords: [{kw}]),")
L.append("];\n")
L.append("final Map<String, HabitTemplate> habitTemplatesById = {")
L.append("  for (final t in habitTemplates) t.id: t,")
L.append("};\n")
L.append("/// The habits offered in each category, in display order. A habit can")
L.append("/// appear in more than one category, such as drinking water.")
L.append("const _categoryHabitIds = <BuiltInCategory, List<String>>{")
for c in lib['categories']:
    L.append(f"  BuiltInCategory.{c['key']}: [{', '.join(q(i) for i in c['habits'])}],")
L.append("};\n")
L.append("List<HabitTemplate> templatesIn(BuiltInCategory category) => [")
L.append("  for (final id in _categoryHabitIds[category]!) habitTemplatesById[id]!,")
L.append("];")
open(R+'habit_library.dart','w').write('\n'.join(L)+'\n')

T=["// Generated by tool/gen_habit_library.py from tool/habit_translations.json.",
   "// Do not edit by hand.","import 'dart:ui';\n","import 'habit_library.dart';\n",
   "/// [template]'s name in [locale], falling back to English.",
   "String habitTemplateName(HabitTemplate template, Locale locale) {",
   "  final names = _names['${locale.languageCode}_${locale.countryCode}'] ?? _names[locale.languageCode];",
   "  return names?[template.id] ?? template.name;","}\n",
   "/// Hebrew words that should find each habit in search.",
   "List<String> hebrewKeywords(HabitTemplate template) => _heKeywords[template.id] ?? const [];\n",
   "const _names = <String, Map<String, String>>{"]
for loc,m in sorted(tr['habits'].items()):
    T.append(f"  {q(loc)}: {{")
    for k,v in m.items(): T.append(f"    {q(k)}: {q(v)},")
    T.append("  },")
T.append("};\n")
T.append("const _heKeywords = <String, List<String>>{")
for k,v in tr['heKeywords'].items():
    T.append(f"  {q(k)}: [{', '.join(q(x) for x in v)}],")
T.append("};")
open(R+'habit_library_l10n.dart','w').write('\n'.join(T)+'\n')
print('generated', len(lib['habits']))

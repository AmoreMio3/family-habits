import '../models/category.dart';
import '../models/family.dart';

/// How a habit's picture moves when the habit is checked off or added.
enum Motion {
  /// Pops in and throws [Scene.extra] out in a ring.
  pop,

  /// Shown, then crossed out with a red "no" sign: for habits people quit.
  ban,

  /// Drops in and bounces.
  bounce,

  /// Rises gently while [Scene.extra] floats up around it.
  float,

  /// Shakes from side to side, like a ringing alarm or a toothbrush.
  wiggle,

  /// Walks, runs or drives in from the side.
  travel,

  /// Grows up from the ground.
  grow,

  /// [Scene.extra] falls into it, like coins into a piggy bank.
  rain,

  /// [Scene.extra] circles around it.
  orbit,

  /// Spins once.
  spin,

  /// Beats like a heart, sending out ripples.
  pulse,
}

/// The picture for one habit: an emoji, how it moves, and an optional
/// second emoji that plays alongside it (smoke, coins, hearts).
class Scene {
  const Scene(this.emoji, this.motion, [this.extra]);

  final String emoji;
  final Motion motion;
  final String? extra;

  @override
  bool operator ==(Object other) =>
      other is Scene &&
      other.emoji == emoji &&
      other.motion == motion &&
      other.extra == extra;

  @override
  int get hashCode => Object.hash(emoji, motion, extra);
}

/// One picture per ready-made habit, by template id. Drinking water keeps
/// its painted glass, so it has no entry here.
const habitScenes = <String, Scene>{
  // Health
  'HEALTH_002': Scene('💊', Motion.pop, '✨'),
  'HEALTH_003': Scene('🍊', Motion.pop, '⚡'),
  'HEALTH_004': Scene('👀', Motion.wiggle, '🌿'),
  'HEALTH_005': Scene('🧍', Motion.grow, '✨'),
  'HEALTH_006': Scene('☀️', Motion.spin, '✨'),
  'HEALTH_007': Scene('🩺', Motion.pulse, '❤️'),
  'HEALTH_008': Scene('🦷', Motion.pop, '✨'),
  // Break a Habit
  'BREAK_001': Scene('📱', Motion.ban, '⏰'),
  'BREAK_002': Scene('📲', Motion.ban, '👍'),
  'BREAK_003': Scene('🚬', Motion.ban, '💨'),
  'BREAK_004': Scene('🍺', Motion.ban, '🍷'),
  'BREAK_005': Scene('🍔', Motion.ban, '🍟'),
  'BREAK_006': Scene('🍭', Motion.ban, '🍬'),
  'BREAK_007': Scene('🍪', Motion.ban, '🌙'),
  'BREAK_008': Scene('💅', Motion.ban),
  'BREAK_009': Scene('🤬', Motion.ban),
  'BREAK_010': Scene('🛍️', Motion.ban, '💸'),
  'BREAK_011': Scene('📱', Motion.ban, '🛏️'),
  'BREAK_012': Scene('📳', Motion.ban, '🔔'),
  // Nutrition
  'NUTRITION_001': Scene('🍎', Motion.bounce, '🍌'),
  'NUTRITION_002': Scene('🥦', Motion.bounce, '🥕'),
  'NUTRITION_003': Scene('🍗', Motion.pop, '🥚'),
  'NUTRITION_004': Scene('🥣', Motion.rain, '🍓'),
  'NUTRITION_005': Scene('🍲', Motion.pulse, '❤️'),
  'NUTRITION_006': Scene('🥗', Motion.float, '🍃'),
  'NUTRITION_007': Scene('🍣', Motion.pop, '⭐'),
  'NUTRITION_008': Scene('🍱', Motion.rain, '🍙'),
  // Sleep
  'SLEEP_001': Scene('🛌', Motion.float, '💤'),
  'SLEEP_002': Scene('⏰', Motion.wiggle, '☀️'),
  'SLEEP_003': Scene('📱', Motion.ban, '🌙'),
  'SLEEP_004': Scene('🧸', Motion.float, '⭐'),
  'SLEEP_005': Scene('🌙', Motion.float, '✨'),
  'SLEEP_006': Scene('😴', Motion.pulse, '💤'),
  'SLEEP_007': Scene('🛋️', Motion.float, '💤'),
  'SLEEP_008': Scene('📋', Motion.pop, '🌙'),
  // Sport
  'SPORT_001': Scene('🚶', Motion.travel, '👣'),
  'SPORT_002': Scene('🏃', Motion.travel, '💨'),
  'SPORT_003': Scene('🏋️', Motion.pulse, '💪'),
  'SPORT_004': Scene('💪', Motion.pulse, '⚡'),
  'SPORT_005': Scene('⚽', Motion.bounce, '⭐'),
  'SPORT_006': Scene('🏊', Motion.travel, '💦'),
  'SPORT_007': Scene('🚴', Motion.travel, '💨'),
  'SPORT_008': Scene('🥋', Motion.wiggle, '💥'),
  'SPORT_009': Scene('🤸', Motion.spin, '✨'),
  'SPORT_010': Scene('🙆', Motion.grow, '✨'),
  'SPORT_011': Scene('👟', Motion.travel, '👣'),
  'SPORT_012': Scene('🤾', Motion.bounce, '💪'),
  // Self-Care & Hygiene
  'SELF_CARE_001': Scene('🪥', Motion.wiggle, '✨'),
  'SELF_CARE_002': Scene('🦷', Motion.wiggle, '✨'),
  'SELF_CARE_003': Scene('🚿', Motion.rain, '💧'),
  'SELF_CARE_004': Scene('🧴', Motion.pop, '✨'),
  'SELF_CARE_005': Scene('😎', Motion.pop, '☀️'),
  'SELF_CARE_006': Scene('👕', Motion.spin, '✨'),
  'SELF_CARE_007': Scene('🌅', Motion.grow, '✨'),
  'SELF_CARE_008': Scene('🌃', Motion.grow, '⭐'),
  'SELF_CARE_009': Scene('💇', Motion.wiggle, '✨'),
  'SELF_CARE_010': Scene('👗', Motion.pop, '👟'),
  // Mindfulness
  'MINDFUL_001': Scene('🧘', Motion.pulse, '🕊️'),
  'MINDFUL_002': Scene('🌬️', Motion.pulse, '🍃'),
  'MINDFUL_003': Scene('🙏', Motion.pulse, '💛'),
  'MINDFUL_004': Scene('🕯️', Motion.pulse, '✨'),
  'MINDFUL_005': Scene('💭', Motion.float, '✨'),
  'MINDFUL_006': Scene('📔', Motion.pop, '🖊️'),
  'MINDFUL_007': Scene('😊', Motion.spin, '💛'),
  'MINDFUL_008': Scene('🤫', Motion.float, '🍃'),
  'MINDFUL_009': Scene('🌈', Motion.grow, '✨'),
  // Family Quality Time
  'FAMILY_TIME_001': Scene('🧒', Motion.orbit, '❤️'),
  'FAMILY_TIME_002': Scene('💑', Motion.orbit, '💕'),
  'FAMILY_TIME_003': Scene('🧸', Motion.bounce, '🎈'),
  'FAMILY_TIME_004': Scene('🎲', Motion.spin, '🎉'),
  'FAMILY_TIME_005': Scene('📖', Motion.float, '⭐'),
  'FAMILY_TIME_006': Scene('💬', Motion.pop, '😊'),
  'FAMILY_TIME_007': Scene('🗨️', Motion.pulse, '💖'),
  'FAMILY_TIME_008': Scene('☎️', Motion.wiggle, '👵'),
  'FAMILY_TIME_009': Scene('📞', Motion.wiggle, '💛'),
  'FAMILY_TIME_010': Scene('🚗', Motion.travel, '💨'),
  'FAMILY_TIME_011': Scene('🤗', Motion.orbit, '❤️'),
  'FAMILY_TIME_012': Scene('🎈', Motion.float, '🎉'),
  // Family Care & Parenting
  'FAMILY_CARE_001': Scene('✏️', Motion.wiggle, '⭐'),
  'FAMILY_CARE_002': Scene('🏫', Motion.grow, '✨'),
  'FAMILY_CARE_003': Scene('🥪', Motion.pop, '❤️'),
  'FAMILY_CARE_004': Scene('✅', Motion.pop, '📚'),
  'FAMILY_CARE_005': Scene('🤝', Motion.pulse, '💛'),
  'FAMILY_CARE_006': Scene('🫂', Motion.pulse, '❤️'),
  'FAMILY_CARE_007': Scene('💐', Motion.grow, '💕'),
  'FAMILY_CARE_008': Scene('👴', Motion.orbit, '💛'),
  'FAMILY_CARE_009': Scene('🌛', Motion.float, '💤'),
  'FAMILY_CARE_010': Scene('🧃', Motion.pop, '☀️'),
  'FAMILY_CARE_011': Scene('🧑‍🏫', Motion.pop, '💡'),
  'FAMILY_CARE_012': Scene('🙌', Motion.bounce, '⭐'),
  'FAMILY_CARE_013': Scene('💝', Motion.pulse, '✨'),
  // Family Meals & Gatherings
  'FAMILY_MEALS_001': Scene('🍝', Motion.pulse, '❤️'),
  'FAMILY_MEALS_002': Scene('🍽️', Motion.pop, '😋'),
  'FAMILY_MEALS_003': Scene('🥞', Motion.rain, '🍓'),
  'FAMILY_MEALS_004': Scene('🧑‍🍳', Motion.wiggle, '✨'),
  'FAMILY_MEALS_005': Scene('📱', Motion.ban, '🍽️'),
  'FAMILY_MEALS_006': Scene('🏠', Motion.pulse, '💛'),
  'FAMILY_MEALS_007': Scene('🥳', Motion.orbit, '🎉'),
  'FAMILY_MEALS_008': Scene('🥘', Motion.pop, '🎉'),
  // Home Tasks
  'HOME_001': Scene('🛏️', Motion.bounce, '✨'),
  'HOME_002': Scene('📦', Motion.bounce, '✨'),
  'HOME_003': Scene('🧹', Motion.wiggle, '✨'),
  'HOME_004': Scene('🧽', Motion.wiggle, '💧'),
  'HOME_005': Scene('👚', Motion.spin, '💧'),
  'HOME_006': Scene('🧺', Motion.pop, '✨'),
  'HOME_007': Scene('🗑️', Motion.bounce, '✨'),
  'HOME_008': Scene('♻️', Motion.spin, '🌿'),
  'HOME_009': Scene('🐶', Motion.bounce, '❤️'),
  'HOME_010': Scene('🪴', Motion.rain, '💧'),
  'HOME_011': Scene('🌻', Motion.grow, '🌱'),
  'HOME_012': Scene('🎒', Motion.rain, '📚'),
  'HOME_013': Scene('📅', Motion.pop, '✨'),
  'HOME_014': Scene('🗃️', Motion.pop, '✨'),
  // Study
  'STUDY_001': Scene('📝', Motion.pop, '⭐'),
  'STUDY_002': Scene('📚', Motion.float, '✨'),
  'STUDY_003': Scene('🧠', Motion.pulse, '⚡'),
  'STUDY_004': Scene('🌍', Motion.spin, '💬'),
  'STUDY_005': Scene('💯', Motion.pop, '⭐'),
  'STUDY_006': Scene('💻', Motion.pop, '🎓'),
  'STUDY_007': Scene('⌨️', Motion.wiggle, '💡'),
  'STUDY_008': Scene('🎯', Motion.bounce, '⭐'),
  'STUDY_009': Scene('📒', Motion.spin, '✨'),
  'STUDY_010': Scene('📄', Motion.pop, '✅'),
  // Work
  'WORK_001': Scene('🗓️', Motion.pop, '✨'),
  'WORK_002': Scene('🥇', Motion.bounce, '⭐'),
  'WORK_003': Scene('🧑‍💻', Motion.pulse, '⚡'),
  'WORK_004': Scene('📥', Motion.rain, '✉️'),
  'WORK_005': Scene('📌', Motion.bounce, '✨'),
  'WORK_006': Scene('📈', Motion.grow, '✨'),
  'WORK_007': Scene('🚀', Motion.float, '🔥'),
  // Finance
  'FINANCE_001': Scene('🧾', Motion.pop, '🔍'),
  'FINANCE_002': Scene('📊', Motion.grow, '✨'),
  'FINANCE_003': Scene('🐷', Motion.rain, '🪙'),
  'FINANCE_004': Scene('🏦', Motion.rain, '🪙'),
  'FINANCE_005': Scene('💳', Motion.ban, '💸'),
  'FINANCE_006': Scene('👛', Motion.rain, '🪙'),
  'FINANCE_007': Scene('💹', Motion.grow, '✨'),
  'FINANCE_008': Scene('📬', Motion.pop, '✅'),
  'FINANCE_009': Scene('🧮', Motion.wiggle, '✨'),
  'FINANCE_010': Scene('🎁', Motion.pop, '💖'),
  'FINANCE_011': Scene('🛒', Motion.ban, '💸'),
  // Outdoor Activities
  'OUTDOOR_001': Scene('🌳', Motion.grow, '🍃'),
  'OUTDOOR_002': Scene('🏔️', Motion.grow, '🥾'),
  'OUTDOOR_003': Scene('🏞️', Motion.grow, '🦋'),
  'OUTDOOR_004': Scene('🎠', Motion.bounce, '🎈'),
  'OUTDOOR_005': Scene('🏖️', Motion.grow, '🌊'),
  'OUTDOOR_006': Scene('⛺', Motion.grow, '🌲'),
  'OUTDOOR_007': Scene('🌞', Motion.spin, '✨'),
  'OUTDOOR_008': Scene('🧭', Motion.spin, '✨'),
  'OUTDOOR_009': Scene('🪁', Motion.float, '🌤️'),
  // Art & Creativity
  'ART_001': Scene('🖍️', Motion.wiggle, '⭐'),
  'ART_002': Scene('🎨', Motion.spin, '🖌️'),
  'ART_003': Scene('🎵', Motion.float, '🎶'),
  'ART_004': Scene('🎸', Motion.wiggle, '🎶'),
  'ART_005': Scene('✍️', Motion.wiggle, '✨'),
  'ART_006': Scene('📓', Motion.pop, '🌈'),
  'ART_007': Scene('✂️', Motion.wiggle, '✨'),
  'ART_008': Scene('📷', Motion.pop, '✨'),
  'ART_009': Scene('💃', Motion.wiggle, '🎶'),
  'ART_010': Scene('🎭', Motion.spin, '⭐'),
  'ART_011': Scene('💡', Motion.pulse, '✨'),
  // Hobbies & Fun
  'HOBBIES_001': Scene('♟️', Motion.bounce, '⭐'),
  'HOBBIES_002': Scene('🎮', Motion.wiggle, '⭐'),
  'HOBBIES_003': Scene('🎬', Motion.pop, '🍿'),
  'HOBBIES_004': Scene('📺', Motion.pulse, '🍿'),
  'HOBBIES_005': Scene('🧩', Motion.spin, '✨'),
  'HOBBIES_006': Scene('🔨', Motion.wiggle, '✨'),
  'HOBBIES_007': Scene('🪀', Motion.bounce, '✨'),
  'HOBBIES_008': Scene('🔭', Motion.pop, '⭐'),
  'HOBBIES_009': Scene('🧱', Motion.rain, '✨'),
  'HOBBIES_010': Scene('💎', Motion.spin, '✨'),
};

/// Pictures for habits people name themselves, found by their words (in
/// English, Hebrew and a few other languages). The first match wins, so the
/// more specific words come first.
const _wordScenes = <(List<String>, Scene)>[
  (
    ['smok', 'cigar', 'vap', 'סיגר', 'עישון', 'לעשן', 'تدخين'],
    Scene('🚬', Motion.ban, '💨'),
  ),
  (
    ['alcohol', 'beer', 'wine', 'drunk', 'אלכוהול', 'בירה', 'יין'],
    Scene('🍺', Motion.ban, '🍷'),
  ),
  (
    ['sugar', 'sweet', 'candy', 'chocolate', 'סוכר', 'ממתק', 'שוקולד'],
    Scene('🍭', Motion.ban, '🍬'),
  ),
  (['coffee', 'קפה'], Scene('☕', Motion.float, '✨')),
  ([' tea', ' תה '], Scene('🍵', Motion.float, '🍃')),
  (['violin', 'כינור'], Scene('🎻', Motion.wiggle, '🎶')),
  (['piano', 'פסנתר'], Scene('🎹', Motion.wiggle, '🎶')),
  (['guitar', 'גיטרה'], Scene('🎸', Motion.wiggle, '🎶')),
  (['drum', 'תופ'], Scene('🥁', Motion.pulse, '🎶')),
  ([' sing', 'לשיר', 'שירה'], Scene('🎤', Motion.wiggle, '🎶')),
  (['music', 'מוזיקה', 'נגינה'], Scene('🎵', Motion.float, '🎶')),
  (['dog', 'כלב'], Scene('🐶', Motion.bounce, '❤️')),
  ([' cat', 'חתול'], Scene('🐱', Motion.bounce, '❤️')),
  (['fish', ' דג'], Scene('🐠', Motion.travel, '💧')),
  (['plant', 'flower', 'עציץ', 'פרח', 'צמח'], Scene('🪴', Motion.rain, '💧')),
  (['tennis', 'טניס'], Scene('🎾', Motion.bounce, '⭐')),
  (['basketball', 'כדורסל'], Scene('🏀', Motion.bounce, '⭐')),
  (['football', 'soccer', 'כדורגל'], Scene('⚽', Motion.bounce, '⭐')),
  (['swim', 'pool', 'שחי', 'בריכה'], Scene('🏊', Motion.travel, '💦')),
  (['bike', 'cycl', 'אופניים'], Scene('🚴', Motion.travel, '💨')),
  ([' run', 'jog', 'ריצה', 'לרוץ'], Scene('🏃', Motion.travel, '💨')),
  (['walk', 'הליכה', 'ללכת'], Scene('🚶', Motion.travel, '👣')),
  (['hike', 'hiking', 'טיול'], Scene('🥾', Motion.travel, '🌲')),
  (['yoga', 'יוגה'], Scene('🤸', Motion.spin, '✨')),
  (['meditat', 'מדיט'], Scene('🧘', Motion.pulse, '🕊️')),
  (['pray', 'תפיל', 'להתפלל'], Scene('🕯️', Motion.pulse, '✨')),
  (
    ['gym', 'workout', 'exercise', 'כושר', 'אימון'],
    Scene('💪', Motion.pulse, '⚡'),
  ),
  (['danc', 'ריקוד', 'לרקוד'], Scene('💃', Motion.wiggle, '🎶')),
  (['draw', 'ציור', 'לצייר'], Scene('🖍️', Motion.wiggle, '⭐')),
  (['paint', 'צבע'], Scene('🎨', Motion.spin, '🖌️')),
  (['chess', 'שחמט'], Scene('♟️', Motion.bounce, '⭐')),
  (['lego', 'לגו'], Scene('🧱', Motion.rain, '✨')),
  (['game', 'play', 'משחק', 'לשחק'], Scene('🎲', Motion.spin, '🎉')),
  (['movie', 'film', 'סרט'], Scene('🎬', Motion.pop, '🍿')),
  (['book', ' read', 'ספר', 'לקרוא', 'קריאה'], Scene('📚', Motion.float, '✨')),
  (
    ['homework', 'study', 'שיעורי', 'ללמוד', 'לימוד'],
    Scene('📝', Motion.pop, '⭐'),
  ),
  (
    ['cook', 'bake', 'לבשל', 'בישול', 'לאפות'],
    Scene('🧑‍🍳', Motion.wiggle, '✨'),
  ),
  (
    ['clean', 'tidy', 'לנקות', 'ניקיון', 'לסדר'],
    Scene('🧹', Motion.wiggle, '✨'),
  ),
  (['dish', 'כלים'], Scene('🧽', Motion.wiggle, '💧')),
  (['laundry', 'כביסה'], Scene('🧺', Motion.pop, '✨')),
  (['teeth', 'tooth', 'שיניים'], Scene('🪥', Motion.wiggle, '✨')),
  (['shower', 'bath', 'מקלחת', 'אמבטיה'], Scene('🚿', Motion.rain, '💧')),
  (
    ['sleep', ' nap', 'bed', 'לישון', 'שינה', 'מיטה'],
    Scene('🛌', Motion.float, '💤'),
  ),
  (
    ['fruit', 'apple', 'פרי', 'פירות', 'תפוח'],
    Scene('🍎', Motion.bounce, '🍌'),
  ),
  (['vegetable', 'salad', 'ירק', 'סלט'], Scene('🥦', Motion.bounce, '🥕')),
  (['save', 'money', 'לחסוך', 'כסף', 'חיסכון'], Scene('🐷', Motion.rain, '🪙')),
  (['call', 'phone', 'להתקשר', 'שיחה'], Scene('📞', Motion.wiggle, '💛')),
  (['hug', 'love', 'חיבוק', 'אהבה'], Scene('🫂', Motion.pulse, '❤️')),
  (['garden', 'גינה'], Scene('🌻', Motion.grow, '🌱')),
  (['park', 'פארק'], Scene('🏞️', Motion.grow, '🦋')),
  (['beach', ' sea', 'חוף'], Scene('🏖️', Motion.grow, '🌊')),
  (['photo', 'צילום', 'לצלם'], Scene('📷', Motion.pop, '✨')),
  (['write', 'journal', 'לכתוב', 'יומן'], Scene('✍️', Motion.wiggle, '✨')),
];

/// Words that mean the habit is something to stop, so its picture is
/// crossed out ("No phone at dinner", "בלי ממתקים").
const _quitWords = [
  'no ',
  'not ',
  "don't",
  'stop',
  'quit',
  'avoid',
  'less ',
  'without',
  'בלי',
  'לא ',
  'להפסיק',
  'ללא',
  'بدون',
  'sin ',
];

/// The habit's own picture: from its template when it came from the
/// library, otherwise from the words in its name. Null means the habit gets
/// its category's animation.
Scene? sceneFor(Habit habit) {
  final fromTemplate = habitScenes[habit.templateId];
  if (fromTemplate != null) return fromTemplate;
  final text = ' ${habit.name.toLowerCase()}';
  final quitting =
      _quitWords.any(text.contains) ||
      switch (habit.category) {
        BuiltInRef(category: BuiltInCategory.breakHabit) => true,
        _ => false,
      };
  for (final (words, scene) in _wordScenes) {
    if (words.any(text.contains)) {
      return quitting && scene.motion != Motion.ban
          ? Scene(scene.emoji, Motion.ban, scene.extra)
          : scene;
    }
  }
  return null;
}

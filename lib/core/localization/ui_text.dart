import '../../models/bi.dart';

/// Texts for the new screens, in both languages. (The original menu texts
/// live in the ARB files.)
class UiText {
  static const Bi tapToPlay = Bi('Tap a picture to play!', 'खेलने के लिए चित्र छुओ!');
  static const Bi continuePlaying = Bi('Continue', 'आगे खेलो');
  static const Bi play = Bi('Play', 'खेलो');
  static const Bi next = Bi('Next', 'आगे');
  static const Bi finish = Bi('Finish', 'पूरा करो');
  static const Bi playAgain = Bi('Play again', 'फिर खेलो');
  static const Bi nextLevel = Bi('Next level', 'अगला स्तर');
  static const Bi allLevels = Bi('All levels', 'सभी स्तर');
  static const Bi tryAgain = Bi('Let’s try again!', 'चलो फिर कोशिश करते हैं!');
  static const Bi howToPlay = Bi('How to play', 'कैसे खेलें');
  static const Bi moves = Bi('Moves', 'चालें');
  static const Bi findPairs = Bi('Find the matching pairs!', 'जोड़ियाँ खोजो!');
  static const Bi puzzleTitle = Bi('Make the picture!', 'चित्र बनाओ!');
  static const Bi puzzleTap =
      Bi('Tap two pieces to swap them.', 'दो टुकड़े छूकर उन्हें बदलो।');
  static const Bi easy = Bi('Easy', 'आसान');
  static const Bi medium = Bi('Medium', 'मध्यम');
  static const Bi hard = Bi('Hard', 'कठिन');
  static const Bi myStars = Bi('My stars', 'मेरे तारे');
  static const Bi myBadges = Bi('My trophies', 'मेरी ट्रॉफ़ियाँ');
  static const Bi myProgress = Bi('My progress', 'मेरी प्रगति');
  static const Bi forGrownUps = Bi('For grown-ups only', 'सिर्फ़ बड़ों के लिए');
  static const Bi solveToEnter =
      Bi('Solve this to enter:', 'अंदर जाने के लिए हल करो:');
  static const Bi check = Bi('Check', 'जाँचो');
  static const Bi wrongAnswer = Bi('Not correct. Try a new one.', 'सही नहीं। नया सवाल देखो।');
  static const Bi language = Bi('Language', 'भाषा');
  static const Bi sound = Bi('Voice and sounds', 'आवाज़');
  static const Bi learning = Bi('Learning progress', 'सीखने की प्रगति');
  static const Bi resetProgress = Bi('Reset all progress', 'पूरी प्रगति मिटाओ');
  static const Bi resetAsk =
      Bi('Erase all levels and stars on this phone?', 'इस फ़ोन से सारे स्तर और तारे मिटाएँ?');
  static const Bi cancel = Bi('Cancel', 'रद्द करो');
  static const Bi erase = Bi('Erase', 'मिटाओ');
  static const Bi about = Bi('About', 'ऐप के बारे में');
  static const Bi aboutText = Bi(
      'SaralBook Kids – Play & Learn. 12 free learning games in English and Hindi for children aged 3–8. Levels never end.',
      'सरलबुक किड्स – खेलो और सीखो। 3–8 साल के बच्चों के लिए अंग्रेज़ी और हिंदी में 12 मुफ़्त खेल। स्तर कभी खत्म नहीं होते।');
  static const Bi privacy = Bi('Privacy', 'गोपनीयता');
  static const Bi privacyText = Bi(
      'This app works fully offline. It has no ads, no accounts, no purchases and no internet access. It saves only game progress (levels and stars) and your language and voice choices on this phone. No personal information is collected. The voice uses your phone’s own text-to-speech.',
      'यह ऐप पूरी तरह ऑफ़लाइन चलता है। इसमें कोई विज्ञापन, खाता, खरीदारी या इंटरनेट नहीं है। यह केवल खेल की प्रगति (स्तर और तारे) और आपकी भाषा व आवाज़ की पसंद इस फ़ोन में सहेजता है। कोई निजी जानकारी इकट्ठा नहीं की जाती। आवाज़ के लिए आपके फ़ोन का अपना टेक्स्ट-टू-स्पीच इस्तेमाल होता है।');
  static const Bi levelNumberHint = Bi('Level', 'स्तर');

  static const List<Bi> praise = [
    Bi('Great job!', 'बहुत खूब!'),
    Bi('Amazing!', 'शाबाश!'),
    Bi('Fantastic!', 'शानदार!'),
    Bi('You are a superstar!', 'आप बहुत अच्छे हैं!'),
  ];

  static Bi level(int n) => Bi('Level $n', 'स्तर $n');
  static Bi levelComplete(int n) => Bi('Level $n complete!', 'स्तर $n पूरा हुआ!');
  static Bi levelsRange(int a, int b) => Bi('Levels $a–$b', 'स्तर $a–$b');
  static Bi playLevel(int n) => Bi('Play level $n', 'स्तर $n खेलो');
  static Bi stars(int n) => Bi('$n stars', '$n तारे');
  static Bi toNextMilestone(int n) => Bi('$n of 10', '10 में से $n');
}

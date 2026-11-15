import '../models/bi.dart';

class Habit {
  const Habit(this.emoji, this.title);
  final String emoji;
  final Bi title;
}

const List<Habit> goodHabits = [
  Habit('🦷', Bi('Brush your teeth', 'दाँत साफ़ करो')),
  Habit('🧼', Bi('Wash your hands', 'हाथ धोओ')),
  Habit('🛁', Bi('Take a bath', 'नहाओ')),
  Habit('🥗', Bi('Eat healthy food', 'सेहतमंद खाना खाओ')),
  Habit('🧹', Bi('Keep things clean', 'सफ़ाई रखो')),
  Habit('🙏', Bi('Respect others', 'दूसरों का आदर करो')),
  Habit('🤝', Bi('Share with friends', 'दोस्तों के साथ बाँटो')),
  Habit('😴', Bi('Sleep on time', 'समय पर सोओ')),
  Habit('🚦', Bi('Follow road rules', 'सड़क के नियम मानो')),
];

const List<Habit> badHabits = [
  Habit('🍬', Bi('Eat too many sweets', 'बहुत मिठाई खाना')),
  Habit('🚰', Bi('Leave the tap running', 'नल खुला छोड़ना')),
  Habit('😠', Bi('Push your friends', 'दोस्तों को धक्का देना')),
  Habit('📺', Bi('Watch TV all night', 'रात भर टीवी देखना')),
  Habit('🛣️', Bi('Throw litter on the road', 'सड़क पर कचरा फेंकना')),
];

class Scenario {
  const Scenario(this.question, this.correct, this.wrong);
  final Bi question;
  final Habit correct;
  final List<Habit> wrong;
}

const List<Scenario> scenarios = [
  Scenario(
    Bi('What should you do before eating?', 'खाने से पहले क्या करना चाहिए?'),
    Habit('🧼', Bi('Wash hands', 'हाथ धोना')),
    [
      Habit('🛏️', Bi('Jump on the bed', 'बिस्तर पर कूदना')),
      Habit('📺', Bi('Watch TV', 'टीवी देखना')),
    ],
  ),
  Scenario(
    Bi('What does a red traffic light mean?', 'लाल बत्ती का क्या मतलब है?'),
    Habit('🛑', Bi('Stop', 'रुको')),
    [
      Habit('🚶', Bi('Go', 'चलो')),
      Habit('💃', Bi('Dance', 'नाचो')),
    ],
  ),
  Scenario(
    Bi('Where should we throw waste?', 'कचरा कहाँ फेंकना चाहिए?'),
    Habit('🗑️', Bi('In the dustbin', 'कूड़ेदान में')),
    [
      Habit('🛣️', Bi('On the road', 'सड़क पर')),
      Habit('🌊', Bi('In the river', 'नदी में')),
    ],
  ),
  Scenario(
    Bi('What should you do before sleeping?', 'सोने से पहले क्या करना चाहिए?'),
    Habit('🦷', Bi('Brush your teeth', 'दाँत साफ़ करो')),
    [
      Habit('🍫', Bi('Eat chocolate', 'चॉकलेट खाओ')),
      Habit('🏃', Bi('Run outside', 'बाहर दौड़ो')),
    ],
  ),
  Scenario(
    Bi('What should you do when a friend needs help?',
        'जब दोस्त को मदद चाहिए तो क्या करना चाहिए?'),
    Habit('🤝', Bi('Help them', 'उसकी मदद करो')),
    [
      Habit('🙈', Bi('Ignore them', 'अनदेखा करो')),
      Habit('🏃', Bi('Run away', 'भाग जाओ')),
    ],
  ),
  Scenario(
    Bi('What should we drink every day?', 'हमें रोज़ क्या पीना चाहिए?'),
    Habit('💧', Bi('Clean water', 'साफ़ पानी')),
    [
      Habit('🥤', Bi('Fizzy drinks', 'कोल्ड ड्रिंक')),
      Habit('🍬', Bi('Sweet syrup', 'मीठा शरबत')),
    ],
  ),
  Scenario(
    Bi('What should you do after using the toilet?',
        'शौचालय जाने के बाद क्या करना चाहिए?'),
    Habit('🧼', Bi('Wash hands', 'हाथ धोना')),
    [
      Habit('😴', Bi('Go to sleep', 'सो जाना')),
      Habit('🍽️', Bi('Start eating', 'खाना शुरू करना')),
    ],
  ),
  Scenario(
    Bi('Before crossing the road, you should…',
        'सड़क पार करने से पहले हमें…'),
    Habit('👀', Bi('Look both ways', 'दोनों तरफ़ देखना चाहिए')),
    [
      Habit('🏃', Bi('Run with eyes closed', 'आँखें बंद करके भागना चाहिए')),
      Habit('📱', Bi('Play a game', 'खेल खेलना चाहिए')),
    ],
  ),
];

class QuizItem {
  const QuizItem(this.q, this.correct, this.wrong, [this.emoji]);
  final Bi q;
  final Bi correct;
  final List<Bi> wrong;
  final String? emoji;
}

/// Verified basic general-knowledge questions (bilingual).
const List<QuizItem> quizBank = [
  QuizItem(
      Bi('Which animal gives us milk?', 'कौन-सा जानवर हमें दूध देता है?'),
      Bi('Cow', 'गाय'),
      [Bi('Lion', 'शेर'), Bi('Parrot', 'तोता'), Bi('Fish', 'मछली')],
      '🥛'),
  QuizItem(
      Bi('How many days are there in a week?',
          'एक सप्ताह में कितने दिन होते हैं?'),
      Bi('Seven', 'सात'),
      [Bi('Five', 'पाँच'), Bi('Six', 'छह'), Bi('Eight', 'आठ'), Bi('Ten', 'दस')],
      '📅'),
  QuizItem(
      Bi('Which is the biggest land animal?',
          'सबसे बड़ा ज़मीनी जानवर कौन-सा है?'),
      Bi('Elephant', 'हाथी'),
      [Bi('Dog', 'कुत्ता'), Bi('Cat', 'बिल्ली'), Bi('Rabbit', 'खरगोश')]),
  QuizItem(
      Bi('What do we use to write on paper?',
          'कागज़ पर लिखने के लिए हम क्या इस्तेमाल करते हैं?'),
      Bi('Pencil', 'पेंसिल'),
      [Bi('Spoon', 'चम्मच'), Bi('Shoe', 'जूता'), Bi('Ball', 'गेंद')]),
  QuizItem(
      Bi('Which one shines in the sky at night?',
          'रात को आसमान में कौन चमकता है?'),
      Bi('Moon', 'चाँद'),
      [Bi('Sun', 'सूरज'), Bi('Rainbow', 'इंद्रधनुष')],
      '🌙'),
  QuizItem(
      Bi('What do bees make?', 'मधुमक्खियाँ क्या बनाती हैं?'),
      Bi('Honey', 'शहद'),
      [Bi('Milk', 'दूध'), Bi('Juice', 'जूस'), Bi('Rice', 'चावल')],
      '🐝'),
  QuizItem(
      Bi('Which bird can copy human words?',
          'कौन-सा पक्षी इंसानों की बोली की नकल कर सकता है?'),
      Bi('Parrot', 'तोता'),
      [Bi('Penguin', 'पेंगुइन'), Bi('Peacock', 'मोर'), Bi('Duck', 'बत्तख')]),
  QuizItem(
      Bi('Which fruit is yellow and long?', 'कौन-सा फल पीला और लंबा होता है?'),
      Bi('Banana', 'केला'),
      [Bi('Apple', 'सेब'), Bi('Grapes', 'अंगूर'), Bi('Watermelon', 'तरबूज़')]),
  QuizItem(
      Bi('What do plants need to grow?', 'पौधों को बढ़ने के लिए क्या चाहिए?'),
      Bi('Water and sunlight', 'पानी और धूप'),
      [Bi('Plastic', 'प्लास्टिक'), Bi('Stones', 'पत्थर'), Bi('Candy', 'टॉफ़ी')],
      '🌱'),
  QuizItem(
      Bi('How many eyes do we have?', 'हमारी कितनी आँखें होती हैं?'),
      Bi('Two', 'दो'),
      [Bi('One', 'एक'), Bi('Three', 'तीन'), Bi('Four', 'चार')],
      '👀'),
  QuizItem(
      Bi('How many fingers are on one hand?',
          'एक हाथ में कितनी उँगलियाँ होती हैं?'),
      Bi('Five', 'पाँच'),
      [Bi('Three', 'तीन'), Bi('Four', 'चार'), Bi('Six', 'छह')],
      '✋'),
  QuizItem(
      Bi('Which one is a vegetable?', 'इनमें से सब्ज़ी कौन-सी है?'),
      Bi('Carrot', 'गाजर'),
      [Bi('Banana', 'केला'), Bi('Mango', 'आम'), Bi('Apple', 'सेब')]),
  QuizItem(
      Bi('Which one is a vehicle?', 'इनमें से वाहन कौन-सा है?'),
      Bi('Bus', 'बस'),
      [Bi('Chair', 'कुर्सी'), Bi('Table', 'मेज़'), Bi('Book', 'किताब')]),
  QuizItem(
      Bi('What colour is the sky on a clear day?',
          'साफ़ दिन में आसमान किस रंग का होता है?'),
      Bi('Blue', 'नीला'),
      [Bi('Green', 'हरा'), Bi('Red', 'लाल'), Bi('Black', 'काला')]),
  QuizItem(
      Bi('What do we wear on our feet?', 'हम पैरों में क्या पहनते हैं?'),
      Bi('Shoes', 'जूते'),
      [Bi('Hat', 'टोपी'), Bi('Shirt', 'कमीज़'), Bi('Bag', 'बैग')],
      '🦶'),
  QuizItem(
      Bi('What do we use to see?', 'हम देखने के लिए किसका इस्तेमाल करते हैं?'),
      Bi('Eyes', 'आँखें'),
      [Bi('Ears', 'कान'), Bi('Nose', 'नाक'), Bi('Hands', 'हाथ')]),
  QuizItem(
      Bi('What do we use to hear?', 'हम सुनने के लिए किसका इस्तेमाल करते हैं?'),
      Bi('Ears', 'कान'),
      [Bi('Eyes', 'आँखें'), Bi('Feet', 'पैर'), Bi('Teeth', 'दाँत')]),
  QuizItem(
      Bi('In which direction does the sun rise?', 'सूरज किस दिशा में उगता है?'),
      Bi('East', 'पूर्व'),
      [Bi('West', 'पश्चिम'), Bi('North', 'उत्तर'), Bi('South', 'दक्षिण')],
      '🌅'),
  QuizItem(
      Bi('Which one is a pet animal?', 'इनमें से पालतू जानवर कौन-सा है?'),
      Bi('Dog', 'कुत्ता'),
      [Bi('Lion', 'शेर'), Bi('Tiger', 'बाघ'), Bi('Wolf', 'भेड़िया')]),
  QuizItem(
      Bi('Which one gives us light and heat in the day?',
          'दिन में हमें रोशनी और गर्मी कौन देता है?'),
      Bi('Sun', 'सूरज'),
      [Bi('Ice', 'बर्फ़'), Bi('Stone', 'पत्थर'), Bi('Table', 'मेज़')],
      '☀️'),
  QuizItem(
      Bi('Where do fish live?', 'मछली कहाँ रहती है?'),
      Bi('In water', 'पानी में'),
      [Bi('In a tree', 'पेड़ पर'), Bi('In a nest', 'घोंसले में')],
      '🐟'),
  QuizItem(
      Bi('Which season is the hottest?', 'सबसे गर्म मौसम कौन-सा है?'),
      Bi('Summer', 'गर्मी'),
      [Bi('Winter', 'सर्दी'), Bi('Monsoon', 'बरसात')],
      '🌡️'),
  QuizItem(
      Bi('Which animal has a long trunk?', 'किस जानवर की लंबी सूंड होती है?'),
      Bi('Elephant', 'हाथी'),
      [Bi('Giraffe', 'जिराफ़'), Bi('Horse', 'घोड़ा'), Bi('Cow', 'गाय')]),
  QuizItem(
      Bi('Which animal has a very long neck?',
          'किस जानवर की गर्दन बहुत लंबी होती है?'),
      Bi('Giraffe', 'जिराफ़'),
      [Bi('Lion', 'शेर'), Bi('Dog', 'कुत्ता'), Bi('Rabbit', 'खरगोश')]),
  QuizItem(
      Bi('How many legs does a dog have?', 'कुत्ते के कितने पैर होते हैं?'),
      Bi('Four', 'चार'),
      [Bi('Two', 'दो'), Bi('Six', 'छह'), Bi('Eight', 'आठ')],
      '🐶'),
  QuizItem(
      Bi('How many wheels does a bicycle have?',
          'साइकिल में कितने पहिये होते हैं?'),
      Bi('Two', 'दो'),
      [Bi('Three', 'तीन'), Bi('Four', 'चार'), Bi('Six', 'छह')],
      '🚲'),
  QuizItem(
      Bi('What do we use to brush our teeth?',
          'दाँत साफ़ करने के लिए हम क्या इस्तेमाल करते हैं?'),
      Bi('Toothbrush', 'टूथब्रश'),
      [Bi('Comb', 'कंघी'), Bi('Spoon', 'चम्मच'), Bi('Pencil', 'पेंसिल')],
      '🦷'),
];

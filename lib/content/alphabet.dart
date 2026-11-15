class EnLetter {
  const EnLetter(this.letter, [this.word, this.emoji]);
  final String letter;
  final String? word;
  final String? emoji;
}

const List<EnLetter> enLetters = [
  EnLetter('A', 'Apple', '🍎'),
  EnLetter('B', 'Ball', '⚽'),
  EnLetter('C', 'Cat', '🐱'),
  EnLetter('D', 'Dog', '🐶'),
  EnLetter('E', 'Elephant', '🐘'),
  EnLetter('F', 'Fish', '🐟'),
  EnLetter('G', 'Grapes', '🍇'),
  EnLetter('H', 'Hat', '🎩'),
  EnLetter('I', 'Ice cream', '🍦'),
  EnLetter('J', 'Jeep', '🚙'),
  EnLetter('K', 'Key', '🔑'),
  EnLetter('L', 'Lion', '🦁'),
  EnLetter('M', 'Mango', '🥭'),
  EnLetter('N', 'Nose', '👃'),
  EnLetter('O', 'Orange', '🍊'),
  EnLetter('P', 'Parrot', '🦜'),
  EnLetter('Q', 'Queen', '👸'),
  EnLetter('R', 'Rabbit', '🐰'),
  EnLetter('S', 'Sun', '☀️'),
  EnLetter('T', 'Tiger', '🐯'),
  EnLetter('U', 'Umbrella', '☂️'),
  EnLetter('V', 'Van', '🚐'),
  EnLetter('W', 'Watch', '⌚'),
  EnLetter('X'),
  EnLetter('Y', 'Yacht', '⛵'),
  EnLetter('Z', 'Zebra', '🦓'),
];

class HiLetter {
  const HiLetter(this.letter, [this.word, this.emoji]);
  final String letter;
  final String? word;
  final String? emoji;
}

/// स्वर followed by व्यंजन. Letters with a picture word are marked.
/// (Please have a Hindi speaker review.)
const List<HiLetter> hiLetters = [
  HiLetter('अ'),
  HiLetter('आ', 'आम', '🥭'),
  HiLetter('इ'),
  HiLetter('ई'),
  HiLetter('उ', 'उल्लू', '🦉'),
  HiLetter('ऊ'),
  HiLetter('ऋ'),
  HiLetter('ए'),
  HiLetter('ऐ', 'ऐनक', '👓'),
  HiLetter('ओ'),
  HiLetter('औ'),
  HiLetter('अं'),
  HiLetter('अः'),
  HiLetter('क', 'कबूतर', '🕊️'),
  HiLetter('ख', 'खरगोश', '🐰'),
  HiLetter('ग'),
  HiLetter('घ', 'घड़ी', '⏰'),
  HiLetter('ङ'),
  HiLetter('च', 'चम्मच', '🥄'),
  HiLetter('छ', 'छतरी', '☂️'),
  HiLetter('ज', 'जहाज़', '🚢'),
  HiLetter('झ'),
  HiLetter('ञ'),
  HiLetter('ट', 'टमाटर', '🍅'),
  HiLetter('ठ'),
  HiLetter('ड'),
  HiLetter('ढ'),
  HiLetter('ण'),
  HiLetter('त', 'तरबूज़', '🍉'),
  HiLetter('थ'),
  HiLetter('द'),
  HiLetter('ध'),
  HiLetter('न', 'नल', '🚰'),
  HiLetter('प'),
  HiLetter('फ'),
  HiLetter('ब', 'बतख', '🦆'),
  HiLetter('भ', 'भालू', '🐻'),
  HiLetter('म', 'मछली', '🐟'),
  HiLetter('य'),
  HiLetter('र'),
  HiLetter('ल'),
  HiLetter('व'),
  HiLetter('श', 'शेर', '🦁'),
  HiLetter('ष'),
  HiLetter('स', 'सेब', '🍎'),
  HiLetter('ह', 'हाथी', '🐘'),
  HiLetter('क्ष'),
  HiLetter('त्र'),
  HiLetter('ज्ञ'),
];

import '../models/bi.dart';

const List<String> _ones = [
  'Zero', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight',
  'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen',
  'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen',
];
const List<String> _tens = [
  '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty',
  'Ninety',
];

/// Hindi number names 0-100. (Please have a Hindi speaker review.)
const List<String> hindiNumberNames = [
  'शून्य',
  'एक', 'दो', 'तीन', 'चार', 'पाँच', 'छह', 'सात', 'आठ', 'नौ', 'दस',
  'ग्यारह', 'बारह', 'तेरह', 'चौदह', 'पंद्रह', 'सोलह', 'सत्रह', 'अठारह',
  'उन्नीस', 'बीस',
  'इक्कीस', 'बाईस', 'तेईस', 'चौबीस', 'पच्चीस', 'छब्बीस', 'सत्ताईस',
  'अट्ठाईस', 'उनतीस', 'तीस',
  'इकतीस', 'बत्तीस', 'तैंतीस', 'चौंतीस', 'पैंतीस', 'छत्तीस', 'सैंतीस',
  'अड़तीस', 'उनतालीस', 'चालीस',
  'इकतालीस', 'बयालीस', 'तैंतालीस', 'चौवालीस', 'पैंतालीस', 'छियालीस',
  'सैंतालीस', 'अड़तालीस', 'उनचास', 'पचास',
  'इक्यावन', 'बावन', 'तिरपन', 'चौवन', 'पचपन', 'छप्पन', 'सत्तावन',
  'अट्ठावन', 'उनसठ', 'साठ',
  'इकसठ', 'बासठ', 'तिरसठ', 'चौंसठ', 'पैंसठ', 'छियासठ', 'सड़सठ', 'अड़सठ',
  'उनहत्तर', 'सत्तर',
  'इकहत्तर', 'बहत्तर', 'तिहत्तर', 'चौहत्तर', 'पचहत्तर', 'छिहत्तर',
  'सतहत्तर', 'अठहत्तर', 'उन्यासी', 'अस्सी',
  'इक्यासी', 'बयासी', 'तिरासी', 'चौरासी', 'पचासी', 'छियासी', 'सत्तासी',
  'अट्ठासी', 'नवासी', 'नब्बे',
  'इक्यानवे', 'बानवे', 'तिरानवे', 'चौरानवे', 'पचानवे', 'छियानवे',
  'सत्तानवे', 'अट्ठानवे', 'निन्यानवे', 'सौ',
];

String enName(int n) {
  if (n >= 0 && n < 20) return _ones[n];
  if (n < 100) {
    final t = _tens[n ~/ 10];
    final o = n % 10;
    return o == 0 ? t : '$t-${_ones[o]}';
  }
  if (n == 100) return 'One hundred';
  return '$n';
}

String devanagariDigits(int n) {
  const d = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
  return n.toString().split('').map((c) => d[int.parse(c)]).join();
}

/// The number written as digits: 12 / १२.
Bi numeral(int n) => Bi('$n', devanagariDigits(n));

/// The number as a word (only up to 100), otherwise as digits.
Bi numName(int n) =>
    (n >= 0 && n <= 100) ? Bi(enName(n), hindiNumberNames[n]) : numeral(n);

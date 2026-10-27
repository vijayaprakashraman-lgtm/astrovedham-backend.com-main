class HoroscopeRequest {
  final String zodiacSign;
  final String fullName;
  final String dateOfBirth;
  final String birthTime;
  final String birthPlace;

  const HoroscopeRequest({
    required this.zodiacSign,
    required this.fullName,
    required this.dateOfBirth,
    required this.birthTime,
    required this.birthPlace,
  });

  Map<String, dynamic> toJson() {
    return {
      'zodiac_sign': zodiacSign,
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'birth_time': birthTime,
      'birth_place': birthPlace,
    };
  }
}

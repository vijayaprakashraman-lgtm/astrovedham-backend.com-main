class HoroscopeResponse {
  final String zodiacSign;
  final String date;
  final String love;
  final String career;
  final String finance;
  final String health;
  final String luck;
  final int luckyNumber;
  final String luckyColor;
  final String luckyTime;

  const HoroscopeResponse({
    required this.zodiacSign,
    required this.date,
    required this.love,
    required this.career,
    required this.finance,
    required this.health,
    required this.luck,
    required this.luckyNumber,
    required this.luckyColor,
    required this.luckyTime,
  });

  factory HoroscopeResponse.fromJson(Map<String, dynamic> json) {
    return HoroscopeResponse(
      zodiacSign: json['zodiac_sign'],
      date: json['date'],
      love: json['love'],
      career: json['career'],
      finance: json['finance'],
      health: json['health'],
      luck: json['luck'],
      luckyNumber: json['lucky_number'],
      luckyColor: json['lucky_color'],
      luckyTime: json['lucky_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zodiac_sign': zodiacSign,
      'date': date,
      'love': love,
      'career': career,
      'finance': finance,
      'health': health,
      'luck': luck,
      'lucky_number': luckyNumber,
      'lucky_color': luckyColor,
      'lucky_time': luckyTime,
    };
  }
}

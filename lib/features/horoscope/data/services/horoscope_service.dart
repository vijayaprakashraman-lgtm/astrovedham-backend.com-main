import '../models/horoscope_request.dart';
import '../models/horoscope_response.dart';

class HoroscopeService {
  Future<HoroscopeResponse> generateHoroscope(HoroscopeRequest request) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    return HoroscopeResponse(
      zodiacSign: request.zodiacSign,
      date: DateTime.now().toString(),
      love: "Your romantic prospects are looking bright today. A unexpected gesture from someone special might brighten your afternoon. Communication is key to maintaining harmony in your relationships.",
      career: "Focus on your goals and don't let minor setbacks discourage you. Your dedication and hard work will be noticed by your superiors. It's a good day to plan for future projects.",
      finance: "Financial stability is predicted for you today. However, it's wise to avoid impulsive purchases. A small investment made now could yield good returns in the future.",
      health: "Pay attention to your diet and hydration. Incorporating a light exercise routine into your day will boost your energy levels. Ensure you get enough rest tonight.",
      luck: "Fortune favors the bold today. Trust your intuition when making decisions. An opportunity for growth might arise in an unexpected way.",
      luckyNumber: 7,
      luckyColor: "Emerald Green",
      luckyTime: "10:30 AM to 11:45 AM",
    );
  }
}

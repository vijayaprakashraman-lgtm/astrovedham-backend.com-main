import '../../data/models/horoscope_request.dart';
import '../../data/models/horoscope_response.dart';

abstract class HoroscopeRepository {
  Future<HoroscopeResponse> getDailyHoroscope(HoroscopeRequest request);
}

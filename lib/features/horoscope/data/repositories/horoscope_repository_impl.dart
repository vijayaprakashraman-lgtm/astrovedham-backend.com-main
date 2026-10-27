import '../../domain/repositories/horoscope_repository.dart';
import '../models/horoscope_request.dart';
import '../models/horoscope_response.dart';
import '../services/horoscope_service.dart';

class HoroscopeRepositoryImpl implements HoroscopeRepository {
  final HoroscopeService _service;

  HoroscopeRepositoryImpl(this._service);

  @override
  Future<HoroscopeResponse> getDailyHoroscope(HoroscopeRequest request) {
    return _service.generateHoroscope(request);
  }
}

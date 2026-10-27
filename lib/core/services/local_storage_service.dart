import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService instance = LocalStorageService._();
  LocalStorageService._();

  static const String _keyName = 'user_name';
  static const String _keyGender = 'user_gender';
  static const String _keyMobile = 'user_mobile';
  static const String _keyEmail = 'user_email';
  static const String _keyJwtToken = 'jwt_token';
  static const String _keyAboutMe = 'user_about_me';
  static const String _keyImagePath = 'user_image_path';
  static const String _keyDob = 'user_dob';
  static const String _keyBirthTime = 'user_birth_time';
  static const String _keyBirthPlace = 'user_birth_place';
  static const String _keyZodiac = 'user_zodiac';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Name
  String? getName() => _prefs.getString(_keyName);
  Future<void> setName(String name) => _prefs.setString(_keyName, name);

  // Gender
  String? getGender() => _prefs.getString(_keyGender);
  Future<void> setGender(String gender) => _prefs.setString(_keyGender, gender);

  // Mobile
  String? getMobile() => _prefs.getString(_keyMobile);
  Future<void> setMobile(String? mobile) => (mobile == null || mobile.trim().isEmpty)
      ? _prefs.remove(_keyMobile)
      : _prefs.setString(_keyMobile, mobile.trim());

  // Email
  String? getEmail() => _prefs.getString(_keyEmail);
  Future<void> setEmail(String email) => _prefs.setString(_keyEmail, email);

  // JWT Token
  String? getJwtToken() => _prefs.getString(_keyJwtToken);
  Future<void> setJwtToken(String token) => _prefs.setString(_keyJwtToken, token);
  Future<void> clearJwtToken() => _prefs.remove(_keyJwtToken);

  Future<void> clearAuthSession() async {
    await _prefs.remove(_keyJwtToken);
    await _prefs.remove(_keyName);
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyMobile);
    await _prefs.remove(_keyGender);
  }

  // About Me
  String? getAboutMe() => _prefs.getString(_keyAboutMe);
  Future<void> setAboutMe(String? aboutMe) => aboutMe == null
      ? _prefs.remove(_keyAboutMe)
      : _prefs.setString(_keyAboutMe, aboutMe);

  // Image Path
  String? getImagePath() => _prefs.getString(_keyImagePath);
  Future<void> setImagePath(String? path) {
    if (path == null) {
      return _prefs.remove(_keyImagePath);
    }
    return _prefs.setString(_keyImagePath, path);
  }

  // DOB
  String? getDob() => _prefs.getString(_keyDob);
  Future<void> setDob(String? dob) =>
      dob == null ? _prefs.remove(_keyDob) : _prefs.setString(_keyDob, dob);

  // Birth Time
  String? getBirthTime() => _prefs.getString(_keyBirthTime);
  Future<void> setBirthTime(String? time) => time == null
      ? _prefs.remove(_keyBirthTime)
      : _prefs.setString(_keyBirthTime, time);

  // Birth Place
  String? getBirthPlace() => _prefs.getString(_keyBirthPlace);
  Future<void> setBirthPlace(String? place) => place == null
      ? _prefs.remove(_keyBirthPlace)
      : _prefs.setString(_keyBirthPlace, place);

  // Zodiac
  String? getZodiac() => _prefs.getString(_keyZodiac);
  Future<void> setZodiac(String? zodiac) => zodiac == null
      ? _prefs.remove(_keyZodiac)
      : _prefs.setString(_keyZodiac, zodiac);

  // Onboarding
  bool isOnboardingCompleted() =>
      _prefs.getBool(_keyOnboardingCompleted) ?? false;
  Future<void> setOnboardingCompleted(bool completed) =>
      _prefs.setBool(_keyOnboardingCompleted, completed);
}

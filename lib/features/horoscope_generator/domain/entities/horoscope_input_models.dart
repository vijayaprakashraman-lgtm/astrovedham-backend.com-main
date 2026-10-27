import 'package:flutter/material.dart';

enum Gender { male, female }

class BaseHoroscopeInput {
  final String fullName;
  final Gender gender;
  final DateTime dateOfBirth;
  final TimeOfDay? birthTime;
  final String birthPlace;
  final String? mobileNumber;
  final String? email;

  const BaseHoroscopeInput({
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    this.birthTime,
    required this.birthPlace,
    this.mobileNumber,
    this.email,
  });
}

class LifeHoroscopeInput extends BaseHoroscopeInput {
  final String? currentCity;
  final String? currentCountry;

  const LifeHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    super.mobileNumber,
    super.email,
    this.currentCity,
    this.currentCountry,
  });
}

class SuperLifeHoroscopeInput extends LifeHoroscopeInput {
  final String currentOccupation;
  final String maritalStatus;
  final String educationLevel;
  final List<String> lifeFocusAreas;

  const SuperLifeHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    super.mobileNumber,
    super.email,
    super.currentCity,
    super.currentCountry,
    required this.currentOccupation,
    required this.maritalStatus,
    required this.educationLevel,
    required this.lifeFocusAreas,
  });
}

class MarriageMatchingInput {
  final BaseHoroscopeInput person1;
  final BaseHoroscopeInput person2;
  final String? mobileNumber;
  final String? email;

  const MarriageMatchingInput({
    required this.person1,
    required this.person2,
    this.mobileNumber,
    this.email,
  });
}

class MarriageHoroscopeInput extends BaseHoroscopeInput {
  final String maritalStatus;
  final List<String> marriageInterests;

  const MarriageHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    super.mobileNumber,
    super.email,
    required this.maritalStatus,
    required this.marriageInterests,
  });
}

class WealthHoroscopeInput extends BaseHoroscopeInput {
  final String employmentStatus;
  final String incomeSource;
  final List<String> wealthFocusAreas;

  const WealthHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.employmentStatus,
    required this.incomeSource,
    required this.wealthFocusAreas,
  });
}

class YearlyPredictionInput extends BaseHoroscopeInput {
  final int targetYear;
  final List<String> focusAreas;

  const YearlyPredictionInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.targetYear,
    required this.focusAreas,
  });
}

class GemstoneHoroscopeInput extends BaseHoroscopeInput {
  final String purpose;
  final String? preferredGemstone;
  final String? budgetRange;

  const GemstoneHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.purpose,
    this.preferredGemstone,
    this.budgetRange,
  });
}

class NumerologyInput {
  final String fullName;
  final DateTime dateOfBirth;
  final String? preferredName;
  final String? nickname;
  final List<String> analysisTypes;

  const NumerologyInput({
    required this.fullName,
    required this.dateOfBirth,
    this.preferredName,
    this.nickname,
    required this.analysisTypes,
  });
}

class CareerHoroscopeInput extends BaseHoroscopeInput {
  final String employmentStatus;
  final String currentOccupation;
  final List<String> careerGoals;
  final String? industry;
  final String? experience;

  const CareerHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.employmentStatus,
    required this.currentOccupation,
    required this.careerGoals,
    this.industry,
    this.experience,
  });
}

class HealthHoroscopeInput extends BaseHoroscopeInput {
  final List<String> wellnessFocus;
  final String? lifestyle;

  const HealthHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.wellnessFocus,
    this.lifestyle,
  });
}

class LoveRelationshipInput extends BaseHoroscopeInput {
  final String relationshipStatus;
  final List<String> focusAreas;

  const LoveRelationshipInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.relationshipStatus,
    required this.focusAreas,
  });
}

class ChildBirthInput extends BaseHoroscopeInput {
  final String familyStatus;
  final List<String> focusAreas;

  const ChildBirthInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.familyStatus,
    required this.focusAreas,
  });
}

class DoshaAnalysisInput extends BaseHoroscopeInput {
  final List<String> selectedDoshas;
  final String? specificConcern;

  const DoshaAnalysisInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.selectedDoshas,
    this.specificConcern,
  });
}

class EducationHoroscopeInput extends BaseHoroscopeInput {
  final String educationStatus;
  final List<String> educationFocus;
  final String? currentCourse;
  final String? targetExam;

  const EducationHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.educationStatus,
    required this.educationFocus,
    this.currentCourse,
    this.targetExam,
  });
}

class PropertyVehicleInput extends BaseHoroscopeInput {
  final String purpose;
  final String? propertyType;
  final String? vehicleType;
  final int? preferredYear;
  final int? preferredMonth;

  const PropertyVehicleInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.purpose,
    this.propertyType,
    this.vehicleType,
    this.preferredYear,
    this.preferredMonth,
  });
}

class TravelHoroscopeInput extends BaseHoroscopeInput {
  final String travelPurpose;
  final String? destinationCountry;
  final String? destinationCity;
  final int? preferredYear;
  final int? preferredMonth;

  const TravelHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.travelPurpose,
    this.destinationCountry,
    this.destinationCity,
    this.preferredYear,
    this.preferredMonth,
  });
}

class BusinessHoroscopeInput extends BaseHoroscopeInput {
  final String businessStatus;
  final List<String> businessFocus;
  final String? businessName;
  final String? industry;
  final String? yearsInBusiness;

  const BusinessHoroscopeInput({
    required super.fullName,
    required super.gender,
    required super.dateOfBirth,
    super.birthTime,
    required super.birthPlace,
    required this.businessStatus,
    required this.businessFocus,
    this.businessName,
    this.industry,
    this.yearsInBusiness,
  });
}

enum RevelationType { meccan, medinan }

RevelationType revelationTypeFromJson(String value) =>
    value == 'Medinan' ? RevelationType.medinan : RevelationType.meccan;

/// One of the 114 sourates. Static reference data only — no memorization
/// state here (that lives in [AppDatabase], see core/database).
class Surah {
  const Surah({
    required this.number,
    required this.nameArabic,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json['number'] as int,
        nameArabic: json['nameArabic'] as String,
        englishName: json['englishName'] as String,
        englishNameTranslation: json['englishNameTranslation'] as String,
        numberOfAyahs: json['numberOfAyahs'] as int,
        revelationType: revelationTypeFromJson(json['revelationType'] as String),
      );

  final int number;
  final String nameArabic;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final RevelationType revelationType;
}

/// Start position (first ayah) of one of the 30 Juz.
class JuzBoundary {
  const JuzBoundary({required this.juz, required this.surah, required this.ayah});

  factory JuzBoundary.fromJson(Map<String, dynamic> json) => JuzBoundary(
        juz: json['juz'] as int,
        surah: json['surah'] as int,
        ayah: json['ayah'] as int,
      );

  final int juz;
  final int surah;
  final int ayah;
}

/// Start position (first ayah) of one of the 60 Hizb.
class HizbBoundary {
  const HizbBoundary({required this.hizb, required this.surah, required this.ayah});

  factory HizbBoundary.fromJson(Map<String, dynamic> json) => HizbBoundary(
        hizb: json['hizb'] as int,
        surah: json['surah'] as int,
        ayah: json['ayah'] as int,
      );

  final int hizb;
  final int surah;
  final int ayah;
}

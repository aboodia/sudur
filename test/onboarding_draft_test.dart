import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/features/onboarding/onboarding_draft.dart';

void main() {
  test('derivedLevel is debutant with nothing memorized', () {
    const draft = OnboardingDraft();
    expect(draft.derivedLevel, OnboardingLevel.debutant);
  });

  test('derivedLevel is en_cours with some but not all sourates', () {
    final draft = OnboardingDraft(memorizedSurahs: {1, 2, 114});
    expect(draft.derivedLevel, OnboardingLevel.enCours);
  });

  test('derivedLevel is hafiz only when all 114 sourates are memorized', () {
    final all114 = Set<int>.of(List.generate(114, (i) => i + 1));
    final almostAll = Set<int>.of(List.generate(113, (i) => i + 1));

    expect(OnboardingDraft(memorizedSurahs: all114).derivedLevel, OnboardingLevel.hafiz);
    expect(OnboardingDraft(memorizedSurahs: almostAll).derivedLevel, OnboardingLevel.enCours);
  });

  test('dbValue matches the strings stored in UserProfiles.memorizationLevel', () {
    expect(OnboardingLevel.debutant.dbValue, 'debutant');
    expect(OnboardingLevel.enCours.dbValue, 'en_cours');
    expect(OnboardingLevel.hafiz.dbValue, 'hafiz');
  });
}

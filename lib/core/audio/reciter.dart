class Reciter {
  const Reciter({
    required this.id,
    required this.name,
    required this.editionIdentifier,
  });

  /// alquran.cloud/cdn.islamic.network audio edition identifier.
  final String id;
  final String name;
  final String editionIdentifier;
}

/// Curated list of well-known reciters with verse-by-verse audio available
/// on cdn.islamic.network (no API key needed). Chosen for clarity of
/// recitation, useful for both listening and memorization.
const kReciters = [
  Reciter(
    id: 'alafasy',
    name: 'Mishary Alafasy',
    editionIdentifier: 'ar.alafasy',
  ),
  Reciter(
    id: 'husary',
    name: 'Mahmoud Khalil Al-Husary',
    editionIdentifier: 'ar.husary',
  ),
  Reciter(
    id: 'abdulbasit',
    name: 'Abdul Basit (Murattal)',
    editionIdentifier: 'ar.abdulbasitmurattal',
  ),
  Reciter(
    id: 'sudais',
    name: 'Abdurrahman As-Sudais',
    editionIdentifier: 'ar.abdurrahmaansudais',
  ),
  Reciter(
    id: 'minshawi',
    name: 'Mohamed Siddiq Al-Minshawi',
    editionIdentifier: 'ar.minshawi',
  ),
  Reciter(
    id: 'muaiqly',
    name: 'Maher Al-Muaiqly',
    editionIdentifier: 'ar.mahermuaiqly',
  ),
];

const kDefaultReciterId = 'alafasy';

Reciter reciterById(String id) =>
    kReciters.firstWhere((r) => r.id == id, orElse: () => kReciters.first);

/// Builds the streaming URL for one ayah, addressed by its global position
/// (1-6236) across the whole Mushaf — see
/// [QuranTextRepository.globalAyahNumber].
String ayahAudioUrl(
  Reciter reciter,
  int globalAyahNumber, {
  int bitrateKbps = 128,
}) {
  return 'https://cdn.islamic.network/quran/audio/$bitrateKbps/${reciter.editionIdentifier}/$globalAyahNumber.mp3';
}

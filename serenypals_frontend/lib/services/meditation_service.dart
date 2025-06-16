import '../models/meditation.dart'; // Pastikan path ini benar

class MeditationApiService {
  // Dummy data meditasi
  final List<MeditationTip> _meditationTips = const [
    MeditationTip(
      title: 'Fokus pada Napas',
      description:
          'Luangkan beberapa menit untuk duduk dengan tenang dan perhatikan napas Anda. Rasakan sensasi udara masuk dan keluar dari tubuh Anda. Jika pikiran Anda mengembara, dengan lembut bawa kembali fokus Anda pada napas.',
    ),
    MeditationTip(
      title: 'Pemindaian Tubuh',
      description:
          'Berbaringlah dengan nyaman dan perhatikan setiap bagian tubuh Anda, mulai dari ujung kaki hingga kepala. Perhatikan sensasi apa pun tanpa menghakimi, dan lepaskan ketegangan yang mungkin Anda rasakan.',
    ),
    MeditationTip(
      title: 'Meditasi Berjalan',
      description:
          'Perhatikan setiap langkah saat Anda berjalan. Rasakan kontak kaki Anda dengan tanah, gerakan tubuh Anda, dan sensasi angin. Ini adalah cara yang bagus untuk tetap sadar saat bergerak.',
    ),
    MeditationTip(
      title: 'Visualisasi Tenang',
      description:
          'Bayangkan diri Anda di tempat yang damai dan menenangkan. Rasakan sensasi, dengar suara, dan lihat pemandangan. Biarkan imajinasi Anda membawa Anda ke keadaan relaksasi yang mendalam.',
    ),
  ];

  Future<List<MeditationTip>> fetchMeditationTips() async {
    // Simulasi penundaan jaringan
    await Future.delayed(const Duration(milliseconds: 700));
    return _meditationTips;
  }
}

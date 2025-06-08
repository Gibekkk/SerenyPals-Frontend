import '../models/meditation.dart'; // Sesuaikan import path

class GetMeditationTipsUseCase {
  // Dalam aplikasi nyata, ini akan berinteraksi dengan repository
  // untuk mengambil data (misalnya, dari JSON lokal, API, atau database).
  // Untuk contoh ini, kita akan hardcode datanya.

  Future<List<MeditationTip>> execute() async {
    // Simulasikan panggilan jaringan/database
    await Future.delayed(const Duration(milliseconds: 500));

    return const [
      MeditationTip(
        title: 'Cari Tempat Tenang',
        description:
            'Pilih tempat yang tenang dan nyaman, bebas dari gangguan.',
      ),
      MeditationTip(
        title: 'Duduk dengan Nyaman',
        description:
            'Kamu bisa duduk di kursi, di lantai, atau bahkan berbaring—yang penting tubuh rileks, tapi tetap sadar.',
      ),
      MeditationTip(
        title: 'Tutup Mata & Fokus pada Napas',
        description:
            'Tutup mata perlahan. Arahkan perhatian ke napas. Rasakan udara masuk dan keluar dari hidung atau dada/perut yang naik turun.',
      ),
      MeditationTip(
        title: 'Biarkan Pikiran Datang dan Pergi',
        description:
            'Kalau pikiran mulai melayang (dan itu wajar!), cukup sadari dan kembalikan fokus ke napas. Jangan menghakimi diri sendiri.',
      ),
      MeditationTip(
        title: 'Durasi Singkat Tidak Masalah',
        description:
            'Mulailah dengan 5-10 menit per hari. Seiring waktu, kamu bisa menambah durasinya.',
      ),
    ];
  }
}

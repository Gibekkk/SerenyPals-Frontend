import '../models/meditation.dart'; // Pastikan path ke model MeditationTip Anda benar
import '../services/meditation_service.dart'; // Import MeditationApiService yang sudah ada

class MeditationRepository {
  final MeditationApiService _apiService;

  // Konstruktor untuk menginisialisasi MeditationRepository dengan MeditationApiService
  MeditationRepository(this._apiService);

  // Method untuk mendapatkan daftar tips meditasi dari service
  Future<List<MeditationTip>> getMeditationTips() async {
    return await _apiService.fetchMeditationTips();
  }

  // Anda bisa menambahkan method lain di sini jika ada operasi lain yang perlu dilakukan
  // pada data meditasi (misalnya, menambahkan, memperbarui, menghapus, jika ada kebutuhan di masa depan)
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/meditation/mediation_event.dart';
import '../../blocs/meditation/meditation_bloc.dart';
import '../../blocs/meditation/meditation_state.dart';
import '../../utils/meditation_tips.dart';
import '../../widget/meditasi.dart';

class MeditationTipsScreen extends StatelessWidget {
  const MeditationTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeditationTipsBloc(
        getMeditationTipsUseCase:
            GetMeditationTipsUseCase(), // Inject use case Anda
      )..add(LoadMeditationTips()), // Memuat tips saat screen dibuat
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF3F6FA), // Light background color dari gambar
        body: Stack(
          children: [
            // Top background image / Illustration
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.35, // Sesuaikan sesuai kebutuhan
                decoration: const BoxDecoration(
                  color: Color(0xFF4A4585), // Dark purple dari gambar
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    // Placeholder for the main illustration
                    Center(
                      child: Image.asset(
                        'assets/meditation_illustration.png', // Ganti dengan path aset Anda yang sebenarnya
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Back button
                    Positioned(
                      top: 40,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          // Gunakan GoRouter untuk kembali jika diimplementasikan
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            // Fallback jika tidak ada route sebelumnya atau GoRouter tidak digunakan
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content Card
            Positioned.fill(
              top: MediaQuery.of(context).size.height *
                  0.3, // Sesuaikan agar overlap dengan gambar di atas
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F6FA), // Light background color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFB4A7E0), // Purple star background
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.star,
                              color: Colors.white, size: 28),
                        ),
                      ),
                      const Text(
                        'Tips Meditasi',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E263D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Latihan sederhana untuk menenangkan diri',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4C5D72),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: BlocBuilder<MeditationTipsBloc,
                            MeditationTipsState>(
                          builder: (context, state) {
                            if (state is MeditationTipsLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is MeditationTipsLoaded) {
                              return ListView.builder(
                                padding: EdgeInsets
                                    .zero, // Hapus padding default listview
                                itemCount: state.tips.length,
                                itemBuilder: (context, index) {
                                  return MeditationTipCard(
                                    index: index,
                                    tip: state.tips[index],
                                  );
                                },
                              );
                            } else if (state is MeditationTipsError) {
                              return Center(
                                  child: Text('Error: ${state.message}'));
                            }
                            return const Center(
                                child: Text('Tidak ada tips yang tersedia.'));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Navigation Bar (Placeholder) - Sesuaikan dengan MainTabScaffold Anda
          ],
        ),
      ),
    );
  }
}

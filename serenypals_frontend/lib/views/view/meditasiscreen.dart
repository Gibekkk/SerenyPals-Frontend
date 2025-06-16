import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:serenypals_frontend/utils/color.dart';

import '../../blocs/meditation/mediation_event.dart';
import '../../blocs/meditation/meditation_bloc.dart';
import '../../blocs/meditation/meditation_state.dart';
// Hapus import yang tidak lagi diperlukan:
// import '../../utils/meditation_tips.dart';
// Import services dan repository yang sudah kita buat:
import '../../services/meditation_service.dart';
import '../../repositories/meditation_repository.dart';
import '../../models/meditation.dart';
// Diperlukan untuk MeditationTip

class MeditationTipsScreen extends StatefulWidget {
  const MeditationTipsScreen({Key? key}) : super(key: key);

  @override
  State<MeditationTipsScreen> createState() => _MeditationTipsScreenState();
}

class _MeditationTipsScreenState extends State<MeditationTipsScreen> {
  bool isFavorite = false; // <- Pindahkan ke sini

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final meditationApiService = MeditationApiService();
        final meditationRepository = MeditationRepository(meditationApiService);
        return MeditationTipsBloc(
          meditationRepository: meditationRepository,
        )..add(LoadMeditationTips());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F6FA),
        body: Stack(
          children: [
            // TOP SECTION
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: const BoxDecoration(
                  color: color6,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/img/gambarlogin1.png',
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 16,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // CONTENT
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                decoration: const BoxDecoration(
                  color: color4,
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

                      // FAVORITE BUTTON
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB4A7E0),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.star,
                              color: isFavorite ? Colors.yellow : Colors.white,
                              size: 28,
                            ),
                          ),
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

                      // LIST OF TIPS
                      Expanded(
                        child: BlocBuilder<MeditationTipsBloc,
                            MeditationTipsState>(
                          builder: (context, state) {
                            if (state is MeditationTipsLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is MeditationTipsLoaded) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
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
          ],
        ),
      ),
    );
  }
}

class MeditationTipCard extends StatelessWidget {
  final int index;
  final MeditationTip tip;

  const MeditationTipCard({
    Key? key,
    required this.index,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Anda bisa menyesuaikan tampilan card ini sesuai desain Anda
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white, // Warna card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ${tip.title}', // Menampilkan nomor dan judul
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E263D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tip.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4C5D72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

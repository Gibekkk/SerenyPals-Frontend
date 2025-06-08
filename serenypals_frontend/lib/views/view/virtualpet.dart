import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PetState(),
      child: MaterialApp(
        title: 'Virtual Pet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const VirtualPetPage(),
      ),
    );
  }
}

class PetState extends ChangeNotifier {
  String currentAnimation = 'idle';
  double energy = 100;
  double hunger = 100;

  int _consecutiveCriticalTicks = 0;

  bool get isAngry =>
      _consecutiveCriticalTicks >=
      5; // Status marah tetap ada untuk logika lain (misal: berkedip)

  final AudioPlayer _bgMusicPlayer = AudioPlayer();
  bool _isBgMusicPlaying = false;
  bool _hasUserInteractedWithMusicToggle = false;

  bool get isMusicPlaying => _isBgMusicPlaying;

  PetState() {
    print('PetState constructor called.');
    print('Attempting to initialize background music.');

    Timer.periodic(const Duration(seconds: 1), (timer) {
      hunger -= 0.5;
      energy -= 0.3;

      if (hunger < 0) hunger = 0;
      if (energy < 0) energy = 0;

      bool wasCritical = (hunger <= 0 || energy <= 0);

      if (wasCritical) {
        _consecutiveCriticalTicks++;
      } else {
        _consecutiveCriticalTicks = 0;
      }
      notifyListeners();
    });
  }

  Future<void> _playBackgroundMusicAsset() async {
    print(' _playBackgroundMusicAsset called directly from toggle.');
    try {
      await _bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgMusicPlayer.setVolume(0.5);
      await _bgMusicPlayer.play(AssetSource('audio/background_music.mp3'));
      _isBgMusicPlaying = true;
      print('Background music started successfully from asset.');
    } catch (e) {
      print('!!! ERROR playing background music asset: $e');
      print('Please check:');
      print(
        '1. Is "assets/audio/background_music.mp3" the correct path in pubspec.yaml and in your project folder?',
      );
      print('2. Did you run "flutter pub get" after adding the asset?');
      print('3. Is your audio file valid (not corrupted)?');
      _isBgMusicPlaying = false;
    }
    notifyListeners();
  }

  Future<void> _pauseBackgroundMusic() async {
    print(' _pauseBackgroundMusic called.');
    if (_isBgMusicPlaying) {
      await _bgMusicPlayer.pause();
      _isBgMusicPlaying = false;
      notifyListeners();
    }
  }

  Future<void> _resumeBackgroundMusic() async {
    print(' _resumeBackgroundMusic called.');
    if (!_isBgMusicPlaying) {
      await _bgMusicPlayer.resume();
      _isBgMusicPlaying = true;
      notifyListeners();
    }
  }

  void toggleBackgroundMusic() {
    if (!_hasUserInteractedWithMusicToggle) {
      _playBackgroundMusicAsset();
      _hasUserInteractedWithMusicToggle = true;
      print('First music toggle interaction. Music should now play.');
    } else {
      if (_isBgMusicPlaying) {
        _pauseBackgroundMusic();
      } else {
        _resumeBackgroundMusic();
      }
    }
  }

  void startEating() {
    currentAnimation = 'eating';
    hunger += 20;
    if (hunger > 100) hunger = 100;
    _consecutiveCriticalTicks = 0;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      currentAnimation = 'idle';
      notifyListeners();
    });
  }

  void startPlaying() {
    currentAnimation = 'playing';
    energy -= 15;
    if (energy < 0) energy = 0;
    hunger -= 10;
    if (hunger < 0) hunger = 0;
    _consecutiveCriticalTicks = 0;
    notifyListeners();
    Future.delayed(const Duration(seconds: 5), () {
      currentAnimation = 'idle';
      notifyListeners();
    });
  }

  void startSleeping() {
    currentAnimation = 'sleeping';
    energy += 30;
    if (energy > 100) energy = 100;
    _consecutiveCriticalTicks = 0;
    notifyListeners();
    Future.delayed(const Duration(seconds: 7), () {
      currentAnimation = 'idle';
      notifyListeners();
    });
  }

  String get animation => currentAnimation;
  double get currentEnergy => energy;
  double get currentHunger => hunger;

  @override
  void dispose() {
    print('PetState dispose called. Disposing audio player.');
    _bgMusicPlayer.dispose();
    super.dispose();
  }
}

class VirtualPetPage extends StatefulWidget {
  const VirtualPetPage({super.key});

  @override
  State<VirtualPetPage> createState() => _VirtualPetPageState();
}

class _VirtualPetPageState extends State<VirtualPetPage> {
  Timer? _blinkTimer;
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petState = Provider.of<PetState>(context, listen: false);

      petState.addListener(() {
        if (petState.isAngry && _blinkTimer == null) {
          _startBlinking();
        } else if (!petState.isAngry && _blinkTimer != null) {
          _stopBlinking();
        }
      });
    });
  }

  void _startBlinking() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _isBlinking = !_isBlinking;
      });
    });
  }

  void _stopBlinking() {
    _blinkTimer?.cancel();
    _blinkTimer = null;
    setState(() {
      _isBlinking = false;
    });
  }

  @override
  void dispose() {
    _stopBlinking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petState = Provider.of<PetState>(context);

    // Variabel messageColor ini tidak digunakan untuk warna pesan karena pesan teks dihapus
    // final messageColor = petState.isAngry
    //     ? Colors.redAccent.shade700
    //     : Colors.blueAccent;

    // Bagian criticalMessages ini sekarang tidak digunakan karena pesan teks sudah dihapus
    // List<Widget> criticalMessages = [];
    // double opacity = petState.isAngry && !_isBlinking ? 0.0 : 1.0;
    // if (petState.hunger <= 0) { ... }
    // if (petState.energy <= 0) { ... }

    Widget petImage = Image.asset(
      'assets/capybara_pet.png',
      width: 250,
      height: 250,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F0E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFD3EBF5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.star, color: Colors.orange, size: 18),
                SizedBox(width: 5),
                Text(
                  '999',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFD3EBF5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.diamond, color: Colors.blueAccent, size: 18),
                SizedBox(width: 5),
                Text(
                  '999',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.add, color: Colors.black, size: 18),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          petState.isMusicPlaying
                              ? Icons.music_note
                              : Icons.music_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Provider.of<PetState>(
                            context,
                            listen: false,
                          ).toggleBackgroundMusic();
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // HAPUS KONDISI INI UNTUK criticalMessages
                // if (criticalMessages.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 15.0),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: criticalMessages,
                //     ),
                //   ),
                const Text(
                  'Bleki',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                petImage,
                const SizedBox(height: 20),
                Text('Energy: ${petState.currentEnergy.toStringAsFixed(0)}'),
                Text('Hunger: ${petState.currentHunger.toStringAsFixed(0)}'),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tombol "Makan" - Warna berdasarkan hunger
                _buildActionButton(
                  context,
                  Icons.fastfood,
                  'Makan',
                  petState.hunger,
                  petState.energy,
                  () {
                    Provider.of<PetState>(context, listen: false).startEating();
                  },
                ),
                // Tombol "Main" - Warna berdasarkan energy (akan selalu normal di sini)
                _buildActionButton(
                  context,
                  Icons.directions_walk,
                  'Main',
                  petState.hunger,
                  petState.energy,
                  () {
                    Provider.of<PetState>(
                      context,
                      listen: false,
                    ).startPlaying();
                  },
                ),
                // Tombol "Tidur" - Warna berdasarkan energy
                _buildActionButton(
                  context,
                  Icons.nightlight_round,
                  'Tidur',
                  petState.hunger,
                  petState.energy,
                  () {
                    Provider.of<PetState>(
                      context,
                      listen: false,
                    ).startSleeping();
                  },
                ),
                // Tombol "Toko" - Tidak berubah warna
                _buildActionButton(context, Icons.store, 'Toko', 100, 100, () {
                  // Pass nilai default agar tidak berubah
                  // Handle Toko action
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi pembantu _buildActionButton yang dimodifikasi
  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    double currentHunger,
    double currentEnergy,
    VoidCallback onPressed,
  ) {
    Color buttonBackgroundColor = const Color(0xFFE0F7FA); // Warna default

    // Logika untuk mengubah warna tombol berdasarkan status
    if (label == 'Makan' && currentHunger <= 0) {
      buttonBackgroundColor = Colors.red.shade100; // Merah jika lapar
    } else if (label == 'Tidur' && currentEnergy <= 0) {
      buttonBackgroundColor = Colors.red.shade100; // Merah jika lelah
    }

    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color:
                  buttonBackgroundColor, // Warna latar belakang tombol berubah
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30,
              color: Colors.blue.shade800, // Warna ikon tetap biru
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

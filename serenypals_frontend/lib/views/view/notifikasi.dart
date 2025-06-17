import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui'; // Import untuk ImageFilter

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifikasi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _notificationIndex = 0;
  String? _currentNotificationMessage;
  String? _currentNotificationTitle;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  // Daftar notifikasi yang diperbarui dengan yang baru
  final List<Map<String, String>> _notifications = [
    {
      'title': 'Notif Diary',
      'message': 'Suasana hati kamu lagi buruk nih\nAyo curhat di virtual diary'
    },
    {
      'title': 'Notif Pet',
      'message': 'Kamu kelihatan lelah hari ini\nAyo healing dengan teman terbaikmu'
    },
    {
      'title': 'Notif Checkin',
      'message': 'Kamu belum check-in hari ini!\nAyo buruan klaim hadiah harian kamu!'
    },
    {
      'title': 'Notif Chat Konsultan',
      'message': 'Psikiater\nGimana kabarmu hari ini?'
    },
    {
      'title': 'Notif Istirahat',
      'message': 'Udah istirahat belum?\nNyantai dengan lagu relaksasi dulu yuk!'
    },
    {
      'title': 'Notif Forum',
      'message': 'Postingan kamu telah diverifikasi!\nAyo baca forum hari ini!'
    },
    {
      'title': 'Notif Journaling',
      'message': 'Kamu belum menulis jurnal hari ini!\nAyo buruan tulis jurnal kamu hari ini!'
    },
    {
      'title': 'Notif Konsultasi',
      'message': 'Ayo temani aku ngobrol!\nTeman curhat kamu nungguin kabarmu lho!'
    },
    {
      'title': 'Notif Paket Berakhir',
      'message': 'Serenypremium segera berakhir\nBuruan raih promo sebesar mungkin!'
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Durasi animasi
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5), // Mulai dari atas (di luar layar)
      end: Offset.zero, // Berakhir di posisi normal
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic, // Kurva animasi yang lebih halus
    ));

    _startNotificationTimer();
  }

  void _startNotificationTimer() {
    // Mengubah durasi menjadi 10 detik
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _currentNotificationTitle = _notifications[_notificationIndex]['title'];
        _currentNotificationMessage = _notifications[_notificationIndex]['message'];
        _notificationIndex = (_notificationIndex + 1) % _notifications.length;
      });
      // Reset dan mulai animasi setiap kali notifikasi muncul
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black as in the image
      body: Stack( // Menggunakan Stack untuk menempatkan notifikasi di atas konten
        children: [
          // Konten utama aplikasi dummy (background)
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              // Ganti dengan gambar atau warna gradasi yang lebih menarik untuk background
              // agar efek blur terlihat jelas
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8A2BE2), // Biru keunguan
                    Color(0xFF4B0082), // Indigo
                    Color(0xFF00008B), // Biru tua
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'Dummy Page Content',
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
              ),
            ),
          ),
          // Area untuk notch (tetap di atas)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 50), // Atur sesuai kebutuhan notch
              child: Center(
                child: Container(
                  height: 30,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _currentNotificationTitle ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          // Notifikasi dengan animasi dan efek blur
          if (_currentNotificationMessage != null)
            Positioned(
              top: 100, // Sesuaikan posisi notifikasi agar tidak menutupi notch
              left: 20,
              right: 20,
              child: SlideTransition(
                position: _slideAnimation,
                child: ClipRRect( // ClipRRect untuk menerapkan borderRadius pada blur effect
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Efek blur
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2), // Transparan dengan sedikit warna
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)), // Border tipis transparan
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            child: Icon(Icons.person, color: Colors.deepPurple), // Icon agar cocok dengan tema
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentNotificationMessage!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    shadows: [ // Tambahkan shadow untuk teks agar lebih terbaca
                                      Shadow(
                                        blurRadius: 2.0,
                                        color: Colors.black54,
                                        offset: Offset(1.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '9:41 AM', // Static time
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              shadows: [
                                Shadow(
                                  blurRadius: 2.0,
                                  color: Colors.black54,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenypals_frontend/views/view/sharing_forum_screen.dart';
import '../../blocs/forum/forum_bloc.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForumCubit(), // Create and provide the ForumCubit
      child: MaterialApp(
        title: 'Sharing Forum',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor:
              Colors
                  .orange
                  .shade50, // Warna latar belakang global (sesuai Figma)
          appBarTheme: AppBarTheme(
            backgroundColor:
                Colors.blue.shade100, // Warna biru muda untuk AppBar
            foregroundColor:
                Colors.black87, // Warna teks di AppBar (hampir hitam)
            elevation: 0, // Menghilangkan shadow di AppBar
            iconTheme: const IconThemeData(
              color: Colors.black87,
            ), // Warna ikon di AppBar (misal: hamburger menu, back button)
          ),
        ),
        home: SharingForumScreen(),
      ),
    );
  }
}

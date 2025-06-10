import 'package:flutter/material.dart';

// Pastikan ada LoadForumData dan RefreshForumData
// Implementasi ForumRepository Anda
import 'sharingforumscreen.dart'; // Import SharingForumScreen

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ForumBloc dengan ForumApiService
    return SharingForumScreen(// SharingForumScreen akan mengonsumsi Bloc ini
        );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/forum/forum_bloc.dart';
import '../../blocs/forum/forum_event.dart'; // Pastikan ada LoadForumData dan RefreshForumData
import '../../services/forum_services.dart'; // Implementasi ForumRepository Anda
import 'sharingforumscreen.dart'; // Import SharingForumScreen

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider bertanggung jawab untuk membuat dan menyediakan instance ForumBloc.
    // Bloc ini akan tersedia untuk semua widget anak di bawahnya.
    return BlocProvider(
      create: (context) =>
          ForumBloc(forumRepository: ForumApiService())..add(LoadForumData()),
      child:
          const SharingForumScreen(), // SharingForumScreen akan mengonsumsi Bloc ini
    );
  }
}

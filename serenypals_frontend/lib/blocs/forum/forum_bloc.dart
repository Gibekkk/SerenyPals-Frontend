// forum_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/notification_item.dart';
import '../../models/post.dart';
import '../../repositories/forum_repository.dart';
import 'forum_event.dart';
import 'forum_state.dart';

class ForumBloc extends Bloc<ForumEvent, ForumState> {
  final ForumRepository forumRepository; // Pastikan ini diinisialisasi

  ForumBloc({required this.forumRepository}) : super(ForumInitial()) {
    on<LoadForumData>(_onLoadForumData);
    on<RefreshForumData>(_onRefreshForumData);
    on<AddPostEvent>(_onAddPost); // Perhatikan bahwa ini akan dipanggil
    on<ToggleLikePostEvent>(_onToggleLikePost);
    on<AddCommentEvent>(_onAddComment);
    on<AddNotificationEvent>(_onAddNotification);
    on<DeletePostEvent>(_onDeletePost);
    on<EditPostEvent>(_onEditPost);
    // on<FilterPostsEvent>(_onFilterPosts);
  }

  Future<void> _onLoadForumData(
      LoadForumData event, Emitter<ForumState> emit) async {
    emit(ForumLoading());
    try {
      final posts = await forumRepository.fetchAllPosts();
      emit(ForumLoaded(allPosts: posts, myPosts: posts, notifications: []));
    } catch (e) {
      emit(ForumError(
          'Gagal memuat data forum: ${e.toString()}')); // <<< Tambahkan error message
    }
  }

  Future<void> _onRefreshForumData(
      RefreshForumData event, Emitter<ForumState> emit) async {
    // Implementasi refresh data
    emit(ForumLoading());
    try {
      final posts = await forumRepository.fetchAllPosts();
      emit(ForumLoaded(
          allPosts: posts, myPosts: posts, notifications: state.notifications));
    } catch (e) {
      emit(ForumError(
          'Gagal menyegarkan data forum: ${e.toString()}')); // <<< Tambahkan error message
    }
  }

  void _onAddPost(AddPostEvent event, Emitter<ForumState> emit) async {
    // <<< Tambahkan async
    try {
      // Panggil repository untuk menyimpan/menambahkan post
      // Ini akan mengembalikan Post dengan ID yang sudah digenerate (oleh ForumApiService)
      final addedPost = await forumRepository
          .addPost(event.newPost); // <<< Panggil repository dan await

      final updatedAllPosts = List<Post>.from(state.allPosts)
        ..insert(0, addedPost); // Gunakan addedPost dari repository
      final updatedMyPosts = List<Post>.from(state.myPosts)
        ..insert(0, addedPost); // Gunakan addedPost dari repository

      // Emit AddPostSuccess untuk menginformasikan UI bahwa post berhasil ditambahkan
      emit(AddPostSuccess(
        allPosts: updatedAllPosts,
        myPosts: updatedMyPosts,
        notifications: state.notifications,
        addedPost: addedPost, // <<< Teruskan post yang baru ditambahkan
      ));

      // Tambahkan notifikasi jika berhasil
      add(AddNotificationEvent(
          'Postingan "${addedPost.title}" berhasil ditambahkan!'));
    } catch (e) {
      // Jika terjadi kesalahan saat menambahkan postingan
      emit(ForumError(
          'Gagal menambahkan postingan: ${e.toString()}')); // <<< Emit ForumError
    }
  }

  void _onToggleLikePost(ToggleLikePostEvent event, Emitter<ForumState> emit) {
    final postToUpdate = event.post;
    final updatedIsLiked = !postToUpdate.isLiked;
    final updatedLikes =
        updatedIsLiked ? postToUpdate.likes + 1 : postToUpdate.likes - 1;

    final updatedPost = postToUpdate.copyWith(
      isLiked: updatedIsLiked,
      likes: updatedLikes, timestamp: DateTime.now(), // Tambahkan timestamp
    );

    final updatedAllPosts =
        state.allPosts.map((p) => p == postToUpdate ? updatedPost : p).toList();
    final updatedMyPosts =
        state.myPosts.map((p) => p == postToUpdate ? updatedPost : p).toList();

    emit(ForumLoaded(
      allPosts: updatedAllPosts,
      myPosts: updatedMyPosts,
      notifications: state.notifications,
    ));
  }

  void _onAddComment(AddCommentEvent event, Emitter<ForumState> emit) {
    final postToUpdate = event.post;
    final updatedComments = postToUpdate.comments + 1;

    final updatedPost = postToUpdate.copyWith(
      comments: updatedComments,
      timestamp: DateTime.now(), // Tambahkan timestamp
    );

    final updatedAllPosts =
        state.allPosts.map((p) => p == postToUpdate ? updatedPost : p).toList();
    final updatedMyPosts =
        state.myPosts.map((p) => p == postToUpdate ? updatedPost : p).toList();

    emit(ForumLoaded(
      allPosts: updatedAllPosts,
      myPosts: updatedMyPosts,
      notifications: state.notifications,
    ));

    String notificationMessage;
    if (updatedComments == 1) {
      notificationMessage =
          'Postinganmu "${updatedPost.title}" mendapatkan 1 komentar: "${event.commentText}"';
    } else {
      notificationMessage =
          'Postinganmu "${updatedPost.title}" mendapatkan $updatedComments komentar. Komentar terbaru: "${event.commentText}"';
    }
    add(AddNotificationEvent(notificationMessage));
  }

  void _onAddNotification(
      AddNotificationEvent event, Emitter<ForumState> emit) {
    final updatedNotifications = List<NotificationItem>.from(
        state.notifications)
      ..insert(0,
          NotificationItem(message: event.message, timestamp: DateTime.now()));
    emit(ForumLoaded(
        allPosts: state.allPosts,
        myPosts: state.myPosts,
        notifications: updatedNotifications));
  }

  void _onDeletePost(DeletePostEvent event, Emitter<ForumState> emit) {
    final updatedAllPosts =
        state.allPosts.where((p) => p.id != event.postToDelete.id).toList();
    final updatedMyPosts =
        state.myPosts.where((p) => p.id != event.postToDelete.id).toList();

    emit(ForumLoaded(
        allPosts: updatedAllPosts,
        myPosts: updatedMyPosts,
        notifications: state.notifications));
  }

  Future<void> _onEditPost(
      EditPostEvent event, Emitter<ForumState> emit) async {
    await forumRepository.updatePost(event.updatedPost);
    final updatedAllPosts = state.allPosts
        .map((p) => p.id == event.originalPost.id ? event.updatedPost : p)
        .toList();
    final updatedMyPosts = state.myPosts
        .map((p) => p.id == event.originalPost.id ? event.updatedPost : p)
        .toList();

    emit(ForumLoaded(
        allPosts: updatedAllPosts,
        myPosts: updatedMyPosts,
        notifications: state.notifications));
  }
}

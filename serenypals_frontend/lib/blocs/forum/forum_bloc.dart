import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/notification_item.dart';
import '../../models/post.dart';
import '../../repositories/forum_repository.dart';
import 'forum_event.dart';
import 'forum_state.dart';

class ForumBloc extends Bloc<ForumEvent, ForumState> {
  final ForumRepository forumRepository;

  ForumBloc({required this.forumRepository}) : super(ForumInitial()) {
    on<LoadForumData>(_onLoadForumData);
    on<RefreshForumData>(_onRefreshForumData);
    on<AddPostEvent>(_onAddPost);
    on<ToggleLikePostEvent>(_onToggleLikePost);
    on<AddCommentEvent>(_onAddComment);
    on<AddNotificationEvent>(_onAddNotification);
    on<DeletePostEvent>(_onDeletePost);
    on<EditPostEvent>(_onEditPost);
  }

  List<NotificationItem> get currentNotifications {
    if (state is ForumLoaded) {
      return (state as ForumLoaded).notifications;
    } else if (state is AddPostSuccess) {
      return (state as AddPostSuccess).notifications;
    } else {
      return [];
    }
  }

  Future<void> _onLoadForumData(
      LoadForumData event, Emitter<ForumState> emit) async {
    emit(ForumLoading());
    try {
      final posts = await forumRepository.fetchAllPosts();
      emit(ForumLoaded(allPosts: posts, myPosts: posts, notifications: []));
    } catch (e) {
      emit(ForumError('Gagal memuat data forum: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshForumData(
      RefreshForumData event, Emitter<ForumState> emit) async {
    emit(ForumLoading());
    try {
      final posts = await forumRepository.fetchAllPosts();
      emit(ForumLoaded(
        allPosts: posts,
        myPosts: posts,
        notifications: state.notifications,
      ));
    } catch (e) {
      emit(ForumError('Gagal menyegarkan data forum: ${e.toString()}'));
    }
  }

  void _onAddPost(AddPostEvent event, Emitter<ForumState> emit) async {
    print('⏳ AddPostEvent received');

    try {
      final addedPost = await forumRepository.addPost(event.newPost);
      print('✅ Post added successfully: ${addedPost.title}');
      final updatedAllPosts = List<Post>.from(state.allPosts)
        ..insert(0, addedPost);
      final updatedMyPosts = List<Post>.from(state.myPosts)
        ..insert(0, addedPost);

      emit(AddPostSuccess(
        addedPost: addedPost,
        allPosts: updatedAllPosts,
        myPosts: updatedMyPosts,
        notifications: [
          NotificationItem(
            message: 'Postingan "${addedPost.title}" berhasil ditambahkan!',
            timestamp: DateTime.now(),
          ),
          ...state.notifications,
        ],
      ));
    } catch (e) {
      print('❌ Error when adding post: $e');
      emit(ForumError('Gagal menambahkan postingan: ${e.toString()}'));
    }
  }

  void _onToggleLikePost(ToggleLikePostEvent event, Emitter<ForumState> emit) {
    final postToUpdate = event.post;
    final updatedIsLiked = !postToUpdate.isLiked;
    final updatedLikes =
        updatedIsLiked ? postToUpdate.likes + 1 : postToUpdate.likes - 1;

    final updatedPost = postToUpdate.copyWith(
      isLiked: updatedIsLiked,
      likes: updatedLikes,
      timestamp: DateTime.now(),
    );

    final updatedAllPosts = state.allPosts
        .map((p) => p.id == updatedPost.id ? updatedPost : p)
        .toList();
    final updatedMyPosts = state.myPosts
        .map((p) => p.id == updatedPost.id ? updatedPost : p)
        .toList();

    emit(ForumLoaded(
      allPosts: updatedAllPosts,
      myPosts: updatedMyPosts,
      notifications: state.notifications,
    ));
  }

  void _onAddComment(AddCommentEvent event, Emitter<ForumState> emit) {
    final updatedPost = event.post.addComment(event.newComment);

    final updatedAllPosts = state.allPosts
        .map((p) => p.id == updatedPost.id ? updatedPost : p)
        .toList();

    final updatedMyPosts = state.myPosts
        .map((p) => p.id == updatedPost.id ? updatedPost : p)
        .toList();

    emit(ForumLoaded(
      allPosts: updatedAllPosts,
      myPosts: updatedMyPosts,
      notifications: state.notifications,
    ));

    final notificationMessage =
        'Postingan "${updatedPost.title}" mendapat komentar baru: "${event.newComment.content}"';
    add(AddNotificationEvent(notificationMessage));
  }

  void _onAddNotification(
      AddNotificationEvent event, Emitter<ForumState> emit) {
    if (state is ForumLoaded) {
      final currentState = state as ForumLoaded;

      final updatedNotifications = [
        NotificationItem(
          message: event.message,
          timestamp: DateTime.now(),
        ),
        ...currentState.notifications,
      ];

      emit(ForumLoaded(
        allPosts: currentState.allPosts,
        myPosts: currentState.myPosts,
        notifications: updatedNotifications,
      ));
    } else if (state is AddPostSuccess) {
      final currentState = state as AddPostSuccess;

      final updatedNotifications = [
        NotificationItem(
          message: event.message,
          timestamp: DateTime.now(),
        ),
        ...currentState.notifications,
      ];

      emit(AddPostSuccess(
        addedPost: currentState.addedPost,
        allPosts: currentState.allPosts,
        myPosts: currentState.myPosts,
        notifications: updatedNotifications,
      ));
    }
  }

  void _onDeletePost(DeletePostEvent event, Emitter<ForumState> emit) {
    final updatedAllPosts =
        state.allPosts.where((p) => p.id != event.postToDelete.id).toList();
    final updatedMyPosts =
        state.myPosts.where((p) => p.id != event.postToDelete.id).toList();

    emit(ForumLoaded(
      allPosts: updatedAllPosts,
      myPosts: updatedMyPosts,
      notifications: state.notifications,
    ));
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
      notifications: state.notifications,
    ));
  }
}

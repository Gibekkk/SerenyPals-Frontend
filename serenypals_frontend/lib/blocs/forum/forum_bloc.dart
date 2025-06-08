import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/notification_item.dart';
import '../../models/post.dart';
import 'forum_event.dart';
import 'forum_state.dart';

class ForumBloc extends Bloc<ForumEvent, ForumState> {
  ForumBloc() : super(ForumInitial()) {
    on<AddPostEvent>(_onAddPost);
    on<ToggleLikePostEvent>(_onToggleLikePost);
    on<AddCommentEvent>(_onAddComment);
    on<AddNotificationEvent>(_onAddNotification);
  }

  void _onAddPost(AddPostEvent event, Emitter<ForumState> emit) {
    final updatedAllPosts = List<Post>.from(state.allPosts)
      ..insert(0, event.newPost);
    final updatedMyPosts = List<Post>.from(state.myPosts)
      ..insert(0, event.newPost);
    emit(ForumLoaded(
      allPosts: updatedAllPosts,
      myPosts: updatedMyPosts,
      notifications: state.notifications,
    ));
  }

  void _onToggleLikePost(ToggleLikePostEvent event, Emitter<ForumState> emit) {
    final postToUpdate = event.post;
    final updatedIsLiked = !postToUpdate.isLiked;
    final updatedLikes =
        updatedIsLiked ? postToUpdate.likes + 1 : postToUpdate.likes - 1;

    final updatedPost = postToUpdate.copyWith(
      isLiked: updatedIsLiked,
      likes: updatedLikes,
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

    if (updatedIsLiked) {
      add(AddNotificationEvent('Postinganmu "${updatedPost.title}" disukai.'));
    }
  }

  void _onAddComment(AddCommentEvent event, Emitter<ForumState> emit) {
    final postToUpdate = event.post;
    final updatedComments = postToUpdate.comments + 1;

    final updatedPost = postToUpdate.copyWith(
      comments: updatedComments,
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
      notifications: updatedNotifications,
    ));
  }
}

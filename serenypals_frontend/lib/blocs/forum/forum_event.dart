import 'package:equatable/equatable.dart';
import '../../models/comment.dart';
import '../../models/post.dart';

abstract class ForumEvent extends Equatable {
  const ForumEvent();

  @override
  List<Object> get props => [];
}

class LoadForumData extends ForumEvent {}

class RefreshForumData extends ForumEvent {}

class AddPostEvent extends ForumEvent {
  final Post newPost;
  const AddPostEvent(this.newPost);
  @override
  List<Object> get props => [newPost];
}

class ToggleLikePostEvent extends ForumEvent {
  final Post post;
  const ToggleLikePostEvent(this.post);
  @override
  List<Object> get props => [post];
}

class AddCommentEvent extends ForumEvent {
  final Post post;
  final Comment newComment;
  const AddCommentEvent(this.post, this.newComment);
  @override
  List<Object> get props => [post, newComment];
}

class AddNotificationEvent extends ForumEvent {
  final String message;
  const AddNotificationEvent(this.message);
  @override
  List<Object> get props => [message];
}

class DeletePostEvent extends ForumEvent {
  final Post postToDelete;
  const DeletePostEvent(this.postToDelete);
  @override
  List<Object> get props => [postToDelete];
}

class EditPostEvent extends ForumEvent {
  final Post originalPost;
  final Post updatedPost;
  const EditPostEvent({required this.originalPost, required this.updatedPost});
  @override
  List<Object> get props => [originalPost, updatedPost];
}

class MarkNotificationAsRead extends ForumEvent {
  final String notificationId;
  const MarkNotificationAsRead(this.notificationId);
  @override
  List<Object> get props => [notificationId];
}

class FilterPostsEvent extends ForumEvent {
  final String? category;
  final String? searchTerm;
  const FilterPostsEvent({this.category, this.searchTerm});
  @override
  List<Object> get props => [category ?? '', searchTerm ?? ''];
}

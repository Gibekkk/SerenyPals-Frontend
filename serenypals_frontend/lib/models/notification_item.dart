import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  // final String id;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  const NotificationItem({
    // required this.id,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      // id: id,
      message: message,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [message, timestamp, isRead];
}

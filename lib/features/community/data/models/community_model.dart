class CommunityItem {
  final String id;
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final bool isUnread;
  final bool isOnline;

  CommunityItem({
    required this.id,
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    required this.isUnread,
    required this.isOnline,
  });
}
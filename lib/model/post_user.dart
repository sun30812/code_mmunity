class PostUser {
  final String userId;
  final String userName;

  const PostUser({required this.userId, required this.userName});

  factory PostUser.fromJson(Map<String, dynamic> json) =>
      PostUser(userId: json['user_id'], userName: json['user_name']);

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_name': userName,
      };
}

class User {
  int? userId;
  String realName;
  String profileName;
  String? profileUrl;
  DateTime createdTime;
  DateTime updatedTime;

  User({
    this.userId,
    required this.realName,
    required this.profileName,
    this.profileUrl,
    required this.createdTime,
    required this.updatedTime,
  });

  @override
  String toString() {
    return "User{id: $userId, realName: $realName, profileName: $profileName";
  }
}

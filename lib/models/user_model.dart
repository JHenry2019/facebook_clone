class User {
  int? userId;
  String realName;
  String profileName;
  String? profileUrl;
  String mail;
  String password;
  DateTime createdTime;
  DateTime updatedTime;

  User({
    this.userId,
    required this.realName,
    required this.profileName,
    this.profileUrl,
    required this.mail,
    required this.password,
    required this.createdTime,
    required this.updatedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "realName": realName,
      "profileName": profileName,
      "profileUrl": profileUrl,
      "mail": mail,
      "password": password,
      "createdTime": createdTime.millisecondsSinceEpoch,
      "updatedTime": updatedTime.millisecondsSinceEpoch,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      realName: map['realName'],
      profileName: map['profileName'],
      profileUrl: map['profileUrl'],
      mail: map['mail'],
      password: map['password'],
      createdTime: DateTime.fromMillisecondsSinceEpoch(map['createdTime']),
      updatedTime: DateTime.fromMillisecondsSinceEpoch(map['updatedTime']),
    );
  }

  @override
  String toString() {
    return "User{id: $userId, realName: $realName, profileName: $profileName";
  }
}

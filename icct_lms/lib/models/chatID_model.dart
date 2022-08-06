class ChatIDModel {
  final String name, chatID, userType;

  ChatIDModel(this.name, this.chatID, this.userType);

  Map<String, dynamic> toJson() =>
      {'name': name, 'chatID': chatID, 'userType': userType};

  static ChatIDModel fromJson(Map<String, dynamic> json) =>
      ChatIDModel(json['name'], json['chatID'], json['userType']);
}

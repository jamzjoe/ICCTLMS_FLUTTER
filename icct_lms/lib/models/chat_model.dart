class ChatModel {
  final String name, userID, userType, date, hour, message, sortKey, chatID;
  ChatModel(this.name, this.userID, this.userType, this.date, this.hour, this
      .message, this.sortKey, this.chatID);

  Map<String, dynamic> toJson() =>
      {'name': name, 'userID': userID, 'userType': userType, 'date': date,
        'hour': hour, 'message': message, 'sortKey': sortKey, 'chatID': chatID};

  static ChatModel fromJson(Map<String, dynamic> json) => ChatModel(
      json['name'] ?? 'Name',
      json['userID'] ?? 'UserID',
      json['userType'] ?? 'UserType',
      json['date'] ?? 'Date',
      json['hour'] ?? 'Hour',
      json['message'] ?? 'Message',
      json['sortKey'] ?? 'SortKey',
      json['chatID'] ?? 'ChatID'
  );
}

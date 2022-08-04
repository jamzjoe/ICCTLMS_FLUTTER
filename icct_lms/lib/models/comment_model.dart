class CommentModel {
  final String date,
      message,
      commentID,
      name,
      sortKey,
      userID,
      userType,
      hour;

  CommentModel(this.date, this.message, this.commentID, this.name, this.sortKey,
      this.userID, this.userType, this.hour);

  Map<String, dynamic> toJson() => {
    "date": date,
    "message": message,
    "commentID": commentID,
    "name": name,
    "sortKey": sortKey,
    "userID": userID,
    "userType": userType,
    "hour": hour,
  };

  static CommentModel fromJson(Map<String, dynamic> json) => CommentModel(
      json['date'] ?? 'Date',
      json['message'] ?? 'Message',
      json['commentID'] ?? 'commentID',
      json['name'] ?? 'name',
      json['sortKey'] ?? 'SortKey',
      json['userID'] ?? 'UserID',
      json['userType'] ?? 'UserType',
      json['hour'] ?? 'Hour',);
}

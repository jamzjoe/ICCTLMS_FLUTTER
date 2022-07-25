class PostModel {
  final String date, message, postID, postName, sortKey, userID;

  PostModel(this.date, this.message, this.postID, this.postName, this.sortKey,
      this.userID);


  Map<String, dynamic> toJson() =>
      {"date":date, "message": message, "postID": postID, "postName": postName,
        "sortKey": sortKey,
        "userID": userID};

  static PostModel fromJson(Map<String, dynamic> json) => PostModel(
     json['date'] ?? 'Date', json['message'] ?? 'Message', json['postID'] ??
      'PostID',
      json['postName'] ?? 'PostName',
  json['sortKey'] ?? 'SortKey', json['userID'] ?? 'UserID');
}
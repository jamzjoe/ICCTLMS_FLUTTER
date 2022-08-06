class HeartModel {
  final String heart, name, userType, userID;

  HeartModel(this.heart, this.name, this.userType, this.userID);

  Map<String, dynamic> toJson() =>
      {'name': name, 'heart': heart, 'userType': userType, 'userID': userID};

  static HeartModel fromJson(Map<String, dynamic> json) =>
      HeartModel(json['name'], json['heart'], json['userType'], json['userID']);
}

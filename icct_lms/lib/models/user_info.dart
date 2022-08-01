class UserInfo   {
  final String name, school, email, userType, userID;

  UserInfo(
      {required this.name,
      required this.school,
      required this.email,
      required this.userType,
      required this.userID});
  Map<String, dynamic> toJson() => {'username':name, 'campus': school, 'email'
      'Address':
    email, 'userType': userType, 'userID': userID};


  static UserInfo fromJson(Map<String, dynamic> json) => UserInfo(name:
  json['username'],
      school: json['campus'], email: json['emailAddress'], userType:
      json['userType'], userID: json['userID']);
}

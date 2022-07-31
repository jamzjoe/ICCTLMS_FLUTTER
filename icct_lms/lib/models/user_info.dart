class UserInfo   {
  final String name, school, email, userType;

  UserInfo(
      {required this.name,
      required this.school,
      required this.email,
      required this.userType});
  Map<String, dynamic> toJson() => {'username':name, 'campus': school, 'email'
      'Address':
    email, 'userType': userType};


  static UserInfo fromJson(Map<String, dynamic> json) => UserInfo(name:
  json['username'],
      school: json['campus'], email: json['emailAddress'], userType:
      json['userType']);
}



class UserProfile{
  final String name, email, campus, userType;

  UserProfile({required this.name,required this.email,required this.campus,required this
      .userType});

  Map<String, dynamic> toJson() => {
    'username': name,
    'emailAddress': email,
    'campus': campus,
    'userType': userType
  };

  static UserProfile fromJson(Map<String, dynamic>json) => UserProfile( name: json['username'], email: json['emailAddress'], campus:
  json['campus'], userType: json['userType']);


}
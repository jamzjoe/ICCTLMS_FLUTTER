import 'package:icct_lms/home_pages/profile.dart';

class Posts {
  
  final String name;
  final String user_type;
  final String messages;
  final int id;


  const Posts({
    required this.name,
    required this.messages,
    required this.user_type,
    required this.id
  });

  factory Posts.fromJson(Map<String, dynamic> json) {
    return Posts(
      name: json['name'],
      messages: json['messages'],
      user_type: json['user_type'],
      id: json['id']
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'messages': messages,
    'user_type': user_type,
    'id': id
  };
}
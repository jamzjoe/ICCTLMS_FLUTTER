class Group{
  final String name, code, teacher;

  Group(this.name, this.code, this.teacher);

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'teacher': teacher
  };

  static Group fromJson(Map<String, dynamic>json) =>
      Group(json['name'] ?? 'Name', json['code'] ?? 'Code', json['teacher']
          ?? 'Teacher');
}
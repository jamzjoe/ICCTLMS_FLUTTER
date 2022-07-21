class Class{
  final String name, code, teacher;

  Class(this.name, this.code, this.teacher);

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'teacher': teacher
  };

  static Class fromJson(Map<String, dynamic>json) =>
      Class(json['name'] ?? 'Name', json['code'] ?? 'Code', json['teacher']
          ?? 'Teacher');
}
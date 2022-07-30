class MembersModel {
  final String name, userID, userType, sortKey;
  MembersModel(this.name, this.userID, this.userType, this.sortKey);

  Map<String, dynamic> toJson() =>
      {'name': name, 'userID': userID, 'userType': userType, 'sortKey': sortKey};

  static MembersModel fromJson(Map<String, dynamic> json) => MembersModel(
      json['name'] ?? 'Name',
      json['userID'] ?? 'userID',
      json['userType'] ?? 'userType',
      json['sortKey']?? 'SortKey');
}

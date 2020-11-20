class GroupEntity{
  int id;
  String name;
  bool isCheck;

  GroupEntity({this.id, this.name, this.isCheck=false});

  GroupEntity.fromJson(Map<dynamic, dynamic> json){
    id = json['id'];
    name = json['name'];
  }
}
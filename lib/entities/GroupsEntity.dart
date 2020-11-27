class GroupEntity{
  int id;
  String name;
  bool isCheck;
  bool isSelected ;


  GroupEntity({this.id, this.name, this.isCheck=false, this.isSelected = false});

  GroupEntity.fromJson(Map<dynamic, dynamic> json){
    id = json['id'];
    name = json['name'];
  }
}
class SignatureEntity{
  int id;
  String name;
  String content;

  SignatureEntity({this.id, this.name, this.content});

  SignatureEntity.fromJson(Map<dynamic, dynamic> json){
    id = json['id'];
    name = json['name'];
    content = json['content'];
  }
}
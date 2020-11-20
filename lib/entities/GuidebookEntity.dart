class GuideBookEntity {
  int id;
  String surname;
  String email;
  String gsm;
  bool isCheck;

  GuideBookEntity({this.id, this.surname, this.email, this.gsm, this.isCheck = false});

  GuideBookEntity.fromJson(Map<dynamic, dynamic> json){
    id = json['id'];
    surname = json['name_surname'];
    email = json['email'];
    gsm = json['gsm'];
  }
}
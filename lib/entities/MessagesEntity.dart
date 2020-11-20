class MessageEntity {
  String message;
  int id;
  int companyId;
  int personId;

  MessageEntity({this.message, this.id, this.companyId, this.personId});

  MessageEntity.fromJson(Map<dynamic, dynamic> json) {
    message = json['message'];
    id = json['id'];
    companyId = json['company_id'];
    personId = json['person_id'];
  }
}

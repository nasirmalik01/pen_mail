class AddGuideBookInGroupEntity{
  int id;
  int groupID;
  int guideBookID;
  String surname;

  AddGuideBookInGroupEntity({this.id, this.guideBookID, this.groupID,this.surname});

  AddGuideBookInGroupEntity.fromJson(Map<String, dynamic> json){
    id = json['id'];
    groupID = json['groups_id'];
    guideBookID = json['guidebook_id'];
    surname = json['name_surname'];
  }
}
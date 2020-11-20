import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/backend/GuideBook.dart';
import 'package:pen_mail_project/entities/GuidebookEntity.dart';
import '../backend/AddGroupGuideBook.dart';

class AddGuideBook extends StatefulWidget {
  final token;
  final surname;
  final groupId;

  AddGuideBook({this.token, this.surname, this.groupId});

  @override
  _AddGuideBookState createState() => _AddGuideBookState();
}

class _AddGuideBookState extends State<AddGuideBook> {
  List<GuideBookEntity> guideBookItems = List<GuideBookEntity>();

  //bool _checked = false;
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  //List<bool> _inputs = new List<bool>();

  Future<List<GuideBookEntity>> getGuideBookList() async {
    var _response = await getGuideBook(token: widget.token);
    var _decodedReply = jsonDecode(_response);
    var _decodedData = _decodedReply['data'];

    List<GuideBookEntity> _guideItems = List<GuideBookEntity>();
    for (var _items in _decodedData) {
      setState(() {
        _guideItems.add(GuideBookEntity.fromJson(_items));
      });
    }
    return _guideItems;
  }


  getList() {
    setState(() {
      getGuideBookList().then((value) {
        return guideBookItems = value;
      });
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add Guidebook in \'${widget.surname}\'',
          style: TextStyle(fontFamily: 'Raleway'),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF54A9FF), Color(0xFFC078FF)])),
        ),
      ),
      body: FutureBuilder(
        future: getGuideBookList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                getList();
              },
              child: ListView.builder(
                  itemCount: guideBookItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CheckboxListTile(
                            title: Text(guideBookItems[index].surname),
                            subtitle: Text(guideBookItems[index].email),
                            value: guideBookItems[index].isCheck??false,
                            onChanged: (bool value) {
                              setState(() {
                                guideBookItems[index].isCheck = value;
                                print(guideBookItems[index].id);
                                print(widget.groupId);
                              });
                            },
                          ),
                        ),
                      ),
                    );

                  }),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:  () async {
          //suppose you are calling setvice here
          setState(() {
            _isLoading = true;
          });

          for (int i = 0; i < guideBookItems.length; i++) {
            if (guideBookItems[i].isCheck == true) {
              print('ooo : ${guideBookItems[i].isCheck??false}');
              int groupId = widget.groupId;
              int guideBookID = guideBookItems[i].id;

              print("group is : $groupId");
              print("guide book is : $guideBookID");

              var _response = await addGroupInGuideBook(
                  token: widget.token, groupId: groupId, guideId: guideBookID);

              var _res = jsonDecode(_response);
              print('Response : _$_res');
              var status = _res['status'];
              if (status == false) {
                print('Error');
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('There is an error, Try Again'),
                ));
                setState(() {
                  _isLoading = false;
                });
                return;
              }
              print("Added Data");
              print("guideBookItems : ${guideBookItems[i].isCheck}");
            }


            }
          setState(() {
            _isLoading = false;
          });
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Guidebook added in Group successfully'),
          ));



        },
        child: _isLoading
            ? SpinKitFadingCircle(
                color: Colors.white,
              )
            : Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

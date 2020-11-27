import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/backend/Groups.dart';
import 'package:pen_mail_project/backend/GuideBook.dart';
import 'package:pen_mail_project/entities/GuidebookEntity.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';

class AddGroupScreen extends StatefulWidget {
  final String token;

  AddGroupScreen({this.token});

  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  TextEditingController _groupNameController = TextEditingController();
  List<GuideBookEntity> guideBookItems = List<GuideBookEntity>();

  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<int> _guideItems = List();

  //List<bool> _inputs = new List<bool>();

  Future<List<GuideBookEntity>> _getGuideBookList() async {
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

  _getList() {
    setState(() {
      _getGuideBookList().then((value) {
        return guideBookItems = value;
      });
    });
  }

  @override
  void initState() {
    _getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add Group',
          style: TextStyle(fontFamily: 'Nunito'),
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
        future: _getGuideBookList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
              ),
            );
          } else
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 5.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Group Name:',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: addGuideBookInputField(
                      controller: _groupNameController,
                      hintText: 'Group Name',
                      inputField: 'Group Name'),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 30.0, bottom: 5.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose Guidebooks:',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _getList();
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
                                  value: guideBookItems[index].isCheck ?? false,
                                  onChanged: (bool value) {
                                    setState(() {
                                      guideBookItems[index].isCheck = value;
                                      // _guidebookID = guideBookItems[index].id;
                                      // print(_guidebookID);
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: _isLoading ? SpinKitFadingCircle(color: Colors.white,) : Icon(Icons.arrow_forward),
        onPressed: _isLoading ? null : () async {
          if (_groupNameController.text.isEmpty) {
            return;
          }
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          setState(() {
            _isLoading = true;
          });

          for (int i = 0; i < guideBookItems.length; i++) {
            if (guideBookItems[i].isCheck == true) {
              print('ooo : ${guideBookItems[i].isCheck ?? false}');
              int _guideBookID = guideBookItems[i].id;
              print("guide book is : $_guideBookID");
              _guideItems.add(_guideBookID);
            }
          }

          var _response = await addGroup(
              token: widget.token,
              groupName: _groupNameController.text,
              guidebookItems: _guideItems);

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
          setState(() {
            _isLoading = false;
          });
          _groupNameController.clear();
          for (int i = 0; i < guideBookItems.length; i++) {
            setState(() {
              guideBookItems[i].isCheck = false;
            });
          }

          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Group added Successfully'),
          ));
        },
      ),
    );
  }
}

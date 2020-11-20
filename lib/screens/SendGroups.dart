import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/backend/GroupMessage.dart';
import 'package:pen_mail_project/backend/Groups.dart';
import 'package:pen_mail_project/entities/GroupsEntity.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';

class SendGroups extends StatefulWidget {
  final token;
  final messageId;
  SendGroups({this.token, this.messageId});

  @override
  _SendGroupsState createState() => _SendGroupsState();
}

class _SendGroupsState extends State<SendGroups> {
  List<GroupEntity> _groupListItems = List();
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<List<GroupEntity>> _getGroupListItems() async {
    var _response = await getGroupList(token: widget.token);
    var decodedReply = jsonDecode(_response);
    var decodedData = decodedReply['data'];

    List<GroupEntity> _groupItems = List();
    for (var _items in decodedData) {
      setState(() {
        _groupItems.add(GroupEntity.fromJson(_items));
      });
    }

    return _groupItems;
  }

  _getGroupList() {
    setState(() {
      _getGroupListItems().then((value) => _groupListItems = value);
    });
  }

  @override
  void initState() {
    _getGroupList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Choose Groups'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF54A9FF), Color(0xFFC078FF)])),
          ),
        ),
        body: FutureBuilder(
          future: _getGroupListItems(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue,
                ),
              );
            } else
              return RefreshIndicator(
                onRefresh: () async {
                  _getGroupList();
                },
                child: ListView.builder(
                    itemCount: _groupListItems.length,
                    itemBuilder: (context, index) {
                      print(_groupListItems.length.toString());
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CheckboxListTile(
                              title: TextDataContentGroup(title: _groupListItems[index].name),
                              value: _groupListItems[index].isCheck??false,
                              onChanged: (value){
                                setState(() {
                                  _groupListItems[index].isCheck = value;
                                  print(_groupListItems[index].id);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    }),
              );
          },
        ),
      floatingActionButton: FloatingActionButton(
          child: _isLoading
              ? SpinKitFadingCircle(
            color: Colors.white,
          )
              : Icon(Icons.arrow_forward_ios),
          backgroundColor: Colors.pink,
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });

            for (int i = 0; i < _groupListItems.length; i++) {
              if (_groupListItems[i].isCheck == true) {
                int groupId = _groupListItems[i].id;

                var _response = await sendGroupMessage(
                    token: widget.token,
                    groupId: groupId,
                    messageId: widget.messageId);

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
              }
            }
            setState(() {
              _isLoading = false;
            });
            _scaffoldKey.currentState.hideCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Message Sent '),
            ));
            for(int i=0; i<_groupListItems.length; i++){
              setState(() {
                _groupListItems[i].isCheck = false;
              });
            }
          }),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/backend/Groups.dart';
import 'package:pen_mail_project/entities/GroupsEntity.dart';
import 'package:pen_mail_project/screens/ComposeMessage/ComposeMessageScreen.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';

class ComposeMessageGroup extends StatefulWidget {
  final String token;
  final String sendingPerson;
  final String mailSubject;
  final String signatureId;
  final String mailContent;
  final List<File> imageFile;
  final List<String> imageNames;

  ComposeMessageGroup(
      {this.token,
        this.sendingPerson,
        this.mailSubject,
        this.signatureId,
        this.mailContent,
        this.imageFile,
        this.imageNames});

  @override
  _ComposeMessageGroupState createState() => _ComposeMessageGroupState();
}

class _ComposeMessageGroupState extends State<ComposeMessageGroup> {

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
        title: Text(
          'Choose Groups',
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
        future: _getGroupListItems(),
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
                _getGroupList();
              },
              child: ListView.builder(
                  itemCount: _groupListItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CheckboxListTile(
                            title: Text(_groupListItems[index].name),
                            value: _groupListItems[index].isCheck ?? false,
                            onChanged: (bool value) {
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
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //suppose you are calling setvice here
          setState(() {
            _isLoading = true;
          });

          List<String> _groupIdList = List();
          for (int i = 0; i < _groupListItems.length; i++) {
            if (_groupListItems[i].isCheck == true) {
              String _groupId = _groupListItems[i].id.toString();
              _groupIdList.add(_groupId);
            }
          }

          try {
            Response _response;
            Dio dio = new Dio();
            FormData formdata = new FormData.fromMap({
              'attachment': [
                for(int i=0; i<widget.imageFile.length; i++){
                  {await MultipartFile.fromFile(widget.imageFile[i].path, filename: widget.imageNames[i])}
                      .toList()
                  // String p = widget.imageFile[i].path;
                  // _imageFileNames.add(paths);
                }
              ],
              'baslik': widget.mailSubject,
              'message': widget.mailContent,
              'sending_name': widget.sendingPerson,
              'signature_id': widget.signatureId,
              'group_id': _groupIdList,
            });
            _response = await dio.post(
                'https://dev.penmail.com.tr/api/Attachment/Filespec',
                data: formdata,
                options: Options(headers: {
                  'content-type': 'multipart/form-data',
                  'person_token': widget.token
                }));

            var _res = await _response.data;
            var _status = _res['status'];
            var _message = _res['message'];
            print(_message);
            print(_res);
            print(_status);
            if (_status == true) {
              for (int i = 0; i < _groupIdList.length; i++) {
                print('$i: ${_groupIdList[i]}');
              }
              ComposeMessageSendMessage(
                  context: context,
                  errorMessage:
                  'Your Mail has been sent to \"${widget.sendingPerson}\"',onPress: (){
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    ComposeMessageScreen(token: widget.token,)), (Route<dynamic> route) => false);
              });
              // setState(() {
              //   _fileNameExcel = null;
              //   _savedExcelFile = null;
              //   for (int i = 0; i < _groupListItems.length; i++) {
              //     _groupListItems[i].isSelected = false;
              //     _isClickCheck = false;
              //   }
              // });
            }
            // else{
            //   if(_message == 'Invalid Group Provided'){
            //     _scaffoldKey.currentState.showSnackBar(SnackBar(
            //       content: Text('Invalid Group Provided'),
            //     ));
            //     setState(() {
            //       _isLoading = false;
            //     });
            //     return;
            //   }
            //   _scaffoldKey.currentState.showSnackBar(SnackBar(
            //     content: Text('Sorry, Please Upload Valid File'),
            //   ));
            // }
            setState(() {
              _isLoading = false;
            });
          } catch (e) {
            setState(() {
              _isLoading = false;
            });
            // if(_message == 'Invalid Group Provided'){
            //   _scaffoldKey.currentState.showSnackBar(SnackBar(
            //     content: Text('Invalid Group Provided'),
            //   ));
            //   return;
            // }
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Error occurred, Try Again'),
            ));
            return;
          }
        },
        child: _isLoading
            ? SpinKitFadingCircle(
          color: Colors.white,
        )
            : Icon(Icons.send),
      ),
    );
  }
}

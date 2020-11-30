import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/backend/GuideBook.dart';
import 'package:pen_mail_project/entities/GuidebookEntity.dart';
import 'package:pen_mail_project/screens/ComposeMessage/ComposeMessageScreen.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';

class ComposeMessageGuidebook extends StatefulWidget {
  final String token;
  final String sendingPerson;
  final String mailSubject;
  final String signatureId;
  final String mailContent;
  final List<File> imageFile;
  final List<String> imageNames;

  ComposeMessageGuidebook(
      {this.token,
      this.sendingPerson,
      this.mailSubject,
      this.signatureId,
      this.mailContent,
      this.imageFile,
      this.imageNames});

  @override
  _ComposeMessageGuidebookState createState() =>
      _ComposeMessageGuidebookState();
}

class _ComposeMessageGuidebookState extends State<ComposeMessageGuidebook> {
  List<GuideBookEntity> _guideBookItems = List<GuideBookEntity>();
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<String> _imageFileNames = List();


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
        return _guideBookItems = value;
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
          'Choose Guidebooks',
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
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                _getList();
              },
              child: ListView.builder(
                  itemCount: _guideBookItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CheckboxListTile(
                            title: Text(_guideBookItems[index].surname.toString()),
                            subtitle: Text(_guideBookItems[index].email.toString()),
                            value: _guideBookItems[index].isCheck ?? false,
                            onChanged: (bool value) {
                              setState(() {
                                _guideBookItems[index].isCheck = value;
                                print(_guideBookItems[index].id);
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

          List<String> _signItems = List();
          for (int i = 0; i < _guideBookItems.length; i++) {
            if (_guideBookItems[i].isCheck == true) {
              String guideBookID = _guideBookItems[i].id.toString();
              _signItems.add(guideBookID);
            }
          }

          try {
            Response _response;
            Dio dio = new Dio();
            FormData formdata = new FormData.fromMap({
              // 'attachment': await MultipartFile.fromFile(
              //   widget.imageFile.path,
              //   filename: widget.imageName,
              // ),
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
              'guidebook_id': _signItems,
              //contentType: MediaType('file', 'xlsx')),
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
            print('Response: $_res');
            print(_status);
            if (_status == true) {
              for (int i = 0; i < _signItems.length; i++) {
                print('$i: ${_signItems[i]}');
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
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

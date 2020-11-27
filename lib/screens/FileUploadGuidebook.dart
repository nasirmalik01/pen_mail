import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/backend/Groups.dart';
import 'package:pen_mail_project/entities/GroupsEntity.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:http_parser/http_parser.dart';

class FileUploadGuidebook extends StatefulWidget {
  final String token;

  FileUploadGuidebook({this.token});

  @override
  _FileUploadGuidebookState createState() => _FileUploadGuidebookState();
}

class _FileUploadGuidebookState extends State<FileUploadGuidebook> {
  List<GroupEntity> _groupListItems = List();
  File _excelFile;
  String _fileNameExcel;
  File _savedExcelFile;
  String _groupId;
  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _excelFileName;
  var _message;
  bool _isClickCheck = false;

  Future<void> _getExcelFile() async {
    final _pickedFile = await FilePicker.getFile(
        allowedExtensions: ['xlsx'], type: FileType.custom);
    if (_pickedFile == null) {
      return;
    }
    setState(() {
      _excelFile = _pickedFile;
    });
    final _appDir = await syspaths.getApplicationDocumentsDirectory();
    setState(() {
      _excelFileName = _excelFile.path.split('/').last;
      print('Excel Name: $_excelFileName');
      _fileNameExcel = path.basename(_pickedFile.path);
    });
    _savedExcelFile = await _pickedFile.copy('${_appDir.path}/$_fileNameExcel');
    print('Excel File Attached $_savedExcelFile');
  }

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
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF54A9FF), Color(0xFFC078FF)])),
        ),
        title: Text(
          'Upload your file',
          style: TextStyle(fontFamily: 'Raleway'),
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
            return Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 25.0, bottom: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.lightBlue),
                      child: FlatButton(
                          child: Text(
                            'Click to Upload File',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          onPressed: _getExcelFile),
                    )),
                _fileNameExcel != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 25.0, bottom: 15.0),
                        child: Text(
                          'Document attached: ${_fileNameExcel.toString()}',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 25.0, bottom: 5.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Choose Group',
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _groupListItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Ink(
                          color: _groupListItems[index].isSelected ?? false
                              ? Colors.grey
                              : Colors.transparent,
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                _groupListItems[index].name,
                                style: TextStyle(fontFamily: 'Raleway'),
                              ),
                              onTap: () {
                                setState(() {
                                  if (_groupListItems[index].isSelected ==
                                      false) {
                                    _groupListItems[index].isSelected = true;
                                    for (int i = 0; i < _groupListItems.length; i++) {
                                      if (i != index) {
                                        _groupListItems[i].isSelected = false;
                                      }
                                    }
                                  } else {
                                    _groupListItems[index].isSelected = false;
                                  }
                                  _groupId = _groupListItems[index].id.toString();
                                  _isClickCheck = true;
                                });
                              },
                              trailing:
                                  _groupListItems[index].isSelected ?? false
                                      ? Text(
                                          'Selected',
                                          style: TextStyle(
                                              fontFamily: 'Raleway',
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(''),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: _mediaQuery.size.height * 0.06,
                      bottom: _mediaQuery.size.height * 0.02),
                  width: _mediaQuery.size.width * 0.7,
                  height: _mediaQuery.size.height * 0.075,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF54A9FF),
                      Color(0xFFC078FF),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: FlatButton(
                    onPressed: () async {
                      print(_groupId);
                      if (_savedExcelFile == null) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                  'File Not attached!',
                                  style: TextStyle(fontFamily: 'Raleway'),
                                ),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Okay',
                                      style: TextStyle(
                                          fontFamily: 'Raleway',
                                          color: Colors.red),
                                    ),
                                  )
                                ],
                              );
                            });
                        return;
                      }

                        if (_isClickCheck == false) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                    'Please select a Group!',
                                    style: TextStyle(fontFamily: 'Raleway'),
                                  ),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Okay',
                                        style: TextStyle(
                                            fontFamily: 'Raleway',
                                            color: Colors.red),
                                      ),
                                    )
                                  ],
                                );
                              });
                          return;
                        }



                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        Response _response;
                        Dio dio = new Dio();
                        FormData formdata = new FormData.fromMap({
                          'file': await MultipartFile.fromFile(_excelFile.path,
                              filename: _excelFileName,
                              contentType: MediaType('file', 'xlsx')),
                          'group_id': _groupId,
                        });
                        _response = await dio.post(
                            'https://dev.penmail.com.tr/api/Guidebook/AddWithGroup',
                            data: formdata,
                            options: Options(headers: {
                              'content-type': 'multipart/form-data',
                              'person_token': widget.token
                            }));

                        var _res = await _response.data;
                        var _status =  _res['status'];
                        _message = _res['message'];
                        print(_message);
                        print(_res);
                        print(_status);
                        if(_status == true){
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('File Uploaded Successfully'),
                          ));
                          setState(() {
                            _fileNameExcel = null;
                            _savedExcelFile = null;
                            for (int i = 0; i < _groupListItems.length; i++) {
                              _groupListItems[i].isSelected = false;
                              _isClickCheck = false;
                            }
                          });
                        }else{
                          if(_message == 'Invalid Group Provided'){
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Invalid Group Provided'),
                            ));
                            setState(() {
                              _isLoading = false;
                            });
                            return;
                          }
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Sorry, Please Upload Valid File'),
                          ));
                        }
                        setState(() {
                          _isLoading = false;
                        });


                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                        });
                        if(_message == 'Invalid Group Provided'){
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Invalid Group Provided'),
                          ));
                          return;
                        }
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
                        : Text(
                            'Send Attachment',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                )
              ],
            );
        },
      ),
    );
  }
}

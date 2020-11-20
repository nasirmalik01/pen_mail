import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:pen_mail_project/backend/SendMail.dart';

class MessageScreen extends StatefulWidget {
  final token;

  MessageScreen({this.token});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String _value;
  File _storedImage;
  File _pdfFile;
  String _fileNamePDF;
  File _savedPDF;
  File savedImage;
  var fileName;
  TextEditingController _messageController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isLoading = false;

  Future<void> _getImageFile() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
     fileName = path.basename(imageFile.path);
    savedImage = await imageFile.copy('${appDir.path}/$fileName');
    print('Saved Image: ${_storedImage.toString()}');
  }

  Future<void> _getPdfFile() async {
    final _pickedFile = await FilePicker.getFile(
        allowedExtensions: ['pdf', 'doc'], type: FileType.custom);
    if (_pickedFile == null) {
      return;
    }
    setState(() {
      _pdfFile = _pickedFile;
    });
    final _appDir = await syspaths.getApplicationDocumentsDirectory();
    _fileNamePDF = path.basename(_pickedFile.path);
    _savedPDF = await _pickedFile.copy('${_appDir.path}/$_fileNamePDF');
    print('PDF Attached $_savedPDF');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Send your Mail'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF54A9FF), Color(0xFFC078FF)])),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _messageController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: 'Enter your Message',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    style: TextStyle(fontFamily: 'Raleway'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: IconButton(
                            onPressed: _getImageFile,
                            icon: Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: IconButton(
                            onPressed: _getPdfFile,
                            icon: Icon(
                              Icons.picture_as_pdf,
                              size: 50,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: _storedImage != null
                            ? Image.file(
                                _storedImage,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Text(
                                'No Image Attached!',
                                style: TextStyle(fontFamily: 'Raleway'),
                                textAlign: TextAlign.center,
                              ),
                        alignment: Alignment.center,
                      ),
                      Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        child: Text(
                          _pdfFile != null
                              ? 'File Attached: \n\n${_fileNamePDF.toString()}'
                              : 'No File Attached!',
                          style: TextStyle(fontFamily: 'Raleway'),
                          textAlign: TextAlign.center,
                        ),
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: _sendMail,
                      color: Colors.red,
                      textColor: Colors.white,
                      icon: Icon(Icons.send),
                      label: _isLoading ? SpinKitFadingCircle(color: Colors.white,) :  Text(
                        'Send',
                        style: TextStyle(fontSize: 17, fontFamily: 'Raleway'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendMail() async {
    _formKey.currentState.save();
    if (_messageController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                'Message can\'t be empty',
                style: TextStyle(fontFamily: 'Raleway'),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Okay',
                    style: TextStyle(fontFamily: 'Raleway', color: Colors.red),
                  ),
                )
              ],
            );
          });
      return;
    }

    if (_storedImage == null && _pdfFile == null) {
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
                    style: TextStyle(fontFamily: 'Raleway', color: Colors.red),
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
    print('Message : ${_messageController.text}');
    var _response;
    if (_storedImage != null) {
      _response = await sendMailWithAttachment(
          token: widget.token,
          message: _messageController.text,
          fileName: fileName);
    }

    if (_pdfFile != null) {
      _response = await sendMailWithAttachment(
          token: widget.token,
          message: _messageController.text,
          fileName: _fileNamePDF);
    }

    var _res = jsonDecode(_response);
    print(_res);
    var status = _res['status'];
    if (status == false) {
      setState(() {
        _isLoading = false;
      });
      //print('null');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Error occurred, Try Again'),
      ));
      return;
    }

    setState(() {
      _isLoading = false;
    });
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Mail Sent Successfully'),
    ));
    _messageController.clear();
  }
}

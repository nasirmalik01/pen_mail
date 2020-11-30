import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pen_mail_project/screens/ComposeMessage/ComposeMessageGroup.dart';
import 'package:pen_mail_project/screens/ComposeMessage/ComposeMessageGuidebook.dart';
import 'package:pen_mail_project/widgets/Dialog.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class AttachmentFileScreen extends StatefulWidget {
  final String token;
  final String sendingPerson;
  final String mailSubject;
  final String signatureId;
  final String mailContent;

  AttachmentFileScreen(
      {this.token,
      this.sendingPerson,
      this.mailSubject,
      this.signatureId,
      this.mailContent});

  @override
  _AttachmentFileScreenState createState() => _AttachmentFileScreenState();
}

class _AttachmentFileScreenState extends State<AttachmentFileScreen> {
  File _storedImage;
  String _imageName;
  List<String> _imageNameList = List();
  List<File> _imageFileList = List();

  Future<void> _getImage() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
      _imageName = _storedImage.path.split('/').last;
      _imageNameList.add(_imageName);
      _imageFileList.add(_storedImage);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Attachment File',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: AddAttachment(
              title: _imageFileList.length == 0
                  ? 'Add Attachment File'
                  : 'Add More Images',
              mediaQueryData: MediaQuery.of(context),
              onPress: _getImage,
            ),
          ),
          _imageFileList.length != 0
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: _imageFileList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text('Image Attached:'),
                            subtitle: Text(
                              _imageNameList[index],
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _imageNameList.remove(_imageNameList[index]);
                                  _imageFileList.length =
                                      _imageFileList.length - 1;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 25.0, bottom: 15.0),
                    child: Text(
                      'No Image Attached',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: AttachmentBackButton(
          //           title: 'Back',
          //           mediaQueryData: MediaQuery.of(context),
          //           onPress: () {
          //             Navigator.pop(context);
          //           }),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: ComposeMessageButton(
          //           title: 'Fowrard',
          //           mediaQueryData: MediaQuery.of(context),
          //           onPress: () {
          //             showDialog(
          //                 context: context,
          //                 builder: (BuildContext context) {
          //                   return showDialogChoosing(
          //                       context: context,
          //                       isMail: true,
          //                       onPressGuidebooks: () {
          //                         if(_storedImage == null){
          //                           ComposeMessageError(errorMessage: 'Attachment File is not Provided', context: context);
          //                           return;
          //                         }
          //                         Navigator.push(
          //                             context,
          //                             MaterialPageRoute(
          //                                 builder: (ctx) =>
          //                                     ComposeMessageGuidebook(
          //                                       token: widget.token,
          //                                       sendingPerson: widget.sendingPerson,
          //                                       signatureId: widget.signatureId,
          //                                       mailSubject: widget.mailSubject,
          //                                       mailContent: widget.mailContent,
          //                                       imageFile: _storedImage,
          //                                       imageName: _imageName
          //                                     )));
          //                       },
          //                       onPressGroups: () {
          //                         Navigator.push(
          //                             context,
          //                             MaterialPageRoute(
          //                                 builder: (ctx) =>
          //                                     ComposeMessageGroup(
          //                                         token: widget.token,
          //                                         sendingPerson: widget.sendingPerson,
          //                                         signatureId: widget.signatureId,
          //                                         mailSubject: widget.mailSubject,
          //                                         mailContent: widget.mailContent,
          //                                         imageFile: _storedImage,
          //                                         imageName: _imageName
          //                                     )));
          //                       });
          //                 });
          //           }),
          //     ),
          //   ],
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_imageFileList.isEmpty) {
              ComposeMessageError(
                  errorMessage: 'Attachment File is not Provided',
                  context: context);
              return;
            }
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return showDialogChoosing(
                      context: context,
                      isMail: true,
                      onPressGuidebooks: () {
                        if (_storedImage == null) {
                          ComposeMessageError(
                              errorMessage: 'Attachment File is not Provided',
                              context: context);
                          return;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ComposeMessageGuidebook(
                                    token: widget.token,
                                    sendingPerson: widget.sendingPerson,
                                    signatureId: widget.signatureId,
                                    mailSubject: widget.mailSubject,
                                    mailContent: widget.mailContent,
                                    imageFile: _imageFileList,
                                    imageNames: _imageNameList)));
                      },
                      onPressGroups: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ComposeMessageGroup(
                                    token: widget.token,
                                    sendingPerson: widget.sendingPerson,
                                    signatureId: widget.signatureId,
                                    mailSubject: widget.mailSubject,
                                    mailContent: widget.mailContent,
                                    imageFile: _imageFileList,
                                    imageNames: _imageNameList)));
                      });
                });
          },
          child: Icon(
            Icons.arrow_forward_outlined,
            color: Colors.white,
          )),
    );
  }
}

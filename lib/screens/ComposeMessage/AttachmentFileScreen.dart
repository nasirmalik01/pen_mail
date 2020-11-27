import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> _getImage() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
      _imageName = _storedImage.path.split('/').last;
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            child: Column(
              children: [
                Center(
                  child: AddAttachment(
                      title: 'Add Attachment File',
                      mediaQueryData: MediaQuery.of(context),
                      onPress: _getImage,),
                ),
                _imageName != null ?  Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 25.0, bottom: 15.0),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text( 'Image Attached:'),
                        subtitle: Text(
                          _imageName.toString(),
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.clear
                          ),
                          onPressed: (){
                            setState(() {
                              _imageName = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ) : Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 25.0, bottom: 15.0),
                        child: Text( 'No Image Attached',  style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 18,
                        ),),


                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: AttachmentBackButton(
                    title: 'Back',
                    mediaQueryData: MediaQuery.of(context),
                    onPress: () {
                      Navigator.pop(context);
                    }),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ComposeMessageButton(
                    title: 'Fowrard',
                    mediaQueryData: MediaQuery.of(context),
                    onPress: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return showDialogChoosing(
                                context: context,
                                isMail: true,
                                onPressGuidebooks: () {},
                                onPressGroups: () {});
                          });
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }

  
}

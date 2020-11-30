import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/AppDrawer.dart';
import 'package:pen_mail_project/screens/ComposeMessage/AttachmentFileScreen.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';
import 'package:pen_mail_project/backend/Signature.dart';
import 'package:pen_mail_project/entities/SignatureEntity.dart';
import 'package:pen_mail_project/screens/SendGroups.dart';

class ComposeMessageScreen extends StatefulWidget {
  final String token;

  ComposeMessageScreen({this.token});

  @override
  _ComposeMessageScreenState createState() => _ComposeMessageScreenState();
}

class _ComposeMessageScreenState extends State<ComposeMessageScreen> {
  TextEditingController _sendingPersonController = TextEditingController();
  TextEditingController _mailSubjectController = TextEditingController();
  TextEditingController _mailContentController = TextEditingController();

  List<SignatureEntity> _signatureListItems = List();
  String _signatureId;
  String _initialSignValue;

  List<DropdownMenuItem> _getDropMenuSignatureItems() {
    List<DropdownMenuItem<String>> dropDownCategoryItems = [];

    for (int i = 0; i < _signatureListItems.length; i++) {
      print('called');
      var newItem = DropdownMenuItem(
        child: Text(
          _signatureListItems[i].name,
          style: TextStyle(fontFamily: 'Raleway', fontSize: 18),
        ),
        value: _signatureListItems[i].name,
      );
      dropDownCategoryItems.add(newItem);
    }
    return dropDownCategoryItems;
  }

  Future<List<SignatureEntity>> _getSignatureListItems() async {
    var _response = await getSignatureList(token: widget.token);
    var decodedReply = jsonDecode(_response);
    var decodedData = decodedReply['data'];

    List<SignatureEntity> _groupItems = List();
    for (var _items in decodedData) {
      setState(() {
        _groupItems.add(SignatureEntity.fromJson(_items));
      });
    }
    // for(int i=0; i<_signatureListItems.length; i++){
    //   setState(() {
    //     _initialSignValue = _signatureListItems[0].name;
    //   });
    // }
    return _groupItems;
  }


  _getGroupList() {
    setState(() {
      _getSignatureListItems().then((value) {
        _signatureListItems = value;
        for(int i=0; i<_signatureListItems.length; i++){
          setState(() {
            _initialSignValue = _signatureListItems[0].name;
          });
        }
        return _signatureListItems = value;
      });
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
      appBar: AppBar(
        title: Text(
          'Compose Your Mail',
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
      drawer: AppDrawer(
        token: widget.token,
      ),
      body: FutureBuilder(
        future: _getSignatureListItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
              ),
            );
          } else
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ComposeMessageHeading(heading: 'Sending Person:'),
                  ),
                  ComposeMessageController(
                      controller: _sendingPersonController,
                      hintText: 'Type Sending Person Name Here',
                      inputField: 'Sending Person'),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, left: 16.0, bottom: 16.0),
                    child: ComposeMessageHeading(heading: 'Mail Subject:'),
                  ),
                  ComposeMessageController(
                      controller: _mailSubjectController,
                      hintText: 'Type Mail Subject Here',
                      inputField: 'Mail Subject'),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, left: 16.0, bottom: 16.0),
                    child: ComposeMessageHeading(heading: 'Mail Signature:'),
                  ),
                  Center(
                    child: DropdownButton<String>(
                      value: _initialSignValue,
                      items: _getDropMenuSignatureItems(),
                      onChanged: (value) {
                        setState(() {
                          _initialSignValue = value;
                          for (int i = 0; i < _signatureListItems.length; i++) {
                            if (_initialSignValue ==
                                _signatureListItems[i].name) {
                              _signatureId =
                                  _signatureListItems[i].id.toString();
                            }
                          }
                        });
                      },
                    ),
                  ),
                  // ComposeMessageController(
                  //     controller: _mailSignatureController,
                  //     hintText: 'Type Mail Signature Here',
                  //     inputField: 'Mail Subject'),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25, left: 16.0, bottom: 16.0),
                    child: ComposeMessageHeading(heading: 'Mail Content:'),
                  ),
                  ComposeMessageContentController(
                      controller: _mailContentController,
                      hintText: 'Type Mail Content Here',
                      inputField: 'Mail Content'),

                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: ComposeMessageButton(
                          title: 'Go Forward',
                          mediaQueryData: MediaQuery.of(context),
                          onPress: () {
                            print('IDDDD $_signatureId');
                            if (_sendingPersonController.text.isEmpty) {
                              ComposeMessageError(
                                  context: context,
                                  errorMessage:
                                      'Please provide Sending Person Name');
                              return;
                            }
                            if (_mailContentController.text.isEmpty) {
                              ComposeMessageError(
                                  context: context,
                                  errorMessage: 'Mail Content can\'t be empty');
                              return;
                            }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => AttachmentFileScreen(
                                          token: widget.token,
                                          sendingPerson:
                                              _sendingPersonController.text,
                                          mailSubject:
                                              _mailSubjectController.text,
                                          mailContent:
                                              _mailContentController.text,
                                          signatureId: _signatureId,
                                        )));
                          }),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            );
        },
      ),
    );
  }
}

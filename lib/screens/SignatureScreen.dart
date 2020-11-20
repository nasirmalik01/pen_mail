import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/AppDrawer.dart';
import 'package:pen_mail_project/backend/Signature.dart';
import 'package:pen_mail_project/entities/SignatureEntity.dart';
import 'package:pen_mail_project/widgets/Dialog.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';

class SignatureScreen extends StatefulWidget {
  final token;

  SignatureScreen({this.token});

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {

  bool _isLoading = false;
  bool _isGetGuideBook = false;
  bool _isMore = false;
  int _id;

  List<SignatureEntity> _signatureListItems = List();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

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

    return _groupItems;
  }

  _getGroupList() {
    setState(() {
      _getSignatureListItems().then((value) => _signatureListItems = value);
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
          title: Text('Signature'),
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
              return RefreshIndicator(
                onRefresh: () async {
                  _getGroupList();
                },
                child: ListView.builder(
                    itemCount: _signatureListItems.length,
                    itemBuilder: (context, index) {
                      print(_signatureListItems.length.toString());
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: TextDataContentGroup(
                                      title: _signatureListItems[index].name),
                                  subtitle: TextDataContentGroup(title: _signatureListItems[index].content),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Container(
            width: 80,
            height: 80,
            child: Icon(
              Icons.add,
              size: 35,
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [Color(0xFF54A9FF), Color(0xFFC078FF)])),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return showAddSignatureDialog(
                      title: 'Add New Signature',
                      mediaQueryData: MediaQuery.of(context),
                      nameController: _nameController,
                      contentController: _contentController,
                      isLoading: _isLoading,
                      onPress: () async {

                        if(_nameController.text.isEmpty || _contentController.text.isEmpty){
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });

                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        var _response = await addSignature(
                            token: widget.token,
                            signatureName: _nameController.text,
                            signatureContent: _contentController.text);

                        var _res = jsonDecode(_response);
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
                        _getGroupList();
                        _scaffoldKey.currentState.hideCurrentSnackBar();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Signature Added successfully'),
                        ));
                        _nameController.clear();
                        _contentController.clear();
                        Navigator.pop(context);
                      });
                });
          },
        ));
  }
}

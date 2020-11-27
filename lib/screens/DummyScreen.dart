import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/AppDrawer.dart';
import 'package:pen_mail_project/backend/Signature.dart';
import 'package:pen_mail_project/entities/SignatureEntity.dart';

class DummyScreen extends StatefulWidget {
  final String token;

  DummyScreen({this.token});
  @override
  _DummyScreenState createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  TextEditingController _sendingPersonController = TextEditingController();
  TextEditingController _mailSubjectController = TextEditingController();
  TextEditingController _mailSignatureController = TextEditingController();
  TextEditingController _mailContentController = TextEditingController();

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
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: SpinKitFadingCircle(color: Colors.blue,),
            );
          }else return  ListView.builder(
              itemCount: _signatureListItems.length,
              itemBuilder: (context, index){
                return ListTile(title: Text(_signatureListItems[index].name),);

              });
        },

      ),
    );
  }
}

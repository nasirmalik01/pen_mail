import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/backend/AddGroupGuideBook.dart';
import 'package:pen_mail_project/entities/AddGuideInGroup.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';

class GuidebookGroupScreen extends StatefulWidget {
  final String groupName;
  final String token;
  final int id;

  GuidebookGroupScreen({this.groupName, this.token, this.id});

  @override
  _GuidebookGroupScreenState createState() => _GuidebookGroupScreenState();
}

class _GuidebookGroupScreenState extends State<GuidebookGroupScreen> {
  List<AddGuideBookInGroupEntity> _guideBookInGroup = List<AddGuideBookInGroupEntity>();


  Future<List<AddGuideBookInGroupEntity>> _getGuideBookInGroup() async {
    var _response = await addingGuideBooksInGroups(token: widget.token);
    var _decodedReply = jsonDecode(_response);
    var _decodedData = _decodedReply['data'];

    List<AddGuideBookInGroupEntity> _guideItems =
    List<AddGuideBookInGroupEntity>();
    for (var _items in _decodedData) {
      setState(() {
        _guideItems.add(AddGuideBookInGroupEntity.fromJson(_items));
      });
    }
    return _guideItems;
  }

  _getGuideInGroupList() {
    setState(() {
      _getGuideBookInGroup().then((value) {
        return _guideBookInGroup = value;
      });
    });
  }

  @override
  void initState() {
    _getGuideInGroupList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guidebooks in \'${widget.groupName}\''
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh
            ),
            onPressed: (){
              _getGuideInGroupList();
            },
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF54A9FF), Color(0xFFC078FF)])),
        ),
      ),
      body: FutureBuilder(
        future: _getGuideBookInGroup(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue,
                ));
          } else {
            return RefreshIndicator(
              onRefresh: () async{
                _getGuideInGroupList();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: _guideBookInGroup
                      .map((value) =>
                  value.groupID == widget.id
                      ? Column(
                    children: [
                      //Text(value.groupID.toString()),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8.0),
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 4,
                          child: ListTile(
                            title: Text(value.surname, ),
                          ),
                        ),
                      )
                      //Text(value.id.toString()),
                    ],
                  )
                      : Container())
                      .toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

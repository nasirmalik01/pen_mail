import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';
import 'package:pen_mail_project/AppDrawer.dart';
import 'package:pen_mail_project/backend/GuideBook.dart';
import 'package:pen_mail_project/backend/Messages.dart';
import 'package:pen_mail_project/entities/GuidebookEntity.dart';
import 'package:pen_mail_project/entities/MessagesEntity.dart';
import 'package:pen_mail_project/screens/MessageScreen.dart';
import 'package:pen_mail_project/screens/SendGroups.dart';
import 'package:pen_mail_project/screens/SendGuidebooks.dart';
import 'package:pen_mail_project/widgets/Dialog.dart';

class GetMessageListScreen extends StatefulWidget {
  final String token;

  GetMessageListScreen({this.token});

  @override
  _GetMessageListScreenState createState() => _GetMessageListScreenState();
}

class _GetMessageListScreenState extends State<GetMessageListScreen> {
  List<MessageEntity> _messageListItems = List<MessageEntity>();
  List<GuideBookEntity> guideBookItems = List<GuideBookEntity>();


  Future<List<GuideBookEntity>> getGuideBookList() async {
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


  getListGuidebookItems() {
    setState(() {
      getGuideBookList().then((value) {
        return guideBookItems = value;
      });
    });
  }

  Future<List<MessageEntity>> _getMessages() async {
    var _response = await getMessagesList(token: widget.token);
    var _decodedReply = jsonDecode(_response);
    var _decodedData = _decodedReply['data'];

    List<MessageEntity> _guideItems = List<MessageEntity>();
    for (var _items in _decodedData) {
      setState(() {
        _guideItems.add(MessageEntity.fromJson(_items));
      });
    }
    return _guideItems;
  }

  getList() {
    setState(() {
      _getMessages().then((value) {
        return _messageListItems = value;
      });
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
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
        future: _getMessages(),
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
                getList();
              },
              child: ListView.builder(
                  itemCount: _messageListItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(_messageListItems[index].message ?? 'Null'),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  getListGuidebookItems();
                                  showDialog(context: context, builder: (BuildContext context){
                                    return showDialogChoosing(context: context, isMail: false, onPressGuidebooks:(){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SendGuidebooks(token: widget.token,messageId: _messageListItems[index].id,)
                                      ));
                                    },onPressGroups: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SendGroups(token: widget.token,messageId: _messageListItems[index].id,)
                                      ));
                                    });
                                  });
                                }),
                          ),
                        ),
                      ),
                    );
                  }),
            );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => MessageScreen(token: widget.token,),
      //         ));
      //   },
      //   child: Container(
      //     width: 80,
      //     height: 80,
      //     child: Icon(
      //       Icons.add,
      //       size: 35,
      //     ),
      //     decoration: BoxDecoration(
      //         shape: BoxShape.circle,
      //         gradient: LinearGradient(
      //             colors: [Color(0xFF54A9FF), Color(0xFFC078FF)])),
      //   ),
      // ),
    );
  }

  Widget showDialogsGuidebooks({BuildContext context}) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)), //this right here
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: FutureBuilder(
            future: getGuideBookList(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: SpinKitFadingCircle(color: Colors.blue,),
                );
              }else{
               return Padding(
                 padding: const EdgeInsets.symmetric(vertical:12.0, horizontal: 8),
                 child: ListView.builder(
                    itemCount: guideBookItems.length,
                    itemBuilder: (context, index){
                      return Column(
                        children: [
                          CheckboxListTile(
                            title: Text(guideBookItems[index].surname, style: TextStyle(
                              fontFamily: 'Nunito'
                            ),),
                            subtitle: Text(guideBookItems[index].email,style: TextStyle(
                                fontFamily: 'Nunito'
                            ),),
                            value: guideBookItems[index].isCheck??false,
                            onChanged: (value){
                              setState(() {
                                guideBookItems[index].isCheck = value;
                                print(guideBookItems[index].id);
                              });
                            },
                          ),
                          Divider()
                        ],
                      );
                    },
                  ),
               );
              }
            }
          ),
        ));
  }
}
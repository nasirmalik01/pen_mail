// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:pen_mail_project/AppDrawer.dart';
// import 'package:pen_mail_project/backend/AddGroupGuideBook.dart';
// import 'package:pen_mail_project/backend/Groups.dart';
// import 'package:pen_mail_project/backend/GuideBook.dart';
// import 'package:pen_mail_project/entities/AddGuideInGroup.dart';
// import 'package:pen_mail_project/entities/GroupsEntity.dart';
// import 'package:pen_mail_project/entities/GuidebookEntity.dart';
// import 'package:pen_mail_project/screens/AddGuideBook.dart';
// import 'package:pen_mail_project/widgets/Dialog.dart';
// import 'package:pen_mail_project/widgets/Widgets.dart';
//
// class GroupPageScreen extends StatefulWidget {
//   final token;
//
//   GroupPageScreen({this.token});
//
//   @override
//   _GroupPageScreenState createState() => _GroupPageScreenState();
// }
//
// class _GroupPageScreenState extends State<GroupPageScreen> {
//   bool _isLoading = false;
//   bool _isGetGuideBook = false;
//   bool _isMore = false;
//   int _id;
//
//   List<GroupEntity> _groupListItems = List();
//   TextEditingController _addGroupController = TextEditingController();
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   List<AddGuideBookInGroupEntity> _guideBookInGroup = List<AddGuideBookInGroupEntity>();
//
//   Future<List<GroupEntity>> _getGroupListItems() async {
//     var _response = await getGroupList(token: widget.token);
//     var decodedReply = jsonDecode(_response);
//     var decodedData = decodedReply['data'];
//
//     List<GroupEntity> _groupItems = List();
//     for (var _items in decodedData) {
//       _groupItems.add(GroupEntity.fromJson(_items));
//     }
//
//     return _groupItems;
//   }
//
//   Future<List<AddGuideBookInGroupEntity>> _getGuideBookInGroup() async {
//     var _response = await addingGuideBooksInGroups(token: widget.token);
//     var _decodedReply = jsonDecode(_response);
//     var _decodedData = _decodedReply['data'];
//
//     List<AddGuideBookInGroupEntity> _guideItems =
//     List<AddGuideBookInGroupEntity>();
//     for (var _items in _decodedData) {
//       _guideItems.add(AddGuideBookInGroupEntity.fromJson(_items));
//     }
//     return _guideItems;
//   }
//
//   _getGuideInGroupList() {
//     setState(() {
//       _getGuideBookInGroup().then((value) {
//         return _guideBookInGroup = value;
//       });
//     });
//   }
//
//   _getGroupList() {
//     setState(() {
//       _getGroupListItems().then((value) => _groupListItems = value);
//     });
//   }
//
//   @override
//   void initState() {
//     _getGroupList();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: Text('Groups'),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: <Color>[Color(0xFF54A9FF), Color(0xFFC078FF)])),
//           ),
//         ),
//         drawer: AppDrawer(
//           token: widget.token,
//         ),
//         body: FutureBuilder(
//           future: _getGroupListItems(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return Center(
//                 child: SpinKitFadingCircle(
//                   color: Colors.blue,
//                 ),
//               );
//             } else
//               return RefreshIndicator(
//                 onRefresh: () async {
//                   _getGroupList();
//                 },
//                 child: ListView.builder(
//                     itemCount: _groupListItems.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8.0, vertical: 4.0),
//                         child: Card(
//                           elevation: 5,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               children: [
//                                 ListTile(
//                                   onTap: () {
//                                     setState(() {
//                                       _groupListItems[index].onClick??false == false
//                                           ? _groupListItems[index].onClick = true
//                                           : _groupListItems[index].onClick = false;
//
//                                       _id = _groupListItems[index].id;
//
//                                     });
//                                     print('Id : $_id');
//                                     _getGuideInGroupList();
//                                   },
//                                   title: TextDataContentGroup(
//                                       title: _groupListItems[index].name),
//                                   trailing: IconButton(
//                                     icon: Icon(Icons.add_circle_outline),
//                                     onPressed: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   AddGuideBook(
//                                                       token: widget.token,
//                                                       surname:
//                                                       _groupListItems[index]
//                                                           .name,
//                                                       groupId:
//                                                       _groupListItems[index]
//                                                           .id)));
//                                     },
//                                   ),
//                                 ),
//                                 _groupListItems[index].onClick ?? false
//                                     ? FutureBuilder(
//                                   future: _getGuideBookInGroup(),
//                                   builder: (context, snapshot) {
//                                     if (!snapshot.hasData) {
//                                       return Center(
//                                           child: Text('Loading'));
//                                     } else {
//                                       return SingleChildScrollView(
//                                         child: Column(
//                                           children: _guideBookInGroup
//                                               .map((value) =>
//                                           value.groupID == _id
//                                               ? Column(
//                                             children: [
//                                               //Text(value.groupID.toString()),
//                                               Text(value.guideBookID.toString()),
//                                               //Text(value.id.toString()),
//                                             ],
//                                           )
//                                               : Container())
//                                               .toList(),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 )
//                                     : Container()
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//               );
//           },
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: Container(
//             width: 80,
//             height: 80,
//             child: Icon(
//               Icons.add,
//               size: 35,
//             ),
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                     colors: [Color(0xFF54A9FF), Color(0xFFC078FF)])),
//           ),
//           onPressed: () {
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return showAddGroupDialog(
//                       title: 'Add Group',
//                       addGroupController: _addGroupController,
//                       mediaQueryData: MediaQuery.of(context),
//                       isLoading: _isLoading,
//                       onPress: () async {
//                         setState(() {
//                           _isLoading = true;
//                         });
//
//                         FocusScopeNode currentFocus = FocusScope.of(context);
//                         if (!currentFocus.hasPrimaryFocus) {
//                           currentFocus.unfocus();
//                         }
//
//                         var _response = await addGroup(
//                             token: widget.token,
//                             groupName: _addGroupController.text);
//
//                         var _res = jsonDecode(_response);
//                         var status = _res['status'];
//                         if (status == false) {
//                           setState(() {
//                             _isLoading = false;
//                           });
//                           //print('null');
//                           _scaffoldKey.currentState.showSnackBar(SnackBar(
//                             content: Text('Error occurred, Try Again'),
//                           ));
//                           return;
//                         }
//
//                         setState(() {
//                           _isLoading = false;
//                         });
//                         _getGroupList();
//                         _scaffoldKey.currentState.showSnackBar(SnackBar(
//                           content: Text('Group Added successfully'),
//                         ));
//                         _addGroupController.clear();
//                         Navigator.pop(context);
//                       });
//                 });
//           },
//         ));
//   }
// }

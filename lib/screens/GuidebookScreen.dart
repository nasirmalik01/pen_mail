import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/AppDrawer.dart';
import 'package:pen_mail_project/backend/GuideBook.dart';
import 'package:pen_mail_project/entities/GuidebookEntity.dart';
import 'package:pen_mail_project/widgets/Dialog.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';

class GuideBook extends StatefulWidget {
  final token;

  GuideBook({this.token});

  @override
  _GuideBookState createState() => _GuideBookState();
}

class _GuideBookState extends State<GuideBook> {
  List<GuideBookEntity> guideBookItems = List<GuideBookEntity>();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _gsmController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _isLoading = false;
  bool _isUpdateLoading = false;

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

  getList() {
    setState(() {
      getGuideBookList().then((value) {
        return guideBookItems = value;
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
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Guide Book',
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
          future: getGuideBookList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue,
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  getList();
                },
                child: ListView.builder(
                    itemCount: guideBookItems.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Row(
                                    children: [
                                      TextDataTitle(title: 'Surname: '),
                                      TextDataContent(
                                          title: guideBookItems[index].surname)
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          TextDataTitle(title: 'Email: '),
                                          TextDataContent(
                                              title:
                                                  guideBookItems[index].email)
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Color(0xFF087CEA),
                                        ),
                                        onPressed: () {
                                          TextEditingController
                                              _surnameUpdateController =
                                              TextEditingController(
                                                  text: guideBookItems[index]
                                                      .surname);
                                          TextEditingController
                                              _emailUpdateController =
                                              TextEditingController(
                                                  text: guideBookItems[index]
                                                      .email);
                                          TextEditingController
                                              _gsmUpdateController =
                                              TextEditingController(
                                                  text: guideBookItems[index]
                                                      .gsm);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return showUpdateDialog(
                                                  mediaQueryData:
                                                      MediaQuery.of(context),
                                                  emailController:
                                                      _emailUpdateController,
                                                  surnameController:
                                                      _surnameUpdateController,
                                                  gsmController:
                                                      _gsmUpdateController,
                                                  isLoading: _isUpdateLoading,
                                                  title: 'Update GuideBook',
                                                  onPress: () async {
                                                    if (_surnameUpdateController
                                                            .text
                                                            .trim()
                                                            .isEmpty ||
                                                        _emailUpdateController
                                                            .text
                                                            .trim()
                                                            .isEmpty ||
                                                        _gsmUpdateController
                                                            .text
                                                            .trim()
                                                            .isEmpty) {
                                                      return;
                                                    }
                                                    setState(() {
                                                      _isUpdateLoading = true;
                                                    });
                                                    FocusScopeNode
                                                        currentFocus =
                                                        FocusScope.of(context);
                                                    if (!currentFocus
                                                        .hasPrimaryFocus) {
                                                      currentFocus.unfocus();
                                                    }

                                                    var _updateResponse =
                                                        await updateGuideBook(
                                                            surname:
                                                                _surnameUpdateController
                                                                    .text,
                                                            gsm:
                                                                _gsmUpdateController
                                                                    .text,
                                                            email:
                                                                _emailUpdateController
                                                                    .text,
                                                            id: guideBookItems[
                                                                    index]
                                                                .id,
                                                            token:
                                                                widget.token);
                                                    var _res = jsonDecode(
                                                        _updateResponse);
                                                    var status = _res['status'];
                                                    if (status == false) {
                                                      setState(() {
                                                        _isUpdateLoading =
                                                            false;
                                                      });
                                                      return;
                                                    }

                                                    _scaffoldKey.currentState
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'GuideBook updated successfully'),
                                                    ));

                                                    setState(() {
                                                      _isUpdateLoading = false;
                                                    });

                                                    _surnameController.clear();
                                                    _gsmController.clear();
                                                    _emailController.clear();
                                                    getList();
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02),
                                  child: Row(
                                    children: [
                                      TextDataTitle(title: 'GSM: '),
                                      TextDataContent(
                                          title: guideBookItems[index].gsm)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
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
                  return showAddDialog(
                      surnameController: _surnameController,
                      emailController: _emailController,
                      gsmController: _gsmController,
                      mediaQueryData: MediaQuery.of(context),
                      isLoading: _isLoading,
                      title: 'Add GuideBook',
                      onPress: () async {
                        if (_surnameController.text.trim().isEmpty ||
                            _emailController.text.trim().isEmpty ||
                            _gsmController.text.trim().isEmpty) {
                          return;
                        }
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }

                        setState(() {
                          _isLoading = true;
                        });
                        var _response = await addGuideBook(
                            token: widget.token,
                            email: _emailController.text,
                            gsm: _gsmController.text,
                            surname: _surnameController.text);
                        var _res = jsonDecode(_response);
                        var status = _res['status'];
                        if (status == false) {
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }
                        _scaffoldKey.currentState.hideCurrentSnackBar();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('GuideBook added successfully'),
                        ));

                        setState(() {
                          _isLoading = false;
                        });

                        _surnameController.clear();
                        _gsmController.clear();
                        _emailController.clear();
                        getList();
                        Navigator.pop(context);
                      });
                });
          },
        ));
  }
}

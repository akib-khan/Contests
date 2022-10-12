import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/screens/create.dart';
import 'package:tabs/screens/settings.dart';
import 'package:tabs/services/auth.dart';
import 'package:tabs/tabsContainer.dart';
import 'dart:io' show Platform;

class Home extends StatefulWidget {
  static const String id = "home_screen";
  final String uid;
  Home(this.uid);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Icon customIcon = const Icon(Icons.search);

  Widget customSearchBar = const Text('My contests');

  TextEditingController _searchController = new TextEditingController();
  String _searchText = "";

  _HomeState() {
    _searchController.addListener(() {
      if( _searchController.text.isEmpty ) {
        setState(() {
          _searchText="";
        });
      }
      else {
        setState(() {
          _searchText=_searchController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffefefe),
      appBar: new AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.6],
                colors: [
                  Theme.of(context).primaryColor.withGreen(190),
                  Theme.of(context).primaryColor,
                ],
              ),
          ),
        ),
        actions: [
          IconButton(
            color: Theme.of(context).accentColor,
            icon: customIcon,
            onPressed: () {
              setState(() {
                // Perform set of instructions.
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'type in friend name...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('My Contests');
                  _searchController.clear();
                }
              });
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          //TextField(searchController.text),
          Container(
            height: 225,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.1, 0.6],
                colors: [
                  Theme.of(context).primaryColor.withGreen(190),
                  Theme.of(context).primaryColor,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
                bottomRight: Radius.elliptical(
                    MediaQuery.of(context).size.width * 0.50, 18),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(Settings.id);
              },
            ),
          ),
          /*Positioned(
            top: 30,
            right: 5,
            child: IconButton(
              color: Theme.of(context).accentColor,
              icon: customIcon,
              onPressed: () {
                setState(() {
                    // Perform set of instructions.
                    if (customIcon.icon == Icons.search) {
                      customIcon = const Icon(Icons.cancel);
                      customSearchBar = const ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                        title: TextField(
                          decoration: InputDecoration(
                            hintText: 'type in journal name...',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                    customIcon = const Icon(Icons.search);
                    customSearchBar = const Text('My Personal Journal');
                  }
                });
              },
            ),
          ),*/
          SafeArea(
            child: MultiProvider(
              providers: [
                StreamProvider<QuerySnapshot>(
                  create: (context) =>
                      TabsController.getUsersTabs(this.widget.uid),
                ),
              ],
              child: TabsContainer( searchString: _searchController.text),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool flag = await Auth.isEmailVerified();
          if (flag)
            Navigator.pushNamed(context, NewTab.id);
          else
            _showEmailConfirmDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void _showEmailConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text("Sorry, you need to verify your email first"),
          content: Text("Please check your email"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("Resend Email"),
              onPressed: () {
                Auth.sendEmailVerification();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      } else
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text("Sorry, you need to verify your email first"),
          content: Text("Please check your email"),
          actions: <Widget>[
            TextButton(
              child: Text("OK", style: TextStyle(color:Colors.black87 )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Resend Email",style: TextStyle(color:Colors.black87 )),
              onPressed: () {
                Auth.sendEmailVerification();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
    },
  );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TabsState with ChangeNotifier {
  String _name = "";

  String get name => _name;

  bool filterEnabled = false;

  bool nameMatches(String name) {
    if (!filterEnabled) return true;
    return name.contains(new RegExp(_name,caseSensitive: false));
  }

  List<DocumentSnapshot> openTabs(QuerySnapshot tabs, String searchString ) {
    // make sure we clear the name filter if all the tabs have been removed for that person
    if( searchString != "" ) {
      filterEnabled = true;
      _name = searchString;
    }
    else {
      filterEnabled=false;
    }
    if (tabs.documents.where((t) => nameMatches(t["name"])).isEmpty) _name = "";
    return tabs.documents
        .where((t) => t["closed"] == false)
        .where((t) => nameMatches(t["name"]))
        .toList()
          ..sort((a, b) => a["time"].toDate().compareTo(b["time"].toDate()));
  }

  List<DocumentSnapshot> closedTabs(QuerySnapshot tabs) {
    return tabs.documents
        .where((t) => t["closed"] == true)
        .where((t) => nameMatches(t["name"]))
        .toList()
          ..sort((a, b) => a["time"].toDate().compareTo(b["time"].toDate()));
  }

  void filterByName(String name) {
    filterEnabled ? _name = "" : _name = name;
    notifyListeners();
  }
}

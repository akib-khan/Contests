import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:tabs/controllers/tabsController.dart';
import 'package:tabs/providers/settingsState.dart';
import 'package:tabs/widgets/changeAmountDialog.dart';
import 'package:intl/intl.dart';
import 'package:smart_select/smart_select.dart';

class TabModal extends StatefulWidget {
  final DocumentSnapshot tab;
  TabModal({@required this.tab});

  @override
  State<TabModal> createState() => _TabModalState();
}

class _TabModalState extends State<TabModal> {
  String _fruit = 'Me';

  

  @override
  Widget build(BuildContext context) {
    String displayAmount =
        this.widget.tab["rewards"];
    DateFormat formatter = DateFormat("yyyy/MM/dd");
    String formattedDateOpened =
        formatter.format(DateTime.parse(this.widget.tab["time"].toDate().toString()));
        final List<S2Choice<String>> fruits = [
          S2Choice<String>(value: 'Me', title: 'Me'),
          S2Choice<String>(value: '${this.widget.tab["name"]}', title: '${this.widget.tab["name"]}'),
          S2Choice<String>(value: 'Draw', title: 'Draw'),
        ];
    return Container(
      height: 450,
      margin: EdgeInsets.only(left: 18, right: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
                this.widget.tab["userOwesFriend"] == true
                    ? "I Owe ${this.widget.tab["name"]}"
                    : "Contest with ${this.widget.tab["name"]}",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold)),
            Text(
              "$formattedDateOpened",
              style: Theme.of(context).textTheme.overline,
            ),
            
              //padding: const EdgeInsets.only(top: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.caption,
                    
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                  child: Text(
                  "${this.widget.tab["description"]}",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                  ),
                ],
              ),
              //padding: const EdgeInsets.only(top: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /*Text(
                    "Description",
                    style: Theme.of(context).textTheme.caption,
                  ),*/
                   Flexible(
                  child: Text(
                    "Reward",
                    style: Theme.of(context).textTheme.caption,
                  ),
                   ),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                child: Text(
                  "$displayAmount",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                  ),
                ],
            ),
            
            Column(
              //this.widget.tab["closed"] == true? {
              children: <Widget>[
                if( this.widget.tab["closed"] == false ) ...[
                const SizedBox(height: 7),
                SmartSelect<String>.single(
                  title: 'Select Winner',
                  value: _fruit,
                  choiceItems: fruits,
                  onChange: (state) => setState(() => _fruit = state.value),
                  modalType: S2ModalType.popupDialog,
                  tileBuilder: (context, state) {
                    return S2Tile.fromState(
                      state,
                      leading: const Icon(Icons.person),
                    );
                  },
                )
                ]
                else ...[
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   if( this.widget.tab["winner"] != "Draw" ) ...[
                  Text("Winner is "),
                  Text("${this.widget.tab["winner"]}", style: const TextStyle(fontWeight: FontWeight.bold))
                  ]
                  else ...[
                    Text("Contest ended in Draw")
                  ]
                  ]
                  )
                ]
                ],
              ),
            Expanded(
              child: Image(
                image: AssetImage(
                  this.widget.tab["userOwesFriend"] == true
                      ? 'assets/graphics/together.png'
                      : 'assets/graphics/money-guy.png',
                ),
                fit: BoxFit.contain,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  child: Text(this.widget.tab["closed"] == true
                      ? "Reopen Contest"
                      : "Change Reward"),
                  onPressed: () {
                    if (this.widget.tab["closed"] == true) {
                      TabsController.reopenTab(this.widget.tab.documentID);
                      Navigator.pop(context);
                    } else
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ChangeAmountDialog(tab: this.widget.tab);
                          });
                  },
                ),
                ElevatedButton(
                  child:
                      Text(this.widget.tab["closed"] == true ? "Delete" : "Close Contest"),
                  onPressed: () {
                    this.widget.tab["closed"] == true
                        ? TabsController.deleteTab(this.widget.tab.documentID)
                        : TabsController.closeTab(this.widget.tab.documentID, _fruit);
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

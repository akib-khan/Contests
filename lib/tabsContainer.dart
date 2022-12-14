import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tabs/providers/tabsState.dart';
import 'package:tabs/widgets/openTabs.dart';
import 'package:tabs/widgets/closedTabs.dart';
import 'package:tabs/widgets/tabsInfoHeader.dart';

class TabsContainer extends StatefulWidget {
  @override
  _TabsContainerState createState() => _TabsContainerState();

  final String searchString;
  TabsContainer({@required this.searchString});
}

class _TabsContainerState extends State<TabsContainer> {
  int currentPageIndex = 0;

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      height: 12,
      width: isActive ? 24 : 12,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuerySnapshot>(
      builder: (context, tabsData, child) {
        if (tabsData == null)
          return Center(
            child: SpinKitDoubleBounce(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
          );
        else
          return ChangeNotifierProvider<TabsState>(
            create: (_) => TabsState(),
            child: Column(
              children: <Widget>[
                Consumer<TabsState>(
                  builder: (context, tabsState, child) {
                    return TabsInfoHeader(
                      openTabs: tabsState.openTabs(tabsData, this.widget.searchString), searchString: this.widget.searchString,
                    );
                  },
                ),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < 2; i++)
                            if (i == currentPageIndex) ...[circleBar(true)] else
                              circleBar(false),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (int page) {
                      setState(() {
                        currentPageIndex = page;
                      });
                    },
                    children: <Widget>[
                      Consumer<TabsState>(
                        builder: (context, tabsState, child) {
                          return OpenTabs(
                            tabs: tabsState.openTabs(tabsData, this.widget.searchString),
                          );
                        },
                      ),
                      Consumer<TabsState>(
                        builder: (context, tabsState, child) {
                          return ClosedTabs(
                            tabs: tabsState.closedTabs(tabsData),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
      },
    );
  }
}

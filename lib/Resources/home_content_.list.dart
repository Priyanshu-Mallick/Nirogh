import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets/call_us_card.dart';
import '../Widgets/horizontal_card1.dart';
import '../Widgets/popular_lab.dart';
import '../Widgets/popular_test.dart';

class HomeContent{
  Widget contentList(BuildContext context, int index){
    if (index == 0) {
      // The first item in the list
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: HorizontalCard(),
      );
    } else if (index == 1) {
      // The second item in the list (Popular Labs section)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: CallUsCard(),
      );
    } else if (index == 2) {
      // The thired item in the list (Popular Tests section)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: PopularLabsWidget(),
      );
    } else if (index == 3) {
      // The thired item in the list (Popular Tests section)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: PopularTestsWidget(),
      );
    } else if (index == 4) {
      // The thired item in the list (Popular Tests section)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: HorizontalCard(),
      );
    } else if (index == 5) {
      // The thired item in the list (Popular Tests section)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: HorizontalCard(),
      );
    } else if (index == 6) {
      // The thired item in the list (Popular Tests section)
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: HorizontalCard(),
      );
    }
    else {
      // The rest of the list items
      return ListTile(
        title: Text('Item ${index}'),
      );
    }
  }
}
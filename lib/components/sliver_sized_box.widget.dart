import 'package:flutter/cupertino.dart';

class SliverSizedBox extends SliverToBoxAdapter {

  SliverSizedBox({Key key, double height, double width, Widget child})
      : super(
            key: key,
            child: SizedBox(
              child: child,
              width: width,
              height: height,
            ));
}

import 'package:fluid_layout/fluid_layout.dart';
import 'package:flutter/cupertino.dart';

class SliverFluidToBoxAdapter extends SliverFluid {

  SliverFluidToBoxAdapter({double horizontalPadding, bool fluid = true, Widget child})
      : super(
            horizontalPadding: horizontalPadding,
            fluid: fluid,
            sliver: SliverToBoxAdapter(child: child));
}

class SliverBoolBuilder extends SliverPadding {

  SliverBoolBuilder({bool value, Widget Function(bool value, Widget child) builder, Widget child})
      : super(
      padding: EdgeInsets.zero,
      sliver: builder(value, child));
}


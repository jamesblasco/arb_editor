import 'dart:convert';
import 'dart:html';

import 'package:arb_editor/components/sliver_fluid_to_box_adapter.dart';
import 'package:arb_editor/components/sliver_sized_box.widget.dart';

import 'package:arb_editor/pages/project_page/app_header.widget.dart';

import 'package:arb_editor/pages/project_page/create_resource_card.dart';
import 'package:arb_editor/pages/project_page/locale/locale_tag_selector.dart';
import 'package:arb_editor/pages/project_page/project_header_bar.widget.dart';
import 'package:arb_editor/pages/project_page/resource/resource_card.dart';

import 'package:fluid_layout/fluid_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arb_editor/utils.dart';

class ProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverSizedBox(height: FluidLayout.of(context).horizontalPadding),
          SliverFluidToBoxAdapter(
            child: AppHeader(),
          ),
          SliverSizedBox(height: 12),
          SliverFluidToBoxAdapter(
            child: ProjectHeaderBar(),
          ),
          SliverSizedBox(height: 8),
          SliverFluidToBoxAdapter(
            child: LocaleTagSelector(),
          ),
          SliverSizedBox(height: 12),
          SliverFluidToBoxAdapter(
              child: Container(
            color: Colors.white.withOpacity(0.2),
            width: double.infinity,
            height: 1,
          )),
          SliverSizedBox(height: 12),
          SliverFluidGrid(
            children: context.arb.resources.values
                .map((resource) => FluidCell.fit(
                    size: context.fluid(12, xl: 6),
                    child: ResourceCard(resource: resource)))
                .toList()
                  ..add(FluidCell.fit(size: 12, child: CreateResourceCard())),
          ),
          SliverSafeArea(
            sliver: SliverSizedBox(height: 100),
          )
        ],
      ),
    );
  }
}


import 'dart:async';
import 'dart:html';

import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/i18n/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

enum _DragState {
  dragging,
  notDragging,
}

class DropZone extends StatefulWidget {
  final Function(List<File> files) onFilesAdded;


  const DropZone({Key key, this.onFilesAdded}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DropZoneState();
  }
}

class _DropZoneState extends State<DropZone> {

  StreamSubscription<MouseEvent> _onDragOverSubscription;
  StreamSubscription<MouseEvent> _onDropSubscription;

  final StreamController<Point<double>> _pointStreamController = new StreamController<Point<double>>.broadcast();
  _DragState state = _DragState.notDragging;



  @override
  void dispose() {
    _onDropSubscription.cancel();
    _onDragOverSubscription.cancel();
    _pointStreamController.close();
    super.dispose();
  }

  void _onDrop(MouseEvent value) {
    value.stopPropagation();
    value.preventDefault();
    _pointStreamController.sink.add(null);
    widget.onFilesAdded(value.dataTransfer.files);
  }


  void _onDragOver(MouseEvent value) {
    value.stopPropagation();
    value.preventDefault();
    _pointStreamController.sink.add(Point<double>(value.layer.x.toDouble(), value.layer.y.toDouble()));
    setState(() {
      state = _DragState.dragging;
    });
  }

  @override
  void initState() {
    super.initState();
    this._onDropSubscription = document.body.onDrop.listen(_onDrop);
    this._onDragOverSubscription = document.body.onDragOver.listen(_onDragOver);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
                color: 
                Colors.white,
            ),
            borderRadius: BorderRadius.circular(20),
            color: state ==
        _DragState.dragging ? Colors.white : Colors.transparent
                
        ),
        child: Center(child:
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(AppStrings.of(context).dragFiles, style: state ==
                    _DragState.dragging ? Theme.of(context).textTheme.title : Theme.of(context).accentTextTheme.title),
                SizedBox(height: 12),
                Text(AppStrings.of(context).or, style: state ==
                    _DragState.dragging ? Theme.of(context).textTheme.caption : Theme.of(context).accentTextTheme.caption),
                SizedBox(height: 12),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0),
                    //  side: BorderSide(color: Colors.red)
                  ),
                 color: Colors.white.withOpacity(0.2),
                 textColor: Colors.white,
                 onPressed: () => {
                    context.arbBloc.add(CreateProject(ArbProject('app', documents: [ArbDocument('en_US')])))
               }, child: Text(AppStrings.of(context).createEmptyProject),)
              ],
            )
        ),
      ),
    );
  }
}
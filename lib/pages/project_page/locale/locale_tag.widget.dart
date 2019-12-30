import 'package:flutter/material.dart';

class LocaleTag extends StatelessWidget {
  final String locale;
  final bool selected;
  final Function(String locale) onSelect;

  const LocaleTag(
      {Key key, @required this.locale, this.selected = false, this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onSelect(locale),
            child: Container(
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.white30,
                  borderRadius: BorderRadius.circular(12),),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        locale
                            .split('_')
                            ?.first ?? 'undefined',
                        style: selected
                            ? Theme
                            .of(context)
                            .accentTextTheme
                            .caption
                            .copyWith(color: Theme
                            .of(context)
                            .accentColor)
                            : Theme
                            .of(context)
                            .accentTextTheme
                            .caption,
                      ),
                    ),
                    if (locale
                        .split('_')
                        .length > 1)
                      Container(

                        color: Colors.black.withOpacity(0.05),
                        padding: EdgeInsets.all(8),
                        child: Text(
                          locale.split('_')[1],
                          style: selected
                              ? Theme
                              .of(context)
                              .accentTextTheme
                              .caption
                              .copyWith(
                              color: Theme
                                  .of(context)
                                  .accentColor)
                              : Theme
                              .of(context)
                              .accentTextTheme
                              .caption,
                        ),
                      ),
                  ],
                )))));
  }
}

class AddTag extends StatelessWidget {
  final String locale;
  final bool selected;
  final Function(String locale) onSelect;

  const AddTag(
      {Key key, @required this.locale, this.selected = false, this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onSelect(locale),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.white30,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                locale ?? 'undefined',
                style: selected
                    ? Theme
                    .of(context)
                    .accentTextTheme
                    .caption
                    .copyWith(color: Theme
                    .of(context)
                    .accentColor)
                    : Theme
                    .of(context)
                    .accentTextTheme
                    .caption,
              ),
            )));
  }
}

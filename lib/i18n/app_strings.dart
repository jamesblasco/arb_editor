import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';
/// Callers can lookup localized strings with an instance of AppStrings returned
/// by `AppStrings.of(context)`.
///
/// Applications need to include `AppStrings.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l18n/appstrings.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppStrings.localizationsDelegates,
///   supportedLocales: AppStrings.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: 0.16.0
///   intl_translation: 0.17.7
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppStrings.supportedLocales
/// property.
class AppStrings {
  AppStrings(Locale locale) : _localeName = Intl.canonicalizedLocale(locale.toString());
  final String _localeName;
  static Future<AppStrings> load(Locale locale) {
    return initializeMessages(locale.toString())
      .then<AppStrings>((_) => AppStrings(locale));
  }
  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings);
  }
  static const LocalizationsDelegate<AppStrings> delegate = _AppStringsDelegate();
  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('es', 'VE'),
    Locale('fr', 'FR'),
  ];
  String get title {
    return Intl.message(
      r'AR',
      locale: _localeName,
      name: 'title',
      desc: r'Id description'
    );
  }

  String get market {
    return Intl.message(
      r'Market',
      locale: _localeName,
      name: 'market',
      desc: r'Market test'
    );
  }

  String get portfolio {
    return Intl.message(
      r'portfolio',
      locale: _localeName,
      name: 'portfolio',
      desc: r''
    );
  }

  String get addDescription {
    return Intl.message(
      r'Add description',
      locale: _localeName,
      name: 'addDescription',
      desc: r''
    );
  }

  String get test {
    return Intl.message(
      r'asd',
      locale: _localeName,
      name: 'test',
      desc: r''
    );
  }

  String get trial {
    return Intl.message(
      r'a',
      locale: _localeName,
      name: 'trial',
      desc: r''
    );
  }

  String get tert {
    return Intl.message(
      r'sgfh',
      locale: _localeName,
      name: 'tert',
      desc: r''
    );
  }

  String get mode {
    return Intl.message(
      r'sdfdg',
      locale: _localeName,
      name: 'mode',
      desc: r'fhgfh'
    );
  }

}
class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();
  @override
  Future<AppStrings> load(Locale locale) => AppStrings.load(locale);
  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'es', 'fr'].contains(locale.languageCode);
  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}

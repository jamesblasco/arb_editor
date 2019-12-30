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
    Locale('es', 'ES'),
    Locale('en', 'US'),
  ];
  String get dragFiles {
    return Intl.message(
      r'Arrastra aqui archivos .arb para empezar un nuevo projecto',
      locale: _localeName,
      name: 'dragFiles',
      desc: r'Description for dragging dart files to add a new project'
    );
  }

  String get or {
    return Intl.message(
      r'o',
      locale: _localeName,
      name: 'or',
      desc: r''
    );
  }

  String get createEmptyProject {
    return Intl.message(
      r'Crear un projecto nuevo',
      locale: _localeName,
      name: 'createEmptyProject',
      desc: r'Create an empty project button'
    );
  }

  String get recentProjects {
    return Intl.message(
      r'Projectos recientes',
      locale: _localeName,
      name: 'recentProjects',
      desc: r'Recent projects title'
    );
  }

  String get lastUpdate {
    return Intl.message(
      r'Última actualización',
      locale: _localeName,
      name: 'lastUpdate',
      desc: r'Last update label'
    );
  }

  String get newResource {
    return Intl.message(
      r'Crear un nuevo recurso',
      locale: _localeName,
      name: 'newResource',
      desc: r'create new resource button'
    );
  }

  String get id {
    return Intl.message(
      r'Id',
      locale: _localeName,
      name: 'id',
      desc: r'id word'
    );
  }

  String get addDescription {
    return Intl.message(
      r'Añadir descripción',
      locale: _localeName,
      name: 'addDescription',
      desc: r'Add description label'
    );
  }

  String get idAlreadyExists {
    return Intl.message(
      r'Este id ya existe',
      locale: _localeName,
      name: 'idAlreadyExists',
      desc: r'Error : id already exits'
    );
  }

  String get empty {
    return Intl.message(
      r'Vacio',
      locale: _localeName,
      name: 'empty',
      desc: r'empty work'
    );
  }

  String get delete {
    return Intl.message(
      r'Borrar',
      locale: _localeName,
      name: 'delete',
      desc: r'delete button'
    );
  }

  String get download {
    return Intl.message(
      r'Descargar',
      locale: _localeName,
      name: 'download',
      desc: r'descargar'
    );
  }

  String get deleteDialogTitle {
    return Intl.message(
      r'¿Quieres eliminar este projecto?',
      locale: _localeName,
      name: 'deleteDialogTitle',
      desc: r'Do you want to delete this project?'
    );
  }

  String get deleteDialogMessage {
    return Intl.message(
      r'Este cambio es irreversible, ¿estás seguro que quieres eliminarlo para siempre?',
      locale: _localeName,
      name: 'deleteDialogMessage',
      desc: r'This change is irreversible, are you sure you want to delete it forever?'
    );
  }

  String get cancel {
    return Intl.message(
      r'Cancelar',
      locale: _localeName,
      name: 'cancel',
      desc: r'cancel action'
    );
  }

  String get addLocale {
    return Intl.message(
      r'Crear una nueva traducción',
      locale: _localeName,
      name: 'addLocale',
      desc: r'add translation'
    );
  }

  String get create {
    return Intl.message(
      r'Crear',
      locale: _localeName,
      name: 'create',
      desc: r'create action'
    );
  }

  String get project {
    return Intl.message(
      r'Proyecto',
      locale: _localeName,
      name: 'project',
      desc: r''
    );
  }

}
class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();
  @override
  Future<AppStrings> load(Locale locale) => AppStrings.load(locale);
  @override
  bool isSupported(Locale locale) => <String>['es', 'en'].contains(locale.languageCode);
  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}

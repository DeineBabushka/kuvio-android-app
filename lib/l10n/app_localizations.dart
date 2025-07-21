import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kuvio/l10n/app_localizations_de.dart';
import 'package:kuvio/l10n/app_localizations_en.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];
  String get welcomeTitle;
  String get welcomeSubtitle;
  String get letsGo;

  String get general;
  String get account;
  String get favorites;
  String get shoppingList;
  String get comments;
  String get adminDashboard;
  String get customization;
  String get darkMode;
  String get language;
  String get settings;
  String get logout;
  String get notLoggedIn;
  String get loginRegister;

  String get loading;
  String get noUserDataFound;
  String get accountSectionTitle;
  String get accountBio;
  String get accountFavoriteKitchen;
  String get accountFavoriteDish;
  String get deleteAccount;
  String get deleteAccountHint;
  String get editProfile;
  String get errorWrongPassword;
  String get errorRequiresRecentLogin;
  String get errorUserMismatch;
  String get errorChangePassword;
  String get errorDeleteAccount;
  String get noUserLoggedIn;
  String get confirmPasswordTitle;
  String get password;
  String get cancel;
  String get confirm;
  String get deleteAccountTitle;
  String get deleteAccountWarning;
  String get delete;
  String get changePassword;
  String get passwordChanged;
  String get currentPassword;
  String get enterCurrentPassword;
  String get newPassword;
  String get enterNewPassword;
  String get passwordHint;
  String get repeatPassword;
  String get repeatPasswordHint;
  String get passwordsDontMatch;
  String get profileUpdated;
  String get notSpecified;
  String get kitchenItalian;
  String get kitchenChinese;
  String get kitchenIndian;
  String get kitchenMexican;
  String get kitchenJapanese;
  String get kitchenGerman;
  String get kitchenTurkish;
  String get kitchenVegan;
  String get kitchenVegetarian;
  String get whatToCook;
  String get selectCategory;
  String get selectDietAndCategory;

  String get categoryStarter;
  String get categoryMain;
  String get categoryDessert;
  String get categorySide;
  String get categorySnack;
  String get categoryBreakfast;
  String get categoryLowCalorie;
  String get dietRaw;
  String get dietGlutenFree;
  String get dietFish;
  String get dietKeto;
  String get dietMeat;
  String get dietVegetarian;
  String get dietOmnivore;
  String get dietVegan;

  String get searchHint;
  String get filterLabelCategory;
  String get filterLabelDiet;

  String getString(String key) {
    final map = {
      'notSpecified': notSpecified,
      'kitchenItalian': kitchenItalian,
      'kitchenChinese': kitchenChinese,
      'kitchenIndian': kitchenIndian,
      'kitchenMexican': kitchenMexican,
      'kitchenJapanese': kitchenJapanese,
      'kitchenGerman': kitchenGerman,
      'kitchenTurkish': kitchenTurkish,
      'kitchenVegan': kitchenVegan,
      'kitchenVegetarian': kitchenVegetarian,
    };
    return map[key] ?? key;
  }

  String get favoritesTitle;
  String get noFavoritesFound;
  String get searchRecipesHint;
  String get categoryLabel;
  String get dietTypeLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

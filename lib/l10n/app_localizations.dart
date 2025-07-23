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
  String get showRecipesButton;

  String get navAccount;
  String get navShoppingList;
  String get navComments;
  String get navFavorites;

  String get filteredRecipesTitle;
  String get searchRecipeByNameHint;
  String get noRecipesFound;
  String get myCommentsTitle;

  String get portionsLabel;

  String get ingredientsLabel;
  String get instructionsLabel;
  String get cookedWithKuvio;

  String get durationLabel;
  String get nutritionPerPortionLabel;
  String get addAllIngredients;

  String get nutritionCalories;
  String get nutritionProtein;
  String get nutritionCarbs;
  String get nutritionFat;

  String get commentsTitle;
  String get noComments;
  String get commentHint;
  String get commentLoginError;

  String get addedToFavorites;
  String get removedFromFavorites;
  String get addedAllToShoppingList;
  String addedSingleToShoppingList(String name);

  String get tabAllItems;
  String get tabByRecipe;
  String get loginToViewShoppingList;

  String get recipe;
  String get shoppingListEmpty;
  String get removeRecipeFromShoppingList;
  String itemDeleted(String itemName);
  String recipeItemsDeleted(String recipeTitle);

  String get deleteAllIngredients;
  String get shoppingListCleared;

  String get loginTitle;
  String get loginEmailLabel;
  String get loginPasswordLabel;
  String get loginForgotPassword;
  String get loginButton;
  String get loginGoogle;
  String get loginNoAccount;
  String get loginRegisterNow;
  String get loginErrorMissingEmail;
  String get loginErrorInvalidEmail;
  String get loginErrorMissingPassword;
  String get loginErrorWrongCredentials;
  String get loginErrorUnknown;
  String get loginErrorGoogleFailed;
  String get loginSuccess;
  String get loginGoogleSuccess;
  String get googleLoginCancelled;
  String get googleLoginNoUser;
  String get googleLoginFailed;
  String get registerLabel;
  String get usernameLabel;
  String get usernameError;
  String get emailLabel;
  String get emailEmptyError;
  String get emailInvalidError;
  String get passwordLabel;
  String get passwordError;

  String get unknownRecipeTitle;
  String get deleteCommentTitle;
  String get deleteCommentText;
  String get commentDeleted;

  String get deleteFavoriteTitle;
  String get deleteFavoriteText;

  String get deleteUserTitle;
  String get deleteUserText;

  String get logoutSuccess;

  String get registrationFailed;
  String get registrationSuccess;

  String get accountDeletedSuccess;
  String get deletionFailed;

  String get resetPasswordTitle;
  String get emailAddressLabel;
  String get submit;
  String get resetEmailSent;
  String get error;

  String get addedOn;

  String get noCommentsFound;

  String get noDescription;

  String get selectProfileImage;

  String get profileOfflineNotAvailable;

  String get emailAlreadyInUse;
  String get invalidEmail;
  String get weakPassword;
  String get offlineTitle;
  String get offlineMessage;
  String get offlineCheckFailed;
  String get ok;
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

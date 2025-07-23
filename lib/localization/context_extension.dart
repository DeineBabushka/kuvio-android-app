import 'package:flutter/widgets.dart';
import 'package:kuvio/localization/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}

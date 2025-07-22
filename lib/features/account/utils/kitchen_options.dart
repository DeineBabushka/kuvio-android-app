import 'package:flutter/material.dart';
import 'package:kuvio/l10n/context_extension.dart';

List<String> kitchenOptions(BuildContext context) {
  return [
    context.loc.notSpecified,
    context.loc.kitchenItalian,
    context.loc.kitchenChinese,
    context.loc.kitchenIndian,
    context.loc.kitchenMexican,
    context.loc.kitchenJapanese,
    context.loc.kitchenGerman,
    context.loc.kitchenTurkish,
    context.loc.kitchenVegan,
    context.loc.kitchenVegetarian,
  ];
}

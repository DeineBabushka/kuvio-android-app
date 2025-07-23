import 'package:flutter/material.dart';
import 'package:kuvio/localization/context_extension.dart';

class AccountDeleteHint extends StatelessWidget {
  const AccountDeleteHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.loc.deleteAccountHint,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white60, fontSize: 13),
    );
  }
}

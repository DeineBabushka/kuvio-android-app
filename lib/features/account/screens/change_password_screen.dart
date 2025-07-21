import 'package:flutter/material.dart';
import 'package:kuvio/features/account/widgets/change_password_form.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.changePassword),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: ChangePasswordForm(),
      ),
    );
  }
}

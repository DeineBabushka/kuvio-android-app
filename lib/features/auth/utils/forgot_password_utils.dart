import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/l10n/context_extension.dart';

Future<void> showForgotPasswordDialog(BuildContext context) async {
  final emailController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      final loc = context.loc;

      return AlertDialog(
        title: Text(loc.resetPasswordTitle),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: loc.emailAddressLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: email);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.resetEmailSent),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${loc.error}: $e')),
                  );
                }
              }
            },
            child: Text(loc.submit),
          ),
        ],
      );
    },
  );
}

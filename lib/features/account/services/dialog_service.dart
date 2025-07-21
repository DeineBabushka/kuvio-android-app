import 'package:flutter/material.dart';
import 'package:kuvio/l10n/context_extension.dart';

class DialogService {
  static Future<String?> askForPassword(BuildContext context) async {
    final controller = TextEditingController();
    String? result;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.loc.confirmPasswordTitle,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.loc.password,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(context.loc.cancel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: Text(context.loc.confirm),
                    onPressed: () {
                      result = controller.text;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    return result;
  }

  static Future<bool> confirmAccountDeletion(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(context.loc.deleteAccountTitle),
              content: Text(context.loc.deleteAccountWarning),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(context.loc.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    context.loc.delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

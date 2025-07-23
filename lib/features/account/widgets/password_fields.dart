import 'package:flutter/material.dart';
import 'package:kuvio/features/account/widgets/password_field.dart';
import 'package:kuvio/features/account/widgets/password_decorator.dart';
import 'package:kuvio/features/account/widgets/password_validators.dart';
import 'package:kuvio/localization/context_extension.dart';

class PasswordInputFields {
  static Widget buildCurrentPasswordField({
    required TextEditingController controller,
    required Color inputColor,
    required Color labelColor,
    required Color fillColor,
    required Color focusColor,
  }) {
    return Builder(
      builder: (context) {
        return PasswordInputField(
          controller: controller,
          label: context.loc.currentPassword,
          hint: context.loc.enterCurrentPassword,
          validator: (value) => validateCurrentPassword(value, context),
          textColor: inputColor,
          decoration: buildPasswordInputDecoration(
            label: context.loc.currentPassword,
            hint: context.loc.enterCurrentPassword,
            labelColor: labelColor,
            fillColor: fillColor,
            focusColor: focusColor,
          ),
        );
      },
    );
  }

  static Widget buildNewPasswordField({
    required TextEditingController controller,
    required Color inputColor,
    required Color labelColor,
    required Color fillColor,
    required Color focusColor,
  }) {
    return Builder(
      builder: (context) {
        return PasswordInputField(
          controller: controller,
          label: context.loc.newPassword,
          hint: context.loc.passwordHint,
          validator: (value) => validateNewPassword(value, context),
          textColor: inputColor,
          decoration: buildPasswordInputDecoration(
            label: context.loc.newPassword,
            hint: context.loc.passwordHint,
            labelColor: labelColor,
            fillColor: fillColor,
            focusColor: focusColor,
          ),
        );
      },
    );
  }

  static Widget buildRepeatPasswordField({
    required TextEditingController controller,
    required TextEditingController newPasswordController,
    required Color inputColor,
    required Color labelColor,
    required Color fillColor,
    required Color focusColor,
  }) {
    return Builder(
      builder: (context) {
        return PasswordInputField(
          controller: controller,
          label: context.loc.repeatPassword,
          hint: context.loc.repeatPasswordHint,
          validator: (value) => validateRepeatPassword(
              value, newPasswordController.text, context),
          textColor: inputColor,
          decoration: buildPasswordInputDecoration(
            label: context.loc.repeatPassword,
            hint: context.loc.repeatPasswordHint,
            labelColor: labelColor,
            fillColor: fillColor,
            focusColor: focusColor,
          ),
        );
      },
    );
  }
}

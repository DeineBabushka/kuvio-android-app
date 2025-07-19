import 'package:flutter/material.dart';
import 'password_input_field.dart';
import 'password_input_decoration_helper.dart';
import 'password_validators.dart';

class PasswordInputFields {
  static Widget buildCurrentPasswordField({
    required TextEditingController controller,
    required Color inputColor,
    required Color labelColor,
    required Color fillColor,
    required Color focusColor,
  }) {
    return PasswordInputField(
      controller: controller,
      label: 'Aktuelles Passwort',
      hint: 'Gib dein aktuelles Passwort ein',
      validator: validateCurrentPassword,
      textColor: inputColor,
      decoration: buildPasswordInputDecoration(
        label: 'Aktuelles Passwort',
        hint: 'Gib dein aktuelles Passwort ein',
        labelColor: labelColor,
        fillColor: fillColor,
        focusColor: focusColor,
      ),
    );
  }

  static Widget buildNewPasswordField({
    required TextEditingController controller,
    required Color inputColor,
    required Color labelColor,
    required Color fillColor,
    required Color focusColor,
  }) {
    return PasswordInputField(
      controller: controller,
      label: 'Neues Passwort',
      hint: 'Mindestens 6 Zeichen',
      validator: validateNewPassword,
      textColor: inputColor,
      decoration: buildPasswordInputDecoration(
        label: 'Neues Passwort',
        hint: 'Mindestens 6 Zeichen',
        labelColor: labelColor,
        fillColor: fillColor,
        focusColor: focusColor,
      ),
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
    return PasswordInputField(
      controller: controller,
      label: 'Passwort wiederholen',
      hint: 'Wiederhole das neue Passwort',
      validator: (value) {
        return validateRepeatPassword(value, newPasswordController.text);
      },
      textColor: inputColor,
      decoration: buildPasswordInputDecoration(
        label: 'Passwort wiederholen',
        hint: 'Wiederhole das neue Passwort',
        labelColor: labelColor,
        fillColor: fillColor,
        focusColor: focusColor,
      ),
    );
  }
}

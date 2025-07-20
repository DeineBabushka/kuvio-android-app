import 'package:kuvio/shared/services/user_service.dart';
import 'package:kuvio/shared/models/app_user.dart';

class UserLoader {
  final UserService userService;
  UserLoader(this.userService);

  Future<AppUser?> loadUser() async {
    return userService.fetchAndParseUser();
  }
}

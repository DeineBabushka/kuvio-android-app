import '../services/user_service.dart';
import '../models/app_user.dart';

class UserLoader {
  final UserService userService;
  UserLoader(this.userService);

  Future<AppUser?> loadUser() async {
    return userService.fetchAndParseUser();
  }
}

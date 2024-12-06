import 'package:sigede_movil/core/models/status_model.dart';
import 'package:sigede_movil/core/models/user_info_model.dart';

class UserAccount {
  String email;
  UserInfo fkUserInfo;
  Status fkStatus;

  UserAccount({
    required this.fkStatus,
    required this.fkUserInfo,
    required this.email
  });
}
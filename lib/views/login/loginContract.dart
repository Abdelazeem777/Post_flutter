import 'package:post/base/baseContract.dart';

abstract class LoginContract extends BaseContract {
  void onLoginSuccess();

  void onSignupSuccess();
}
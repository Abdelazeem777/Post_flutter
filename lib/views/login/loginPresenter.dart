import 'package:post/repository/usersRepository.dart';
import 'package:post/views/login/loginContract.dart';

class LoginPresenter {
  LoginContract _view;
  UsersRepository _contactsRepository;

  LoginPresenter(this._view) {
    _contactsRepository = UsersRepositoryImpl();
  }

  void login(String email, String password) {
    _contactsRepository.login(email, password).listen((_) {
      _view.onLoginSuccess();
    }).onError((exception) {
      _view.showError(exception.toString());
    });
  }

  void signup(String username, String email, String password) {
    _contactsRepository.singup(username,email, password).listen((_) {
      _view.onSignupSuccess();
    }).onError((exception) {
      _view.showError(exception.toString());
    });
  }
}

import 'package:post/repository/usersRepository.dart';
import 'package:post/views/home/homeContract.dart';

class HomePresenter {
  HomeContract _view;
  UsersRepository _contactsRepository;

  HomePresenter(this._view) {
    _contactsRepository = UsersRepositoryImpl();
  }

  void logout() {
    _contactsRepository.logout().listen((_) {
      _view.onLogoutSuccess();
    }).onError((exception) {
      _view.showError(exception.toString());
    });
  }

}
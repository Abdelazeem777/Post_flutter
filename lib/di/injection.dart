import 'package:post/repository/usersRepository.dart';
import 'package:post/service/networkService.dart';

class Injector {
  static final Injector _singleton = new Injector._internal();

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  UsersRepository get usersRepository {
    return new UsersRepositoryImpl();
  }

  NetworkService get networkService {
    return new NetworkService();
  }
}

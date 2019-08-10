import 'dart:convert';

import 'package:post/apiEndpoint.dart';
import 'package:post/di/injection.dart';
import 'package:post/model/user.dart';
import 'package:post/service/networkService.dart';
import 'package:post/util/preferences.dart';
import 'package:post/util/requestException.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

abstract class UsersRepository {
  

  Observable<void> login(String email, String password);
  Observable<void> logout();
  Observable<void> singup(String username, String email, String password);
}

class UsersRepositoryImpl implements UsersRepository {
  final NetworkService _networkService = Injector().networkService;
  final JsonDecoder _decoder = new JsonDecoder();
  @override
  Observable<void> login(String email, String password) {
    Map data = {'email': email, 'password': password};

    return Observable.fromFuture(_networkService.post(ApiEndPoint.LOG_IN, data))
        .flatMap((res) {
          Map resultMap=_networkService.convertJsonToMap(res.body);
      if (resultMap["statusCode"] != 200 || null == resultMap["statusCode"]) {
        throw new RequestException(resultMap["message"]);
      }
      else{
      final String userName = resultMap["user_name"];
      Preferences.getUserName(userName);
      final String token = resultMap["id"];
      return Preferences.setToken(token);
      }
    });
  }

  @override
  Observable<void> singup(String username, String email, String password) {
    Map data = {'username':username,'email': email, 'password': password};
    return Observable.fromFuture(_networkService.post(ApiEndPoint.SIGN_UP, data))
        .flatMap((res) {
          Map resultMap=_networkService.convertJsonToMap(res.body);
      if (resultMap["statusCode"] != 200 || null == resultMap["statusCode"]) {
        throw new RequestException(resultMap["message"]);
      }
      else{
      final String userName = resultMap["user_name"];
      Preferences.getUserName(userName);
      final String token = resultMap["id"];
      return Preferences.setToken(token);
      }
    });
  }

  @override
  Observable<void> logout() {
    return Preferences.clear();
  }

  
}

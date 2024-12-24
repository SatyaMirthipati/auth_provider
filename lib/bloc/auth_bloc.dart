import 'package:auth_provider/data/local/shared_prefs.dart';
import 'package:flutter/material.dart';

import '../repository/auth_repo.dart';

class AuthBloc with ChangeNotifier {
  final _authRepo = AuthRepo();

  Future login({required body}) async {
    var response = await _authRepo.login(body: body);
    // TODO: Pick the response from the api & save the token if token is available
    var token = response['access_token'];
    await Prefs.setToken(token);
    return response;
  }
}

import 'package:auth_provider/data/network/api_client.dart';

class AuthRepo {
  Future login({required body}) async {
    var response = await apiClient.post(
      '', // TODO: Place your login api url this ex: (/auth/login)
      body,
    );
    return response;
  }
}

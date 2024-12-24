import 'package:auth_provider/data/network/api_client.dart';
import 'package:dio/dio.dart';

import '../local/shared_prefs.dart';

class DioClient implements ApiClient {
  late Dio dio;
  String baseUrl =
      ''; // TODO: Place your API url here example: https://yourdomain.com

  DioClient() {
    dio = Dio();
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
    );
  }

  Future<Options> getOptions({String? t}) async {
    Map<String, dynamic> headers = {'Accept': 'application/json'};
    var token = t ?? await Prefs.getToken();
    if (token != null) headers['Authorization'] = token;
    headers['Content-Type'] = 'application/json';
    print(headers);
    return Options(headers: headers, responseType: ResponseType.json);
  }

  @override
  Future post(String path, body, {query, t, bool isBuildUrl = true}) async {
    var response = await dio.post(
      (path),
      data: body,
      queryParameters: query,
      options: await getOptions(t: t),
    );
    return response.data;
  }
}

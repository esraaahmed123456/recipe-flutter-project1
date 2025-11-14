import 'package:dio/dio.dart';
import 'constants.dart';

class DioClient {
  final Dio dio;
  DioClient._internal(this.dio) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print(">>> ${options.method} ${options.uri}");
        handler.next(options);
      },
      onResponse: (response, handler) {
        print("<<< ${response.statusCode} ${response.requestOptions.uri}");
        handler.next(response);
      },
      onError: (err, handler) {
        print("!!! ERROR !!! ${err}");
        handler.next(err);
      },
    ));
  }

  factory DioClient() {
    final dio = Dio(BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ));
    return DioClient._internal(dio);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(path, queryParameters: queryParameters);
  }
}

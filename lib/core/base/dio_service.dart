import 'package:dio/dio.dart';
import 'package:flight_sync_admin/core/base/app_session.dart';
import 'package:flight_sync_admin/core/constants/constant.dart';
import 'package:logger/logger.dart';


class DioService {
  static String baseUrl = Constant.baseURL;

  static Dio getDio(){
    // Logger().i('Creating Dio instance without authentication');
    Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: getHeader(),
      ),
    );
    dio.interceptors.add(getAuthInterceptor());
    return dio;
  }

  // static Dio getDioAuth({bool isPicUpload = false}) {
  //   // Logger().i('Creating Dio instance with authentication');
  //   Dio dio = Dio(
  //     BaseOptions(
  //       baseUrl: baseUrl,
  //       headers: getHeader(isPicUpload: isPicUpload),
  //       connectTimeout: const Duration(milliseconds: 6000),
  //       receiveTimeout: const Duration(milliseconds: 7000),
  //     ),
  //   );
  //   dio.interceptors.add(getAuthInterceptor());
  //   return dio;
  // }

  static Map<String, dynamic> getHeader({bool isPicUpload = false}) {
String? accessToken ;
    Future.delayed(Duration(milliseconds: 50), () async {
     accessToken  = await AppSession.getAccessToken();
      Logger().i('Retrieved access token: $accessToken');
    });
    Map<String, dynamic> header = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': isPicUpload ? 'multipart/form-data' : 'application/json',
      'Accept': 'application/json',
    };
    // Logger().i('Constructed header: $header');
    return header;
  }

  static InterceptorsWrapper getAuthInterceptor() {
    var logger = Logger();
    return InterceptorsWrapper(
      onRequest: (requestOptions, handler) async{
        String? accessToken = await AppSession.getAccessToken();
        requestOptions.headers['Authorization'] = 'Bearer $accessToken';
        logger.d(
          'REQUEST[${requestOptions.method}] => PATH: ${requestOptions.path}'
          ' => REQUEST VALUES: ${requestOptions.queryParameters} => HEADERS: ${requestOptions.headers}',
        );
        logger.d('REQUEST DATA==> ${requestOptions.data.toString()}');

        return handler.next(requestOptions);
      },
      onResponse: (response, handler) {
       // logger.i('RESPONSE[${response.statusCode}] => DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (err, handler) async {
        logger.e('RESPONSE[${err}]');
        logger.e('RESPONSE[BODY] ${err.response?.data}');

        if (err.response?.statusCode == 408) {
            return handler.next(DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            type: DioExceptionType.connectionTimeout,
            error: err.error,
            message: 'Connection timeout',
          ));
        }

        if (err.response?.statusCode == 500) {
          return handler.next(DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            type: DioExceptionType.connectionTimeout,
            error: err.error,
            message: 'Internal server error',
          ));
        }

       
  //       if (err.response?.statusCode == 401) {
  //         EasyLoading.dismiss();

  //         // bool tokenRefreshed = await _refreshToken();

  //         if (tokenRefreshed) {
  //           final options = err.requestOptions;
  //           final String? accessToken = await AppSession.getAccessToken();
  //           options.headers['Authorization'] =
  //               'Bearer $accessToken';
  //           final dio = Dio();
  //           try {
  //             final clonedRequest = await dio.request(
  //               options.path,
  //               options: Options(
  //                 method: options.method,
  //                 headers: options.headers,
  //               ),
  //               data: options.data,
  //               queryParameters: options.queryParameters,
  //             );
  //             return handler.resolve(clonedRequest);
  //           } catch (e) {
  //             logger.e('Retry error: $e');
  //             return handler.next(err);
  //           }
  //         } else {
  //           return handler.next(err);
  //         }
  //       }

    return handler.next(err);
    },
    );
  }

}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flight_sync_admin/core/base/app_session.dart';
import 'package:flight_sync_admin/core/base/dio_service.dart';
import 'package:flight_sync_admin/core/constants/constant.dart';
import 'package:flight_sync_admin/core/models/api_return_value.dart';

import 'package:logger/logger.dart';

class ApiService {
  final String login = "admin-login";
  final String signUp = "register";

  final Dio _dio = DioService.getDio();
  // final Dio _dioAuth = DioService.getDioAuth();

  final Duration _receiveTimeout = const Duration(seconds: 60);
  final Duration _connectTimeout = const Duration(seconds: 70);
  final String baseUrl = Constant.baseURL;

  late ApiReturnValue apiResult;

  Future<ApiReturnValue> userSingin(String email, String password) async {

    Logger().i('from userSingin $email $password');
    final String apiUrl = '$baseUrl/$login';
    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
        data: jsonEncode({
          "email": email.trim(),
          "password": password.trim(),
        }),
      );
      Logger().i('from userSingin ${response.data}');
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(
          message: e.response?.data['message'] ??
              'Some thing wrong please try again !');
    } on Exception catch (e) {
      Logger().w('from exception ${e.toString()}');
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> userSignUp(Map<String, dynamic> data) async {
    final String apiUrl = '$baseUrl/$signUp';
    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
        data: jsonEncode(data),
      );
      Logger().i('from dio ${response.data}');
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> fetchDashboardData() async {
    final String apiUrl = '$baseUrl/dashboard-report';
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> fetchAircraftModels() async {
    final String apiUrl = '$baseUrl/aircraft-models';
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> addAircraftModel({required Map<String, dynamic> data}) async {
    final String apiUrl = '$baseUrl/aircraft-models';
    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
        data: jsonEncode(data),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }


  Future<ApiReturnValue> deleteAircraftModel({required int id}) async {
    final String apiUrl = '$baseUrl/aircraft-models/$id';
    try {
      final response = await _dio.delete(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> fetchFacLevels() async {
    final String apiUrl = '$baseUrl/fac-levels';
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );

      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> addFacLevels(
      {required Map<String, dynamic> data}) async {
    final String apiUrl = '$baseUrl/fac-levels';
    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
        data: jsonEncode(data),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> deleteFacLevels({required int id}) async {
    final String apiUrl = '$baseUrl/fac-levels/$id';
    try {
      final response = await _dio.delete(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> fetchMissions() async {
    final String apiUrl = '$baseUrl/missions';
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> addMissions(
      {required Map<String, dynamic> data}) async {
    final String apiUrl = '$baseUrl/missions';
    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
        data: jsonEncode(data),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> deleteMissions({required int id}) async {
    final String apiUrl = '$baseUrl/missions/$id';
    try {
      final response = await _dio.delete(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> fetchRlLevels() async {
    final String apiUrl = '$baseUrl/rl-levels';
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> deleteRlLevels(int id) async {
    final String apiUrl = '$baseUrl/rl-levels/$id';
    try {
      final response = await _dio.delete(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> addRlLevels(
      {required Map<String, dynamic> data}) async {
    final String apiUrl = '$baseUrl/rl-levels';
    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
        data: jsonEncode(data),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> fetchDutyPositions() async {
    final String apiUrl = '$baseUrl/duty-positions';
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> deleteDutyPositions(int id) async {
    final String apiUrl = '$baseUrl/duty-positions/$id';
    try {
      final response = await _dio.delete(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> addDutyPositions(
      {required Map<String, dynamic> data}) async {
    final String apiUrl = '$baseUrl/duty-positions';
    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
        data: jsonEncode(data),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }


  Future<ApiReturnValue> fetchRanks() async {
    final String apiUrl = '$baseUrl/ranks';
    try {
      final response = await _dio.get(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> deleteRank(int id) async {
    final String apiUrl = '$baseUrl/ranks/$id';
    try {
      final response = await _dio.delete(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  Future<ApiReturnValue> addRank(
      {required Map<String, dynamic> data}) async {
    final String apiUrl = '$baseUrl/ranks';
    try {
      final response = await _dio.post(
        apiUrl,
        options: Options(
          contentType: 'application/json',
          receiveTimeout: _receiveTimeout,
          sendTimeout: _connectTimeout,
        ),
        data: jsonEncode(data),
      );
      return ApiReturnValue.fromMap(response.data);
    } on DioException catch (e) {
      Logger().w('from dio ${e.response?.data}');
      return ApiReturnValue(message: e.response?.data['message']);
    } on Exception catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }
}

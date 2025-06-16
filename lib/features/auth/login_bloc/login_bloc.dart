import 'package:flight_sync_admin/core/base/api_service.dart';
import 'package:flight_sync_admin/core/base/app_session.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';
import 'package:flight_sync_admin/core/models/api_return_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoginLoading());
      final ApiReturnValue result =
          await ApiService().userSingin(event.email, event.password);
      if (result.status == 'success') {
       await AppSession.setAccessToken(result.data?['token']);
        emit(LoginSuccess(AdminLoginData.fromJson(result.data ?? {})));
      } else {
        emit(LoginFailure(result.message ?? 'Login failed'));
      }
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }
}

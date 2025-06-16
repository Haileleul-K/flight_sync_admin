import 'package:flight_sync_admin/core/base/api_service.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';
import 'package:flight_sync_admin/core/models/api_return_value.dart';
import 'package:flight_sync_admin/features/dashboard/bloc/dashboard_event.dart';
import 'package:flight_sync_admin/features/dashboard/bloc/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(DashboardLoading());
  ApiReturnValue response =await ApiService().fetchDashboardData();

  if(response.data != null){

      final monthlyTrends = List.generate(
        10,
        (index) => MonthlyTrend(
          date: DateTime(2024, index + 1),
          commercial: 70 + (index * 5),
          cargo: 40 + (index * 3),
          training: 35 + (index * 2),
        ),
      );
     
     DashboardData data = DashboardData.fromJson(response.data);
     
          emit(
        DashboardLoaded(
          totalPilots: data.totalUsers,
          totalFlights: data.totalFlightsLogged,
          totalAircraftHours: data.totalAircraftHours,
          totalSimulatorHours: data.totalSimulatorHours,
          monthlyTrends: monthlyTrends,
          aircraftUsage: data.aircraftUsage.entries.map((e)=>AircraftUsage(model: e.key, hours: e.value.hours)).toList()
        ),
      );
  }
    } catch (error) {
      emit(DashboardError(error.toString()));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      await _onLoadDashboardData(LoadDashboardData(), emit);
    }
  }
}

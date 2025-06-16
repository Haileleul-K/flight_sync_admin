import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_sync_admin/core/base/api_service.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';

part 'mission_event.dart';
part 'mission_state.dart';

class MissionBloc extends Bloc<MissionEvent, MissionState> {
  MissionBloc() : super(MissionInitial()) {
    on<FetchMissions>(_onFetchMissions);
    on<DeleteMission>(_onDeleteMission);
    on<AddMission>(_onAddMission);
    on<SearchMission>(_onSearchMission);
  }

  ApiService apiService = ApiService();

  void _onFetchMissions(
    FetchMissions event,
    Emitter<MissionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await apiService.fetchMissions();
    if (response.data != null) {
      final missions =
          List<Mission>.from(response.data.map((e) => Mission.fromJson(e)));
      emit(state.copyWith(
          isLoading: false, missions: missions, originalMissions: missions));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onDeleteMission(DeleteMission event, Emitter<MissionState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.deleteMissions(id: event.id);
    if (response.status == 'success') {
      final updatedOriginalList =
          List<Mission>.from(state.originalMissions ?? [])
            ..removeWhere((element) => element.id == event.id);
      final updatedFilteredList = List<Mission>.from(state.missions ?? [])
        ..removeWhere((element) => element.id == event.id);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          missions: updatedFilteredList,
          originalMissions: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onAddMission(AddMission event, Emitter<MissionState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.addMissions(data: event.mission.toMap());
    if (response.data != null) {
      final newMission = Mission.fromJson(response.data);
      final updatedOriginalList =
          List<Mission>.from(state.originalMissions ?? [])..add(newMission);
      final updatedFilteredList = List<Mission>.from(state.missions ?? [])
        ..add(newMission);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          missions: updatedFilteredList,
          originalMissions: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onSearchMission(SearchMission event, Emitter<MissionState> emit) {
    if (state.originalMissions != null) {
      final filteredMissions = state.originalMissions!.where((mission) {
        final code = mission.code?.toLowerCase() ?? '';
        final label = mission.label?.toLowerCase() ?? '';
        final query = event.query.toLowerCase();

        return code.contains(query) || label.contains(query);
      }).toList();

      emit(state.copyWith(
        missions: filteredMissions,
        message: null,
      ));
    }
  }
}

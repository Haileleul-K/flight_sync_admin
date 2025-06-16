import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_sync_admin/core/base/api_service.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';

part 'rl_level_event.dart';
part 'rl_level_state.dart';

class RlLevelBloc extends Bloc<RlLevelEvent, RlLevelState> {
  RlLevelBloc() : super(RlLevelInitial()) {
    on<FetchRlLevels>(_onFetchRlLevels);
    on<DeleteRlLevel>(_onDeleteRlLevel);
    on<AddRlLevel>(_onAddRlLevel);
    on<SearchRlLevel>(_onSearchRlLevel);
  }
  ApiService apiService = ApiService();

  void _onFetchRlLevels(FetchRlLevels event, Emitter<RlLevelState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.fetchRlLevels();
    if (response.data != null) {
      final rlLevels =
          List<RlLevel>.from(response.data.map((e) => RlLevel.fromJson(e)));
      emit(state.copyWith(
          isLoading: false, rlLevels: rlLevels, originalRlLevels: rlLevels));
    } else {
      emit(state.copyWith(isLoading: false, error: response.message));
    }
  }

  void _onDeleteRlLevel(DeleteRlLevel event, Emitter<RlLevelState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.deleteRlLevels(event.id);
    if (response.status == 'success') {
      final updatedOriginalList =
          List<RlLevel>.from(state.originalRlLevels ?? [])
            ..removeWhere((element) => element.id == event.id);
      final updatedFilteredList = List<RlLevel>.from(state.rlLevels ?? [])
        ..removeWhere((element) => element.id == event.id);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          rlLevels: updatedFilteredList,
          originalRlLevels: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, error: response.message));
    }
  }

  void _onAddRlLevel(AddRlLevel event, Emitter<RlLevelState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.addRlLevels(data: event.rlLevel.toMap());
    if (response.data != null) {
      final newRlLevel = RlLevel.fromJson(response.data);
      final updatedOriginalList =
          List<RlLevel>.from(state.originalRlLevels ?? [])..add(newRlLevel);
      final updatedFilteredList = List<RlLevel>.from(state.rlLevels ?? [])
        ..add(newRlLevel);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          rlLevels: updatedFilteredList,
          originalRlLevels: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, error: response.message));
    }
  }

  void _onSearchRlLevel(SearchRlLevel event, Emitter<RlLevelState> emit) {
    if (state.originalRlLevels != null) {
      final filteredRlLevels = state.originalRlLevels!.where((rlLevel) {
        final code = rlLevel.level?.toLowerCase() ?? '';
        final query = event.query?.toLowerCase();

        return code.contains(query ?? '');
      }).toList();

      emit(state.copyWith(
        rlLevels: filteredRlLevels,
        message: null,
      ));
    }
  }
}

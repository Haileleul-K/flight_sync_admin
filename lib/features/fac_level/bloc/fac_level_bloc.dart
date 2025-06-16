import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_sync_admin/core/base/api_service.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';
import 'package:logger/logger.dart';

part 'fac_level_event.dart';
part 'fac_level_state.dart';

class FacLevelBloc extends Bloc<FacLevelEvent, FacLevelState> {
  FacLevelBloc() : super(FacLevelInitial()) {
    on<FetchFacLevels>(_onFetchFacLevels);
    on<DeleteFacLevel>(_onDeleteFacLevel);
    on<AddFacLevel>(_onAddFacLevel);
    on<SearchFacLevel>(_onSearchFacLevel);
  }
  ApiService apiService = ApiService();

  void _onFetchFacLevels(
      FetchFacLevels event, Emitter<FacLevelState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.fetchFacLevels();
    if (response.data != null) {
      final facLevels =
          List<FacLevel>.from(response.data.map((e) => FacLevel.fromJson(e)));
      emit(state.copyWith(
          isLoading: false,
          facLevels: facLevels,
          originalFacLevels: facLevels));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onDeleteFacLevel(
      DeleteFacLevel event, Emitter<FacLevelState> emit) async {
    emit(state.copyWith(
      isLoading: true,
    ));
    final response = await apiService.deleteFacLevels(id: event.id);
    if (response.status == 'success') {
      final updatedOriginalList =
          List<FacLevel>.from(state.originalFacLevels ?? [])
            ..removeWhere((element) => element.id == event.id);
      final updatedFilteredList = List<FacLevel>.from(state.facLevels ?? [])
        ..removeWhere((element) => element.id == event.id);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          facLevels: updatedFilteredList,
          originalFacLevels: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onAddFacLevel(AddFacLevel event, Emitter<FacLevelState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response =
        await apiService.addFacLevels(data: event.facLevel.toMap());
    if (response.data != null) {
      final newFacLevel = FacLevel.fromJson(response.data);
      final updatedOriginalList =
          List<FacLevel>.from(state.originalFacLevels ?? [])..add(newFacLevel);
      final updatedFilteredList = List<FacLevel>.from(state.facLevels ?? [])
        ..add(newFacLevel);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          facLevels: updatedFilteredList,
          originalFacLevels: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onSearchFacLevel(SearchFacLevel event, Emitter<FacLevelState> emit) {
    if (state.originalFacLevels != null) {
      final filteredFacLevels = state.originalFacLevels!.where((facLevel) {
        final code = facLevel.level?.toLowerCase() ?? '';
        final query = event.query.toLowerCase();

        return code.contains(query);
      }).toList();

      emit(state.copyWith(
        facLevels: filteredFacLevels,
        message: null,
      ));
    }
  }
}

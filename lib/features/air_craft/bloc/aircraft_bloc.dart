import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_sync_admin/core/base/api_service.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';

part 'aircraft_event.dart';
part 'aircraft_state.dart';

class AircraftBloc extends Bloc<AircraftEvent, AircraftState> {
  AircraftBloc() : super(AircraftInitial()) {
    on<FetchAircraftModels>(_onFetchAircraftModels);
    on<DeleteAircraftModel>(_onDeleteAircraftModel);
    on<AddAircraftModel>(_onAddAircraftModel);
    on<SearchAircraft>(_onSearchAircraft);
  }
  ApiService apiService = ApiService();

  void _onFetchAircraftModels(
    FetchAircraftModels event,
    Emitter<AircraftState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await apiService.fetchAircraftModels();
    if (response.data != null) {
      final aircraftModels = List<AircraftModel>.from(
          response.data.map((e) => AircraftModel.fromJson(e)));
      emit(state.copyWith(
          isLoading: false,
          aircraftModels: aircraftModels,
          originalAircraftModels: aircraftModels));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onDeleteAircraftModel(
      DeleteAircraftModel event, Emitter<AircraftState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.deleteAircraftModel(id: event.id);
    if (response.status == 'success') {
      final updatedOriginalList =
          List<AircraftModel>.from(state.originalAircraftModels ?? [])
            ..removeWhere((element) => element.id == event.id);
      final updatedFilteredList =
          List<AircraftModel>.from(state.aircraftModels ?? [])
            ..removeWhere((element) => element.id == event.id);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          aircraftModels: updatedFilteredList,
          originalAircraftModels: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onAddAircraftModel(
      AddAircraftModel event, Emitter<AircraftState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response =
        await apiService.addAircraftModel(data: event.aircraftModel.toMap());
    if (response.data != null) {
      final newAircraftModel = AircraftModel.fromJson(response.data);
      final updatedOriginalList =
          List<AircraftModel>.from(state.originalAircraftModels ?? [])
            ..add(newAircraftModel);
      final updatedFilteredList =
          List<AircraftModel>.from(state.aircraftModels ?? [])
            ..add(newAircraftModel);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          aircraftModels: updatedFilteredList,
          originalAircraftModels: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onSearchAircraft(SearchAircraft event, Emitter<AircraftState> emit) {
    if (state.originalAircraftModels != null) {
      final filteredAircraft = state.originalAircraftModels!.where((aircraft) {
        final model = aircraft.model?.toLowerCase() ?? '';
        final seats = aircraft.seats?.join(' ').toLowerCase() ?? '';
        final query = event.query.toLowerCase();

        return model.contains(query) || seats.contains(query);
      }).toList();

      emit(state.copyWith(
        aircraftModels: filteredAircraft,
        message: null,
      ));
    }
  }
}

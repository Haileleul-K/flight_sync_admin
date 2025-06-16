import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_sync_admin/core/base/api_service.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';

part 'duty_position_event.dart';
part 'duty_position_state.dart';

class DutyPositionBloc extends Bloc<DutyPositionEvent, DutyPositionState> {
  DutyPositionBloc() : super(DutyPositionInitial()) {
    on<FetchDutyPositions>(_onFetchDutyPositions);
    on<DeleteDutyPosition>(_onDeleteDutyPosition);
    on<AddDutyPosition>(_onAddDutyPosition);
    on<SearchDutyPosition>(_onSearchDutyPosition);
  }
  ApiService apiService = ApiService();

  void _onFetchDutyPositions(
    FetchDutyPositions event,
    Emitter<DutyPositionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await apiService.fetchDutyPositions();
    if (response.data != null) {
      final dutyPositions = List<DutyPosition>.from(
          response.data.map((e) => DutyPosition.fromJson(e)));
      emit(state.copyWith(
          isLoading: false,
          dutyPositions: dutyPositions,
          originalDutyPositions: dutyPositions));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onDeleteDutyPosition(
      DeleteDutyPosition event, Emitter<DutyPositionState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response = await apiService.deleteDutyPositions( event.id);
    if (response.status == 'success') {
      final updatedOriginalList =
          List<DutyPosition>.from(state.originalDutyPositions ?? [])
            ..removeWhere((element) => element.id == event.id);
      final updatedFilteredList =
          List<DutyPosition>.from(state.dutyPositions ?? [])
            ..removeWhere((element) => element.id == event.id);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          dutyPositions: updatedFilteredList,
          originalDutyPositions: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onAddDutyPosition(
      AddDutyPosition event, Emitter<DutyPositionState> emit) async {
    emit(state.copyWith(isLoading: true));
    final response =
        await apiService.addDutyPositions(data:  event.dutyPosition.toMap());
    if (response.data != null) {
      final newDutyPosition = DutyPosition.fromJson(response.data);
      final updatedOriginalList =
          List<DutyPosition>.from(state.originalDutyPositions ?? [])
            ..add(newDutyPosition);
      final updatedFilteredList =
          List<DutyPosition>.from(state.dutyPositions ?? [])
            ..add(newDutyPosition);

      emit(state.copyWith(
          isLoading: false,
          message: response.message,
          dutyPositions: updatedFilteredList,
          originalDutyPositions: updatedOriginalList));
    } else {
      emit(state.copyWith(isLoading: false, message: response.message));
    }
  }

  void _onSearchDutyPosition(
      SearchDutyPosition event, Emitter<DutyPositionState> emit) {
    if (state.originalDutyPositions != null) {
      final filteredDutyPositions =
          state.originalDutyPositions!.where((position) {
        final code = position.code?.toLowerCase() ?? '';
        final label = position.label?.toLowerCase() ?? '';
        final query = event.query.toLowerCase();

        return code.contains(query) || label.contains(query);
      }).toList();

      emit(state.copyWith(
        dutyPositions: filteredDutyPositions,
        message: null,
      ));
    }
  }
}

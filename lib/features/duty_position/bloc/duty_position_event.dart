part of 'duty_position_bloc.dart';

sealed class DutyPositionEvent extends Equatable {
  const DutyPositionEvent();

  @override
  List<Object> get props => [];
}

class FetchDutyPositions extends DutyPositionEvent {}

class AddDutyPosition extends DutyPositionEvent {
  final DutyPosition dutyPosition;

  AddDutyPosition({required this.dutyPosition});

  @override
  List<Object> get props => [dutyPosition];
}

class DeleteDutyPosition extends DutyPositionEvent {
  final int id;

  DeleteDutyPosition({required this.id});

  @override
  List<Object> get props => [id];
}

class SearchDutyPosition extends DutyPositionEvent {
  final String query;

  const SearchDutyPosition(this.query);
}

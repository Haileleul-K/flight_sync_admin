part of 'mission_bloc.dart';

sealed class MissionEvent extends Equatable {
  const MissionEvent();

  @override
  List<Object> get props => [];
}

class SearchMission extends MissionEvent {
  final String query;

  SearchMission(this.query);

  @override
  List<Object> get props => [query];
}

class FetchMissions extends MissionEvent {}

class DeleteMission extends MissionEvent {
  final int id;
  DeleteMission({required this.id});
}

class AddMission extends MissionEvent {
  final Mission mission;
  AddMission({required this.mission});
}

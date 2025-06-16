part of 'rl_level_bloc.dart';

sealed class RlLevelEvent extends Equatable {
  const RlLevelEvent();

  @override
  List<Object> get props => [];
}
class FetchRlLevels extends RlLevelEvent {}
class DeleteRlLevel extends RlLevelEvent {
  final int id;
  DeleteRlLevel({required this.id});
}
class AddRlLevel extends RlLevelEvent {
  final RlLevel rlLevel;
  AddRlLevel({required this.rlLevel});
}

class SearchRlLevel extends RlLevelEvent {
  final String? query;
  SearchRlLevel({required this.query});
}
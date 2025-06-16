part of 'fac_level_bloc.dart';

sealed class FacLevelEvent extends Equatable {
  const FacLevelEvent();

  @override
  List<Object> get props => [];
}

class FetchFacLevels extends FacLevelEvent {}

class DeleteFacLevel extends FacLevelEvent {
  final int id;
  DeleteFacLevel({required this.id});
}

class AddFacLevel extends FacLevelEvent {
  final FacLevel facLevel;
  AddFacLevel({required this.facLevel});
}

class SearchFacLevel extends FacLevelEvent {
  final String query;

  SearchFacLevel(this.query);

  @override
  List<Object> get props => [query];
}

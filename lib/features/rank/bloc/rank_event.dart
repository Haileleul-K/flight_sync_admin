part of 'rank_bloc.dart';

sealed class RankEvent extends Equatable {
  const RankEvent();

  @override
  List<Object> get props => [];
}

class FetchRanks extends RankEvent {}

class DeleteRank extends RankEvent {
  final int id;
  DeleteRank({required this.id});
}

class AddRank extends RankEvent {
  final Rank rank;
  AddRank({required this.rank});
}

class SearchRank extends RankEvent {
  final String query;

  SearchRank(this.query);
}

part of 'rank_bloc.dart';

class RankState extends Equatable {
  RankState(
      {this.ranks,
      this.originalRanks,
      this.isLoading,
      this.message,
      this.error});

  final List<Rank>? ranks;
  final List<Rank>? originalRanks;
  final bool? isLoading;
  final String? message;
  final String? error;

  RankState copyWith({
    List<Rank>? ranks,
    List<Rank>? originalRanks,
    bool? isLoading,
    String? message,
    String? error,
  }) {
    return RankState(
      ranks: ranks ?? this.ranks,
      originalRanks: originalRanks ?? this.originalRanks,
      isLoading: isLoading ?? false,
      message: message,
      error: error,
    );
  }

  @override
  List<Object?> get props => [ranks, originalRanks, isLoading, message, error];
}

final class RankInitial extends RankState {}

part of 'rl_level_bloc.dart';

class RlLevelState extends Equatable {
  RlLevelState(
      {this.rlLevels, this.originalRlLevels, this.isLoading, this.message});
  final List<RlLevel>? rlLevels;
  final List<RlLevel>? originalRlLevels;
  final bool? isLoading;
  final String? message;

  RlLevelState copyWith({
    List<RlLevel>? rlLevels,
    List<RlLevel>? originalRlLevels,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return RlLevelState(
        rlLevels: rlLevels ?? this.rlLevels,
        originalRlLevels: originalRlLevels ?? this.originalRlLevels,
        isLoading: isLoading ?? false,
        message: message);
  }

  @override
  List<Object?> get props => [rlLevels, originalRlLevels, isLoading, message];
}

final class RlLevelInitial extends RlLevelState {}

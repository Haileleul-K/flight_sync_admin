part of 'fac_level_bloc.dart';

class FacLevelState extends Equatable {
  FacLevelState(
      {this.facLevels, this.originalFacLevels, this.isLoading, this.message});

  final List<FacLevel>? facLevels;
  final List<FacLevel>? originalFacLevels;
  final bool? isLoading;
  final String? message;

  FacLevelState copyWith({
    List<FacLevel>? facLevels,
    List<FacLevel>? originalFacLevels,
    bool? isLoading,
    String? message,
  }) {
    return FacLevelState(
        facLevels: facLevels ?? this.facLevels,
        originalFacLevels: originalFacLevels ?? this.originalFacLevels,
        isLoading: isLoading ?? false,
        message: message);
  }

  @override
  List<Object?> get props => [facLevels, originalFacLevels, isLoading, message];
}

final class FacLevelInitial extends FacLevelState {}

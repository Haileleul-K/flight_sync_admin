part of 'mission_bloc.dart';

class MissionState extends Equatable {
  MissionState({
    this.missions,
    this.originalMissions,
    this.isLoading,
    this.message,
  });

  final List<Mission>? missions;
  final List<Mission>? originalMissions;
  final bool? isLoading;
  final String? message;

  MissionState copyWith({
    List<Mission>? missions,
    List<Mission>? originalMissions,
    bool? isLoading,
    String? message,
  }) {
    return MissionState(
      missions: missions ?? this.missions,
      originalMissions: originalMissions ?? this.originalMissions,
      isLoading: isLoading ?? false,
      message: message,
    );
  }

  @override
  List<Object?> get props => [missions, originalMissions, isLoading, message];
}

// ignore: must_be_immutable
final class MissionInitial extends MissionState {}

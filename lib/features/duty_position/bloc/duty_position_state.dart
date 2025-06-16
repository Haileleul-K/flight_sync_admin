part of 'duty_position_bloc.dart';

class DutyPositionState extends Equatable {
  DutyPositionState({
    this.dutyPositions,
    this.originalDutyPositions,
    this.isLoading,
    this.message,
  });

  final List<DutyPosition>? dutyPositions;
  final List<DutyPosition>? originalDutyPositions;
  final bool? isLoading;
  final String? message;

  DutyPositionState copyWith({
    List<DutyPosition>? dutyPositions,
    List<DutyPosition>? originalDutyPositions,
    bool? isLoading,
    String? message,
  }) {
    return DutyPositionState(
      dutyPositions: dutyPositions ?? this.dutyPositions,
      originalDutyPositions:
          originalDutyPositions ?? this.originalDutyPositions,
      isLoading: isLoading ?? false,
      message: message,
    );
  }

  @override
  List<Object?> get props =>
      [dutyPositions, originalDutyPositions, isLoading, message];
}

// ignore: must_be_immutable
final class DutyPositionInitial extends DutyPositionState {}

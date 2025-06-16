part of 'aircraft_bloc.dart';

class AircraftState extends Equatable {
  AircraftState({
    this.aircraftModels,
    this.originalAircraftModels,
    this.isLoading,
    this.message,
  });

  final List<AircraftModel>? aircraftModels;
  final List<AircraftModel>? originalAircraftModels;
  final bool? isLoading;
  final String? message;

  AircraftState copyWith({
    List<AircraftModel>? aircraftModels,
    List<AircraftModel>? originalAircraftModels,
    bool? isLoading,
    String? message,
  }) {
    return AircraftState(
      aircraftModels: aircraftModels ?? this.aircraftModels,
      originalAircraftModels:
          originalAircraftModels ?? this.originalAircraftModels,
      isLoading: isLoading ?? false,
      message: message,
    );
  }

  @override
  List<Object?> get props =>
      [aircraftModels, originalAircraftModels, isLoading, message];
}

// ignore: must_be_immutable
final class AircraftInitial extends AircraftState {}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int totalPilots;
  final int totalFlights;
  final double totalAircraftHours;
  final double totalSimulatorHours;
  final List<MonthlyTrend> monthlyTrends;
  final List<AircraftUsage> aircraftUsage;

  const DashboardLoaded({
    required this.totalPilots,
    required this.totalFlights,
    required this.totalAircraftHours,
    required this.totalSimulatorHours,
    required this.monthlyTrends,
    required this.aircraftUsage,
  });

  @override
  List<Object?> get props => [
    totalPilots,
    totalFlights,
    totalAircraftHours,
    totalSimulatorHours,
    monthlyTrends,
    aircraftUsage,
  ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class MonthlyTrend {
  final DateTime date;
  final int commercial;
  final int cargo;
  final int training;

  MonthlyTrend({
    required this.date,
    required this.commercial,
    required this.cargo,
    required this.training,
  });
}

class AircraftUsage {
  final String model;
  final double hours;

  AircraftUsage({required this.model, required this.hours});


  factory AircraftUsage.fromJson(Map<String, dynamic> map) {
    return AircraftUsage(
      model: map['model'],
      hours: map['hours'],
    );
  }


}

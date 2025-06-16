part of 'aircraft_bloc.dart';

 class AircraftEvent extends Equatable {
  const AircraftEvent();

  @override
  List<Object> get props => [];
}

class FetchAircraftModels extends AircraftEvent {}
class DeleteAircraftModel extends AircraftEvent {
  final int id;
  DeleteAircraftModel({required this.id});
}

class AddAircraftModel extends AircraftEvent {
  final AircraftModel aircraftModel;
  AddAircraftModel({required this.aircraftModel});
}

class SearchAircraft extends AircraftEvent {
  final String query;

  SearchAircraft(this.query);
}

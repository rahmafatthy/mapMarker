import 'package:latlong2/latlong.dart';

abstract class MapState {}

class MapInitialState extends MapState {}

class MapLoadingState extends MapState {}

class MapSuccessState extends MapState {
  final LatLng currentLocation;
  final List<LatLng> markers;

  MapSuccessState({required this.currentLocation, required this.markers});
}

class MapFailureState extends MapState {
  final String error;
  MapFailureState(this.error);
}

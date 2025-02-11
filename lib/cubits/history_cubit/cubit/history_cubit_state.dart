import 'package:latlong2/latlong.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<LatLng> markers;
  HistoryLoaded(this.markers);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}

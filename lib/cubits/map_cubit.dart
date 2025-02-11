import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_meters_marker/cubits/map_state.dart';
import 'package:map_meters_marker/models/DataBase.dart';
import 'package:map_meters_marker/models/location_permissions.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitialState()) {
    initializeLocation();
  }

  final DBHelper dataBase = DBHelper();
  final MapController mapController = MapController();
  final Distance distance = Distance();

  LatLng? currentLocation;
  List<LatLng> markers = [];
  LatLng? lastMarker;
  double distanceInMeters = 0;
  StreamSubscription<Position>? positionStream;
  int? currentUserId;

  void setCurrentUser(int userId) {
    currentUserId = userId;
  }

  Future<void> initializeLocation() async {
    try {
      emit(MapLoadingState());
      await _setupPositionStream();
      if (currentLocation == null) {
        Position position = await LocationPermissions.getPermission();
        currentLocation = LatLng(position.latitude, position.longitude);
      }
      emit(MapSuccessState(
        currentLocation: currentLocation!,
        markers: markers,
      ));
    } catch (e) {
      log("Error initializing location: $e");
      emit(MapFailureState(e.toString()));
    }
  }

  Future<void> addMarker(LatLng location, int userId) async {
    try {
      markers = [...markers, location];
      lastMarker = location;

      await DBHelper.addLocation(location.latitude, location.longitude);

      emit(MapSuccessState(
        currentLocation: currentLocation!,
        markers: markers,
      ));
    } catch (e) {
      log("Error adding marker: $e");
      emit(MapFailureState("Failed to save marker: ${e.toString()}"));
    }
  }

  Future<void> _setupPositionStream() async {
    final initialPosition = await LocationPermissions.getPermission();
    _updateLocation(
        LatLng(initialPosition.latitude, initialPosition.longitude));

    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(distanceFilter: 100),
    ).listen((position) {
      _updateLocation(LatLng(position.latitude, position.longitude));
    });
  }

  void _updateLocation(LatLng newLocation) async {
    try {
      currentLocation = newLocation;

      if (currentUserId == null) {
        log("No user logged in");
        return;
      }

      if (lastMarker == null) {
        addMarker(newLocation, currentUserId!);
        return;
      }

      distanceInMeters = distance.as(
        LengthUnit.Meter,
        lastMarker!,
        newLocation,
      );

      if (distanceInMeters >= 100) {
        addMarker(newLocation, currentUserId!);
      }
    } catch (error) {
      emit(MapFailureState(error.toString()));
    }
  }

  /* Future<void> loadMarkersForUser(int userId) async {
    try {
      markers = await DBHelper.getLocations(userId);
      emit(MapSuccessState(
        currentLocation: currentLocation!,
        markers: markers,
      ));
    } catch (e) {
      log("Error loading markers: $e");
      emit(MapFailureState("Failed to load markers"));
    }
  }
*/
  /*@override
  Future<void> close() {
    positionStream?.cancel();
    return super.close();
  }*/
}

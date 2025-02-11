import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_meters_marker/cubits/map_cubit.dart';
import 'package:map_meters_marker/cubits/map_state.dart';
import 'package:map_meters_marker/view/history_view.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});
  static const route = "/mapView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.history_outlined),
          color: Colors.white,
          iconSize: 20,
          onPressed: () {
            Navigator.pushReplacementNamed(context, HistoryView.route);
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: BlocConsumer<MapCubit, MapState>(
        listener: (context, state) {
          if (state is MapFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          if (state is MapInitialState || state is MapLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapFailureState) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is MapSuccessState) {
            final mapCubit = context.read<MapCubit>();
            return FlutterMap(
              mapController: mapCubit.mapController,
              options: MapOptions(
                initialCenter: state.currentLocation,
                initialZoom: 13,
                onMapReady: () => mapCubit.mapController.move(
                  state.currentLocation,
                  13,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: state.markers
                      .map(
                        (location) => Marker(
                          point: location,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 30,
                          ),
                          width: 80,
                          height: 80,
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }
}

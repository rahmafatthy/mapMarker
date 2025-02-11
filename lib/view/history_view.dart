import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_meters_marker/cubits/history_cubit/cubit/history_cubit_cubit.dart';
import 'package:map_meters_marker/cubits/history_cubit/cubit/history_cubit_state.dart';

class HistoryView extends StatelessWidget {
  static const String route = '/history';

  HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HistoryCubit>().loadMarkers();
    return Scaffold(
      appBar: AppBar(title: const Text('Marker History')),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading || state is HistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            final markers = state.markers;
            return FlutterMap(
              options: MapOptions(
                initialCenter: markers[state.markers.length - 1],
                initialZoom: 8,
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
          } else if (state is HistoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

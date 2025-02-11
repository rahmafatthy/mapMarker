import 'package:bloc/bloc.dart';
import 'package:map_meters_marker/cubits/history_cubit/cubit/history_cubit_state.dart';
import 'package:map_meters_marker/models/DataBase.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());
  late int userID;

  Future<void> loadMarkers() async {
    try {
      emit(HistoryLoading());
      final markers = await DBHelper.getLocations();
      emit(HistoryLoaded(markers));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}

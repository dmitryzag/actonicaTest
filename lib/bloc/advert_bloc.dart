import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actonic_adboard/bloc/advert_event.dart';
import 'package:actonic_adboard/bloc/advert_state.dart';

import 'package:actonic_adboard/models/database.dart';

class AdvertBloc extends Bloc<AdvertEvent, AdvertState> {
  AdvertBloc() : super(Loading()) {
    on<LoadData>(loadData);
    on<ToggleFavorite>(toggleFavorite);
    on<SaveFavoriteData>(saveFavoriteData);
    on<InitPreferences>(initPreferences);
  }
  SharedPreferences? _preferences;
  List<int> _favoriteData = [];
  List<Map<String, dynamic>> _favoriteAdverts = [];
  List<Map<String, dynamic>> _allData = [];

  void loadData(LoadData event, Emitter<AdvertState> emit) async {
    try {
      final data = await SQLHelper.getAllData();
      final List<Map<String, dynamic>> favoriteAdverts = [];
      for (final item in data) {
        final adId = item['id'];
        if (_favoriteData.contains(adId)) {
          favoriteAdverts.add(item);
        }
      }
      _favoriteAdverts = favoriteAdverts;
      _allData = data;
      emit(Loaded(_allData, _favoriteAdverts, _favoriteData));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  void toggleFavorite(ToggleFavorite event, Emitter<AdvertState> emit) {
    final adId = event.adId;
    final isFavorite = event.isFavorite;
    if (isFavorite) {
      _favoriteData.add(adId);
    } else {
      _favoriteData.remove(adId);
    }
    emit(FavoriteChanged(adId, isFavorite));
    emit(Loaded(_allData, _favoriteAdverts, _favoriteData));
    saveFavoriteData(SaveFavoriteData(_favoriteData), emit);
  }

  void saveFavoriteData(
      SaveFavoriteData event, Emitter<AdvertState> emit) async {
    final favoriteDataString = event.favoriteData.join(',');
    await _preferences!.setString('favoriteData', favoriteDataString);
  }

  void initPreferences(InitPreferences event, Emitter<AdvertState> emit) async {
    _preferences = await SharedPreferences.getInstance();
    _loadFavoriteData();
  }

  void _loadFavoriteData() {
    final favoriteDataString = _preferences!.getString('favoriteData');
    if (favoriteDataString != null && favoriteDataString.isNotEmpty) {
      _favoriteData = favoriteDataString.split(',').map(int.parse).toList();
    }
  }
}

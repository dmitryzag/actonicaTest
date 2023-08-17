import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actonic_adboard/bloc/advert_event.dart';
import 'package:actonic_adboard/bloc/advert_state.dart';

import 'package:actonic_adboard/models/advert.dart';

class AdvertBloc extends Bloc<AdvertEvent, AdvertState> {
  AdvertBloc() : super(Loading()) {
    on<LoadData>(loadData);
    on<ToggleFavorite>(toggleFavorite);
    on<SaveFavoriteData>(saveFavoriteData);
    on<InitPreferences>(initPreferences);
  }
  SharedPreferences? _preferences;
  List<int> _favoriteIds = [];
  List<Advert> _favoriteAdverts = [];
  List<Advert> _allAdverts = [];

  void loadData(LoadData event, Emitter<AdvertState> emit) async {
    try {
      final data = await Advert.getAll();
      final List<Advert> favoriteAdverts =
          data.where((item) => _favoriteIds.contains(item.id)).toList();
      _favoriteAdverts = favoriteAdverts;
      _allAdverts = data;
      emit(Loaded(_allAdverts, _favoriteAdverts, _favoriteIds));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  void toggleFavorite(ToggleFavorite event, Emitter<AdvertState> emit) {
    final adId = event.adId;
    final isFavorite = event.isFavorite;
    if (isFavorite) {
      _favoriteIds.add(adId);
      final advert = _allAdverts.firstWhere((item) => item.id == adId);
      _favoriteAdverts.add(advert);
    } else {
      _favoriteIds.remove(adId);
      final advert = _favoriteAdverts.firstWhere((item) => item.id == adId);
      _favoriteAdverts.remove(advert);
    }
    emit(FavoriteChanged(adId, isFavorite));
    emit(Loaded(_allAdverts, _favoriteAdverts, _favoriteIds));
    saveFavoriteData(SaveFavoriteData(_favoriteIds), emit);
  }

  void saveFavoriteData(
      SaveFavoriteData event, Emitter<AdvertState> emit) async {
    final favoriteIdsString = event.favoriteData.join(',');
    await _preferences!.setString('favoriteIds', favoriteIdsString);
  }

  void initPreferences(InitPreferences event, Emitter<AdvertState> emit) async {
    _preferences = await SharedPreferences.getInstance();
    _loadFavoriteIds();
  }

  void _loadFavoriteIds() {
    final favoriteIdsString = _preferences!.getString('favoriteIds');
    if (favoriteIdsString != null && favoriteIdsString.isNotEmpty) {
      _favoriteIds = favoriteIdsString.split(',').map(int.parse).toList();
    }
  }
}

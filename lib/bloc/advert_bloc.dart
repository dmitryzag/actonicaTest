import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:actonic_adboard/bloc/advert_event.dart';
import 'package:actonic_adboard/bloc/advert_state.dart';

import 'package:actonic_adboard/models/advert.dart';

// ignore: constant_identifier_names
const String FAVORITE_IDS_KEY = 'favoriteIds';

class AdvertBloc extends Bloc<AdvertEvent, AdvertState> {
  AdvertBloc() : super(Loading()) {
    on<LoadSingleData>(loadSingleData);
    on<LoadData>(loadData);
    on<ToggleFavorite>(toggleFavorite);
    on<SaveFavoriteData>(saveFavoriteData);
    on<InitPreferences>(initPreferences);
    on<ToggleCurrentAdvert>(toggleCurrentAdvert);
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

  void updateFavoriteLists(int adId, bool isFavorite) {
    if (isFavorite) {
      _favoriteIds.add(adId);
      final advert = _allAdverts.firstWhere((item) => item.id == adId);
      _favoriteAdverts.add(advert);
    } else {
      _favoriteIds.remove(adId);
      final advert = _favoriteAdverts.firstWhere((item) => item.id == adId);
      _favoriteAdverts.remove(advert);
    }
  }

  void toggleFavorite(ToggleFavorite event, Emitter<AdvertState> emit) {
    final adId = event.adId;
    final isFavorite = event.isFavorite;
    updateFavoriteLists(adId, isFavorite);
    emit(FavoriteChanged(adId, isFavorite));
    emit(Loaded(_allAdverts, _favoriteAdverts, _favoriteIds));
    saveFavoriteData(SaveFavoriteData(_favoriteIds), emit);
  }

  void toggleCurrentAdvert(
      ToggleCurrentAdvert event, Emitter<AdvertState> emit) {
    final item = event.item;
    final isFavorite = event.isFavorite;
    updateFavoriteLists(item.id!, isFavorite);
    emit(SingleLoaded(item, _favoriteIds.contains(item.id)));
    saveFavoriteData(SaveFavoriteData(_favoriteIds), emit);
  }

  void loadSingleData(LoadSingleData event, Emitter<AdvertState> emit) async {
    try {
      final Advert? singleData = await Advert.getSingle(event.adId);
      emit(SingleLoaded(singleData!, _favoriteIds.contains(singleData.id)));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  void saveFavoriteData(
      SaveFavoriteData event, Emitter<AdvertState> emit) async {
    final favoriteIdsString = event.favoriteData.join(',');
    await _preferences!.setString(FAVORITE_IDS_KEY, favoriteIdsString);
  }

  void initPreferences(InitPreferences event, Emitter<AdvertState> emit) async {
    _preferences = await SharedPreferences.getInstance();
    _loadFavoriteIds();
  }

  void _loadFavoriteIds() {
    final favoriteIdsString = _preferences!.getString(FAVORITE_IDS_KEY);
    _favoriteIds = favoriteIdsString?.split(',').map(int.parse).toList() ?? [];
  }
}

import 'package:rxdart/rxdart.dart';

import 'package:flutter/material.dart';
import 'package:actonic_adboard/models/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:actonic_adboard/models/dummy_data.dart';

class AdvertsBloc {
  final _adData = BehaviorSubject<List<Map<String, dynamic>>?>.seeded(null);
  final _favoriteData = BehaviorSubject<List<int>>.seeded([]);
  final _isLoading = BehaviorSubject<bool>.seeded(true);

  Stream<List<Map<String, dynamic>>?> get adData => _adData.stream;
  Stream<List<int>> get favoriteData => _favoriteData.stream;
  Stream<bool> get isLoading => _isLoading.stream;

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  SharedPreferences? _preferences;

  AdvertsBloc() {
    _createDummyData();
    _initPreferences();
    _refreshData();
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _loadFavoriteData();
  }

  void _createDummyData() {
    createDummyData();
  }

  void _loadFavoriteData() {
    final favoriteDataString = _preferences!.getString('favoriteData');
    if (favoriteDataString != null) {
      _favoriteData.add(favoriteDataString.split(',').map(int.parse).toList());
    }
  }

  Future<void> _saveFavoriteData(List<int> favoriteData) async {
    final favoriteDataString = favoriteData.join(',');
    await _preferences!.setString('favoriteData', favoriteDataString);
  }

  void toggleFavorite(List<int> favoriteData, int adId, bool isFavorite) {
    if (isFavorite) {
      favoriteData.add(adId);
    } else {
      favoriteData.remove(adId);
    }
    _favoriteData.add(favoriteData);
    _saveFavoriteData(favoriteData);
  }

  Future<void> _refreshData() async {
    final data = await SQLHelper.getAllData();
    _adData.add(data);
    _isLoading.add(false);
  }

  Future<void> refreshData() async {
    _isLoading.add(true);
    await _refreshData();
  }

  void dispose() {
    _adData.close();
    _favoriteData.close();
    _isLoading.close();
  }
}

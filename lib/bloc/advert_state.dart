import '../models/advert.dart';

abstract class AdvertState {
  const AdvertState();
}

class Loading extends AdvertState {}

class Loaded extends AdvertState {
  final List<Advert> allAdverts;
  final List<Advert> favoriteAdverts;
  final List<int> favoriteIds;

  const Loaded(this.allAdverts, this.favoriteAdverts, this.favoriteIds);
}

class Error extends AdvertState {
  final String message;

  const Error(this.message);
}

class FavoriteChanged extends AdvertState {
  final int adId;
  final bool isFavorite;

  const FavoriteChanged(this.adId, this.isFavorite);
}

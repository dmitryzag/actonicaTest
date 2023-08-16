abstract class AdvertState {
  const AdvertState();
}

class Loading extends AdvertState {}

class Loaded extends AdvertState {
  final List<Map<String, dynamic>> allData;
  final List<Map<String, dynamic>> favoriteAdverts;
  final List<int> favoriteData;

  const Loaded(this.allData, this.favoriteAdverts, this.favoriteData);
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

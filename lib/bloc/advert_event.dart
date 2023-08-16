abstract class AdvertEvent {
  const AdvertEvent();
}

class LoadData extends AdvertEvent {}

class ToggleFavorite extends AdvertEvent {
  final int adId;
  final bool isFavorite;

  const ToggleFavorite(this.adId, this.isFavorite);
}

class SaveFavoriteData extends AdvertEvent {
  final List<int> favoriteData;

  const SaveFavoriteData(this.favoriteData);
}

class InitPreferences extends AdvertEvent {}

import '../models/advert.dart';

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

class LoadSingleData extends AdvertEvent {
  final int adId;

  LoadSingleData(this.adId);
}

class ToggleCurrentAdvert extends AdvertEvent {
  final Advert item;
  final bool isFavorite;

  ToggleCurrentAdvert(this.item, this.isFavorite);
}

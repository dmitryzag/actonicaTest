import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvertFavoriteIcons extends StatefulWidget {
  AdvertFavoriteIcons(
      {required this.preferences,
      required this.favoriteData,
      required this.adId,
      super.key});
  SharedPreferences? preferences;
  List<int> favoriteData;
  int adId;
  @override
  State<AdvertFavoriteIcons> createState() => _AdvertFavoriteIconsState();
}

class _AdvertFavoriteIconsState extends State<AdvertFavoriteIcons> {
  @override
  Widget build(BuildContext context) {
    Future<void> _saveFavoriteData() async {
      final favoriteDataString = widget.favoriteData.join(',');
      await widget.preferences!.setString('favoriteData', favoriteDataString);
    }

    final isFavorite = widget.favoriteData.contains(widget.adId);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (isFavorite) {
                widget.favoriteData.remove(widget.adId);
              } else {
                widget.favoriteData.add(widget.adId);
              }
            });
            _saveFavoriteData();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
              size: 25,
              color: isFavorite ? Colors.red : null,
            ),
          ),
        ),
      ],
    );
  }
}

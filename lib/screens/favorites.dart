import 'dart:io';

import 'package:flutter/material.dart';
import 'package:actonic_adboard/screens/advert_details.dart';
import 'package:actonic_adboard/models/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteAdverts extends StatefulWidget {
  const FavoriteAdverts({Key? key}) : super(key: key);

  @override
  State<FavoriteAdverts> createState() => _FavoriteAdvertsState();
}

class _FavoriteAdvertsState extends State<FavoriteAdverts> {
  List<int> favoriteData = [];
  List<Map<String, dynamic>> _favoriteAdverts = [];
  bool _isLoading = true;

  late SharedPreferences _preferences; // Changed from nullable

  @override
  void initState() {
    super.initState();
    _initPreferences();
    _loadFavoriteAdverts();
  }

  Future<void> _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    _loadFavoriteData();
  }

  void _loadFavoriteData() {
    final favoriteDataString = _preferences.getString('favoriteData');
    if (favoriteDataString != null) {
      setState(() {
        favoriteData = favoriteDataString.split(',').map(int.parse).toList();
      });
    }
  }

  Future<void> _saveFavoriteData() async {
    final favoriteDataString = favoriteData.join(',');
    await _preferences.setString('favoriteData', favoriteDataString);
  }

  void _loadFavoriteAdverts() async {
    final data = await SQLHelper.getAllData();
    final List<Map<String, dynamic>> favoriteAdverts = [];
    for (final item in data) {
      final adId = item['id'];
      if (favoriteData.contains(adId)) {
        favoriteAdverts.add(item);
      }
    }
    setState(() {
      _favoriteAdverts = favoriteAdverts;
      _isLoading = false;
    });
  }

  void _toggleFavorite(int adId, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        favoriteData.add(adId);
      } else {
        favoriteData.remove(adId);
      }
    });
    _saveFavoriteData();
    _loadFavoriteAdverts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранные объявления'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _favoriteAdverts.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                final item = _favoriteAdverts[index];
                final adId = item['id'];
                final isFavorite = favoriteData.contains(adId);

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdDetailsScreen(
                          favoriteData: favoriteData,
                          isFavorite: isFavorite,
                          adId: adId,
                          onToggleFavorite: (isFavorite) {
                            _toggleFavorite(adId, isFavorite);
                          },
                        ),
                      ),
                    );
                    _loadFavoriteAdverts();
                  },
                  child: buildAdvertContainer(context, item, isFavorite),
                );
              },
            ),
    );
  }

  Widget buildAdvertContainer(
      BuildContext context, Map<String, dynamic> item, bool isFavorite) {
    return Container(
      height: 136,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: buildAdvertInfo(item, context),
          ),
          buildAdvertImage(item['image']),
        ],
      ),
    );
  }

  Widget buildAdvertInfo(Map<String, dynamic> item, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          "${item['author_name']} · ${item['createdAt']}",
          style:
              Theme.of(context).textTheme.bodySmall, // Changed from bodyMedium
        ),
        const SizedBox(height: 8),
        Text(
          '${item['price'] is Null ? 'бесплатно' : item['price'].toString() + ' руб.'}',
          style:
              Theme.of(context).textTheme.bodyMedium, // Changed from bodyLarge
        ),
        const SizedBox(height: 8),
        buildFavoriteIcons(item['id']),
      ],
    );
  }

  Widget buildFavoriteIcons(int adId) {
    final isFavorite = favoriteData.contains(adId);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (isFavorite) {
                favoriteData.remove(adId);
              } else {
                favoriteData.add(adId);
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

  Widget buildAdvertImage(String? imageUrl) {
    if (imageUrl == null) {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
      );
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(File(imageUrl)),
        ),
      ),
    );
  }
}

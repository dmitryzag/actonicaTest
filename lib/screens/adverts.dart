import 'dart:io';

import 'package:intl/intl.dart';
import 'package:actonic_adboard/screens/advert_details.dart';
import 'package:flutter/material.dart';

import '../bloc/advert_bloc.dart';

class Adverts extends StatelessWidget {
  final AdvertsBloc bloc = AdvertsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Доска объявлений'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>?>(
        stream: bloc.adData,
        builder: (context, snapshot) {
          final List<Map<String, dynamic>> _allData = snapshot.data ?? [];
          final List<int> favoriteData = bloc.favoriteData as List<int>;

          return RefreshIndicator(
            key: bloc.refreshIndicatorKey,
            onRefresh: bloc.refreshData,
            child: ListView.separated(
              itemCount: _allData.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                final item = _allData[index];
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
                            bloc.toggleFavorite(favoriteData, adId, isFavorite);
                          },
                        ),
                      ),
                    );
                  },
                  child: buildAdvertContainer(context, item, isFavorite),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildAdvertContainer(
      BuildContext context, Map<String, dynamic> item, bool isFavorite) {
    final dateTime = DateTime.parse(item['createdAt']);
    final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

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
    final dateTime = DateTime.parse(item['createdAt']);
    final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

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
          "${item['author_name']} · $formattedDate",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '${item['price'] is Null ? 'бесплатно' : item['price'].toString() + ' руб.'}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 8),
        StreamBuilder<List<int>>(
            stream: bloc.favoriteData,
            builder: (context, snapshot) {
              final List<int> favoriteData = snapshot.data ?? [];
              return buildFavoriteIcons(item['id'], favoriteData);
            }),
      ],
    );
  }

  Widget buildFavoriteIcons(int adId, List<int> favoriteData) {
    final isFavorite = favoriteData.contains(adId);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            bloc.toggleFavorite(favoriteData, adId, !isFavorite);
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

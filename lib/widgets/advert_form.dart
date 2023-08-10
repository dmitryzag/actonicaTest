import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import '../screens/advert_details.dart';

class AdvertForm extends StatelessWidget {
  const AdvertForm({required this.refreshIndicatorKey, required this.refreshData, required this.allData, required this.favoriteData, required this.toggleFavorite, super.key,})



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Доска объявлений'),
      ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: refreshData,
        child: ListView.separated(
          itemCount: allData.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            final item = allData[index];
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
                        toggleFavorite(adId, isFavorite);
                      },
                    ),
                  ),
                );
              },
              child: buildAdvertContainer(context, item, isFavorite),
            );
          },
        ),
      ),
    );
  }
  }
}
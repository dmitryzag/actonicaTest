import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../bloc/advert_bloc.dart';
import '../bloc/advert_event.dart';
import '../bloc/advert_state.dart';
import 'advert_details.dart';

class AdvertScreen extends StatefulWidget {
  final bool isFavorite;
  const AdvertScreen({this.isFavorite = false, super.key});

  @override
  State<AdvertScreen> createState() => _AdvertScreenState();
}

class _AdvertScreenState extends State<AdvertScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdvertBloc>().add(LoadData());
    context.read<AdvertBloc>().add(InitPreferences());
  }

  @override
  Widget build(BuildContext context) {
    final advertBloc = Provider.of<AdvertBloc>(context);
    advertBloc.add(LoadData());
    return Scaffold(
      appBar: AppBar(
        title: widget.isFavorite
            ? Text('Избранные объявления')
            : Text('Все объявления'),
      ),
      body: BlocBuilder<AdvertBloc, AdvertState>(builder: (context, state) {
        if (state is Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is Loaded) {
          List<Map<String, dynamic>> filteredData = [];
          if (widget.isFavorite) {
            filteredData = state.allData
                .where((item) => state.favoriteData.contains(item['id']))
                .toList();
          } else {
            filteredData = state.allData;
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
                  image: imageUrl == ''
                      ? Image.asset('assets/images/nophoto.jpg').image
                      : FileImage(File(imageUrl)),
                ),
              ),
            );
          }

          Widget buildFavoriteIcons(int adId) {
            final isFavorite = state.favoriteData.contains(adId);

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    context
                        .read<AdvertBloc>()
                        .add(ToggleFavorite(adId, !isFavorite));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      size: 25,
                      color: isFavorite ? Colors.red : null,
                    ),
                  ),
                ),
              ],
            );
          }

          Widget buildAdvertInfo(
              Map<String, dynamic> item, BuildContext context) {
            final dateTime = DateTime.parse(item['createdAt']);
            final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
            var price =
                item['price'] == null ? 'бесплатно' : '${item['price']} руб.';
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
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                buildFavoriteIcons(item['id']),
              ],
            );
          }

          Widget buildAdvertContainer(BuildContext context,
              Map<String, dynamic> item, bool isFavorite) {
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

          return ListView.separated(
            itemCount: filteredData.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final item = filteredData[index];

              final adId = item['id'];
              final isFavorite = state.favoriteData.contains(adId);

              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdvertDetails(
                        isFavorite: isFavorite,
                        adId: adId,
                        onToggleFavorite: (isFavorite) {
                          context
                              .read<AdvertBloc>()
                              .add(ToggleFavorite(adId, isFavorite));
                        },
                      ),
                    ),
                  );
                },
                child: buildAdvertContainer(context, item, isFavorite),
              );
            },
          );
        } else if (state is Error) {
          return Center(child: Text(state.message));
        } else {
          return Container();
        }
      }),
    );
  }
}

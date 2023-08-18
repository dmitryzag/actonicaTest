import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

class FavoriteChanged extends AdvertState {
  final int adId;
  final bool isFavorite;

  const FavoriteChanged(this.adId, this.isFavorite);
}

class SingleLoaded extends AdvertState {
  final Advert item;
  final bool isFavorite;

  updateItem() async {}

  makingPhoneCall(String phone) async {
    var url = Uri.parse("tel:${phone.toString()}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Image imageControl() {
    if (item.image != null && item.image != '') {
      return Image.file(File(item.image!));
    } else {
      return Image.asset('assets/images/nophoto.jpg');
    }
  }

  const SingleLoaded(this.item, this.isFavorite);
}

class SingleLoading extends AdvertState {}

class Error extends AdvertState {
  final String message;

  const Error(this.message);
}

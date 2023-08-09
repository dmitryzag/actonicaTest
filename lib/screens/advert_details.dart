import 'package:actonic_adboard/models/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../main.dart';
import 'advert_maker.dart';

class AdDetailsScreen extends StatefulWidget {
  final int adId;
  final bool isFavorite;
  List<int> favoriteData;
  final Function(bool isFavorite) onToggleFavorite;

  AdDetailsScreen({
    required this.favoriteData,
    required this.isFavorite,
    required this.adId,
    required this.onToggleFavorite,
  });

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  late List<Map<String, dynamic>> _adData;
  bool _isLoading = true;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadAdData();
    _isFavorite = widget.isFavorite;
  }

  _makingPhoneCall(String phone) async {
    var url = Uri.parse("tel:${phone.toString()}");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _loadAdData() async {
    _adData = await SQLHelper.getSingleData(widget.adId);

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshAdData() async {
    setState(() {
      _isLoading = true;
    });

    _loadAdData();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    widget.onToggleFavorite(_isFavorite);
  }

  void _deleteAd() async {
    await SQLHelper.deleteData(widget.adId);
    Navigator.pop(context, true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали объявления'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DataForm(_adData.first['id'])),
              );

              if (result == true) {
                _refreshAdData();
              }
            },
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteAd,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAdData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _adData.first['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Опубликовано: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_adData.first["createdAt"]))}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (_adData.first['image'] != null &&
                          _adData.first['image'] != '')
                        Image.file(File(_adData.first['image'])),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Описание:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(_adData.first['description']),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Категория:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(_adData.first['category']),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Автор:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text('Имя: ${_adData.first['author_name']}'),
                      const SizedBox(height: 8.0),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Цена:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                          '${_adData.first['price'] is Null ? 'бесплатно' : _adData.first['price'].toString() + ' руб.'}'),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Позвонить по телефону:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: () {
                            _makingPhoneCall(_adData.first['author_phone']);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

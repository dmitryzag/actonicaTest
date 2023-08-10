import 'package:flutter/material.dart';

class AdvertContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

import 'package:actonic_adboard/models/advert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/advert_bloc.dart';
import '../bloc/advert_event.dart';
import '../bloc/advert_state.dart';
import '../main.dart';
import 'advert_maker.dart';

class AdvertDetails extends StatefulWidget {
  final int adId;
  final bool isFavorite;
  final Function(bool isFavorite) onToggleFavorite;

  const AdvertDetails({
    super.key,
    required this.isFavorite,
    required this.adId,
    required this.onToggleFavorite,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AdvertDetailsState createState() => _AdvertDetailsState();
}

class _AdvertDetailsState extends State<AdvertDetails> {
  @override
  void initState() {
    super.initState();
    context.read<AdvertBloc>().add(LoadSingleData(widget.adId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertBloc, AdvertState>(
      builder: (context, state) {
        if (state is SingleLoaded) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
              ),
              title: const Text('Детали объявления'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AdvertMaker(adID: state.item.id)),
                    );
                    if (result == true) {
                      context
                          .read<AdvertBloc>()
                          .add(LoadSingleData(widget.adId));
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    state.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  onPressed: () {
                    context.read<AdvertBloc>().add(
                        ToggleCurrentAdvert(state.item, !state.isFavorite));
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      Advert.delete(state.item.id!);
                      Navigator.pop(context, true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    }),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.item.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Опубликовано: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(state.item.createdAt.toIso8601String()))}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    state.imageControl(),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Описание:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(state.item.description!),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Категория:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(state.item.category),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Автор:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Имя: ${state.item.authorName}'),
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
                    Text(state.item.price == null
                        ? 'бесплатно'
                        : '${state.item.price} руб.'),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Позвонить по телефону:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                        onTap: () => state
                            .makingPhoneCall("+7${state.item.authorPhone}"),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              color: Color.fromARGB(255, 19, 102, 170),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5)),
                            Text(
                              "+7${state.item.authorPhone}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

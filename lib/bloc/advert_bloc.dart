import 'package:flutter_bloc/flutter_bloc.dart';

part 'advert_event.dart';
part 'advert_state.dart';

class AdvertBloc extends Bloc<AdvertEvent, AdvertState> {
  AdvertBloc() : super(AdvertInitial()) {
    on<AdvertAllData>((event, emit) {
      print('Что-то загрузилось');
    });
  }
}

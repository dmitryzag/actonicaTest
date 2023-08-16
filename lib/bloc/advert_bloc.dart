import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'advert_event.dart';
part 'advert_state.dart';

class AdvertBloc extends Bloc<AdvertEvent, AdvertState> {
  AdvertBloc() : super(AdvertInitial()) {
    on<AdvertEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

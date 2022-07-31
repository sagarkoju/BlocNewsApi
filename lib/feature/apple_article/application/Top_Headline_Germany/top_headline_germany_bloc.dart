import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_headline_germany_event.dart';
part 'top_headline_germany_state.dart';
part 'top_headline_germany_bloc.freezed.dart';

class TopHeadlineGermanyBloc extends Bloc<TopHeadlineGermanyEvent, TopHeadlineGermanyState> {
  TopHeadlineGermanyBloc() : super(_Initial()) {
    on<TopHeadlineGermanyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'response_field_widget_event.dart';
part 'response_field_widget_state.dart';

class ResponseFieldWidgetBloc extends Bloc<ResponseFieldWidgetEvent, ResponseFieldWidgetState> {
  ResponseFieldWidgetBloc() : super(ResponseFieldLoadingState()) {
    on<ResponseFieldInitialEvent>((event, emit) {
      emit(ResponseFieldLoadingState());
    });
  }
}

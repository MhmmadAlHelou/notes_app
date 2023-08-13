import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/models/note_model.dart';

part 'ntes_state.dart';

class NtesCubit extends Cubit<NtesState> {
  NtesCubit() : super(NtesInitial());
}

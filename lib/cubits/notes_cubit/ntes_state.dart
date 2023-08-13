part of 'ntes_cubit.dart';

@immutable
sealed class NtesState {}

final class NtesInitial extends NtesState {}

final class NtesLoading extends NtesState {}

final class NtesSuccess extends NtesState {
  final List<NoteModel> notes;

  NtesSuccess(this.notes);
}

final class NtesFailure extends NtesState {
  final String errMessag;

  NtesFailure(this.errMessag);
}

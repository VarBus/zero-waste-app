import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_waste_app/core/enums/status.dart';
import 'package:zero_waste_app/features/items/domain/repositories/zero_waste_repository.dart';
import 'package:zero_waste_app/features/items/presentation/detail_bloc/detail_event.dart';
import 'package:zero_waste_app/features/items/presentation/detail_bloc/detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState>{
  final ZeroWasteRepository repo;
  StreamSubscription? sub;
  int? currentId;


  DetailBloc(this.repo) : super(DetailState.initial()) {
    on<DetailOpened>(_onOpened);
    on<DetailItemArrived>(_onItemArrived);
    on<DetailSaveRequested>(_onSave);
    on<DetailConsumedRequested>(_onConsumed);
    on<DetailDisposedRequested>(_onDisposed);
    on<DetailDeleteRequested>(_onDelete);
  }
  Future<void> _onOpened(DetailOpened event, Emitter<DetailState> emit) async {
    if (currentId == event.id && sub != null) return;

    currentId = event.id;
    emit(state.copyWith(status: Status.loading, message: null));
    await sub?.cancel();

    sub = repo.watchItemById(event.id).listen((item) {
      add(DetailItemArrived(item));
    });
  }

  void _onItemArrived(DetailItemArrived event, Emitter<DetailState> emit) {
    emit(state.copyWith(status: Status.success, item: event.item, message: null));
  }

  Future<void> _onSave(DetailSaveRequested event, Emitter<DetailState> emit) async {
    emit(state.copyWith(status: Status.loading, message: null));
    try {
      await repo.updateItem(event.item);
      emit(state.copyWith(status: Status.success, message: 'Saved'));
    } catch (_) {
      emit(state.copyWith(status: Status.failure, message: 'Save failed'));
    }
  }

Future<void> _onConsumed(DetailConsumedRequested event, Emitter<DetailState> emit) async {
  final item = state.item;
  if (item == null) return;

  emit(state.copyWith(status: Status.loading, message: null));
  try {
    await repo.consumeOneUnit(item.id);
    emit(state.copyWith(status: Status.success, message: 'Consumed'));
  } catch (_) {
    emit(state.copyWith(status: Status.failure, message: 'Action failed'));
  }
}


  Future<void> _onDisposed(DetailDisposedRequested event, Emitter<DetailState> emit) async {
    final item = state.item;
    if (item == null) return;

    emit(state.copyWith(status: Status.loading, message: null));
    try {
      await repo.disposeOneUnit(item.id, reason: event.reason ?? '');
      final nextQty = item.quantity - 1;
      if (nextQty <= 0) {
        await repo.deleteItem(item.id);
      } else {
        await repo.updateItem(item.copyWith(quantity: nextQty));
      }
      emit(state.copyWith(status: Status.success, message: 'Disposed'));
    } catch (_) {
      emit(state.copyWith(status: Status.failure, message: 'Action failed'));
    }
  }

  Future<void> _onDelete(DetailDeleteRequested event, Emitter<DetailState> emit) async {
    final item = state.item;
    if (item == null) return;

    emit(state.copyWith(status: Status.loading, message: null));
    try {
      await repo.deleteItem(item.id);
      emit(state.copyWith(status: Status.success, message: 'Deleted'));
    } catch (_) {
      emit(state.copyWith(status: Status.failure, message: 'Delete failed'));
    }
  }

  @override
  Future<void> close() async {
    await sub?.cancel();
    return super.close();
  }
}

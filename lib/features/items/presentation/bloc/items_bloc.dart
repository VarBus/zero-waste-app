import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zero_waste_app/core/enums/status.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_item.dart';
import 'package:zero_waste_app/features/items/domain/repositories/zero_waste_repository.dart';
import 'package:zero_waste_app/features/items/presentation/bloc/items_event.dart';
import 'package:zero_waste_app/features/items/presentation/bloc/items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ZeroWasteRepository _repo;

  StreamSubscription? _itemsSub;
  StreamSubscription? _summarySub;

  ItemsBloc(this._repo) : super(ItemsState.initial()) {
    on<ItemsStarted>(_onStarted);
    on<ItemsQueryChanged>(_onQueryChanged);
    on<ItemCreateRequested>(_onCreate);
    on<ItemsArrived>(_onItemsArrived);
    on<SummaryArrived>(_onSummaryArrived);
  }

  Future<void> _onStarted(ItemsStarted event, Emitter<ItemsState> emit) async {
    if (_itemsSub != null) return;

    emit(state.copyWith(status: Status.loading, message: null));

    _itemsSub = _repo.watchItems(query: state.query).listen(
          (items) => add(ItemsArrived(items)),
        );

    _summarySub = _repo.watchWasteSummary().listen(
          (summary) => add(SummaryArrived(summary)),
        );
  }

  Future<void> _onQueryChanged(ItemsQueryChanged event, Emitter<ItemsState> emit) async {
    emit(state.copyWith(query: event.query, status: Status.loading, message: null));
    await _itemsSub?.cancel();

    _itemsSub = _repo.watchItems(query: event.query).listen(
          (items) => add(ItemsArrived(items)),
        );
  }

  Future<void> _onCreate(ItemCreateRequested event, Emitter<ItemsState> emit) async {
    emit(state.copyWith(status: Status.loading, message: null));
    try {
      await _repo.createItem(
        name: event.name,
        category: event.category,
        quantity: event.quantity,
        expiresAt: event.expiresAt,
        foodGroup: event.foodGroup,
      );
      emit(state.copyWith(status: Status.success, message: 'Item created'));
    } catch (_) {
      emit(state.copyWith(status: Status.failure, message: 'Create failed'));
    }
  }

  void _onItemsArrived(ItemsArrived event, Emitter<ItemsState> emit) {
    emit(state.copyWith(status: Status.success, items: event.items.cast<WasteItem>(), message: null));
  }

  void _onSummaryArrived(SummaryArrived event, Emitter<ItemsState> emit) {
    emit(state.copyWith(status: Status.success, summary: event.summary, message: null));
  }

  @override
  Future<void> close() async {
    await _itemsSub?.cancel();
    await _summarySub?.cancel();
    return super.close();
  }
}

import 'package:equatable/equatable.dart';
import 'package:zero_waste_app/features/items/domain/entities/waste_item.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object?> get props => [];
}

class DetailOpened extends DetailEvent {
  final int id;
  const DetailOpened(this.id);
  @override
  List<Object?> get props => [id];
}

class DetailSaveRequested extends DetailEvent {
  final WasteItem item;
  const DetailSaveRequested(this.item);
  @override
  List<Object?> get props => [item];
}

class DetailConsumedRequested extends DetailEvent {
  const DetailConsumedRequested();
}

class DetailDisposedRequested extends DetailEvent {
  final String? reason;
  const DetailDisposedRequested(this.reason);
  @override
  List<Object?> get props => [reason];
}

class DetailDeleteRequested extends DetailEvent {
  const DetailDeleteRequested();
}

class DetailItemArrived extends DetailEvent {
  final WasteItem? item;
  const DetailItemArrived(this.item);
  @override
  List<Object?> get props => [item];
}
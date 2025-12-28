enum WasteAction { consumed, disposed }

class WasteEvent {
  final int id;
  final int itemId;
  final WasteAction action;
  final DateTime happenedAt;
  final String? disposedReason;

  const WasteEvent({
    required this.id,
    required this.itemId,
    required this.action,
    required this.happenedAt,
    this.disposedReason,
  });
}

import 'package:flutter/material.dart';

class WasteBar extends StatelessWidget {
  final int consumed;
  final int disposed;

  const WasteBar({super.key, required this.consumed, required this.disposed});

  @override
  Widget build(BuildContext context) {
    final total = consumed + disposed;
    final consumedRatio = total == 0 ? 0.0 : consumed / total;
    final disposedRatio = total == 0 ? 0.0 : disposed / total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Consumed vs Disposed', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    Expanded(
                      flex: (consumedRatio * 1000).round().clamp(0, 1000),
                      child: Container(color: Colors.green.withOpacity(0.85)),
                    ),
                    Expanded(
                      flex: (disposedRatio * 1000).round().clamp(0, 1000),
                      child: Container(color: Colors.red.withOpacity(0.85)),
                    ),
                    if (total == 0) Expanded(flex: 1000, child: Container(color: Colors.black12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text('Consumed: $consumed • Disposed: $disposed', style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
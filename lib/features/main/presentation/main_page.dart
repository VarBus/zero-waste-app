import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final VoidCallback onFab;

  const MainPage({
    super.key,
    required this.navigationShell,
    required this.onFab,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: navigationShell,

      // ✅ FAB arriba de Progress (no sobrepuesto, con espacio real)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
          child: SizedBox(
            height: 64 + 44, // 64 barra + 44 espacio para el FAB arriba
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Barra (abajo)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withOpacity(0.88),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _NavBtn(
                            label: 'Home',
                            icon: Icons.home_outlined,
                            selected: navigationShell.currentIndex == 0,
                            onTap: () => navigationShell.goBranch(0),
                          ),
                        ),
                        Expanded(
                          child: _NavBtn(
                            label: 'Plan',
                            icon: Icons.auto_awesome_outlined,
                            selected: navigationShell.currentIndex == 1,
                            onTap: () => navigationShell.goBranch(1),
                          ),
                        ),
                        Expanded(
                          child: _NavBtn(
                            label: 'Progress',
                            icon: Icons.insights_outlined,
                            selected: navigationShell.currentIndex == 2,
                            onTap: () => navigationShell.goBranch(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Align(
                alignment: const Alignment(1, 1),
                child: Padding(
                padding: const EdgeInsets.only(bottom: 70), 
                child: FloatingActionButton(
                onPressed: onFab,
                child: const Icon(Icons.add),
    ),
  ),
),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavBtn({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = selected ? cs.primaryContainer : Colors.transparent;
    final fg = selected ? cs.onPrimaryContainer : cs.onSurfaceVariant;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

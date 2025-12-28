import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  int index = 0;

  final pages = const [
    _OnbPage(
      title: 'Track',
      subtitle: 'Add items with expiration dates in seconds.',
      icon: Icons.inventory_2_outlined,
    ),
    _OnbPage(
      title: 'Act',
      subtitle: 'Follow the best plan to consume before items expire.',
      icon: Icons.auto_awesome_outlined,
    ),
    _OnbPage(
      title: 'Improve',
      subtitle: 'Measure your waste rate and reduce it over time.',
      icon: Icons.insights_outlined,
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (i) => setState(() => index = i),
                  children: pages,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) {
                  final active = i == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: active ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? scheme.primary : Colors.black12,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () => context.go('/items'),
                  child: const Text('Let’s start'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnbPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _OnbPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 54, color: scheme.primary),
              ),
              const SizedBox(height: 18),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
              const SizedBox(height: 10),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
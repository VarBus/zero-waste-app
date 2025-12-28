import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste_app/features/items/presentation/bloc/items_bloc.dart';
import 'package:zero_waste_app/features/items/presentation/pages/items_page.dart';
import 'package:zero_waste_app/features/main/presentation/main_page.dart';
import 'package:zero_waste_app/features/onboarding/presentation/onboarding_page.dart';
import 'package:zero_waste_app/features/plan/presentation/plan_page.dart';
import 'package:zero_waste_app/features/progress/presentation/progress_page.dart';

GoRouter buildRouter({
  required ItemsBloc itemsBloc,
  required VoidCallback onFabCreate,
}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingPage(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BlocProvider.value(
            value: itemsBloc,
            child: MainPage(
              navigationShell: navigationShell,
              onFab: onFabCreate,
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/items',
                builder: (context, state) => const ItemsPage(selectedId: null),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '');
                      return ItemsPage(selectedId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/plan',
                builder: (context, state) => const PlanPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progress',
                builder: (context, state) => const ProgressPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

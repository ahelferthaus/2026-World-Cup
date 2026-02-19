import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/data/demo_data.dart';
import '../core/extensions/async_value_extensions.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/leaderboard/presentation/leaderboard_screen.dart';
import '../features/news/presentation/news_screen.dart';
import '../features/predict/presentation/predict_screen.dart';
import '../features/profile/presentation/edit_name_screen.dart';
import '../features/profile/presentation/prediction_history_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/propbets/presentation/prop_bets_screen.dart';
import '../features/store/presentation/token_store_screen.dart';
import '../features/bracket/presentation/bracket_screen.dart';
import '../features/livegame/presentation/live_game_screen.dart';
import '../features/teams/presentation/teams_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  // Watch demo login state so router refreshes when it changes
  if (useDemoData) ref.watch(demoLoggedInProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final bool isLoggedIn;
      if (useDemoData) {
        isLoggedIn = ref.read(demoLoggedInProvider);
      } else {
        isLoggedIn = authState.valueOrNull != null;
      }
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      // Full-screen routes (not in bottom nav)
      GoRoute(
        path: '/teams',
        builder: (_, __) => const TeamsScreen(),
      ),
      GoRoute(
        path: '/news',
        builder: (_, __) => const NewsScreen(),
      ),
      GoRoute(
        path: '/store',
        builder: (_, __) => const TokenStoreScreen(),
      ),
      GoRoute(
        path: '/propbets',
        builder: (_, __) => const PropBetsScreen(),
      ),
      GoRoute(
        path: '/bracket',
        builder: (_, __) => const BracketScreen(),
      ),
      GoRoute(
        path: '/live/:matchId',
        builder: (_, state) => LiveGameScreen(
          matchId: state.pathParameters['matchId'] ?? '1',
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) {
          return _AppScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/predict',
                builder: (_, __) => const PredictScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/leaderboard',
                builder: (_, __) => const LeaderboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, __) => const EditNameScreen(),
                  ),
                  GoRoute(
                    path: 'history',
                    builder: (_, __) => const PredictionHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _AppScaffold extends StatelessWidget {
  const _AppScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _navItems = <({IconData icon, IconData activeIcon, String label})>[
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    (icon: Icons.sports_outlined, activeIcon: Icons.sports, label: 'Predict'),
    (icon: Icons.leaderboard_outlined, activeIcon: Icons.leaderboard, label: 'Rankings'),
    (icon: Icons.person_outlined, activeIcon: Icons.person, label: 'Profile'),
  ];

  void _onTap(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final useRail = width >= 600;
    final useExtendedRail = width >= 900;

    if (useRail) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onTap,
              extended: useExtendedRail,
              labelType: useExtendedRail
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.selected,
              destinations: _navItems
                  .map((item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.activeIcon),
                        label: Text(item.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: navigationShell,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        items: _navItems
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  activeIcon: Icon(item.activeIcon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}

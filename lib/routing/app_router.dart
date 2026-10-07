import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/floating_nav_bar.dart';
import '../features/welcome/welcome_screen.dart';
import '../features/home/home_screen.dart';
import '../features/events/events_list_screen.dart';
import '../features/events/event_detail_screen.dart';
import '../features/komsel/komsel_list_screen.dart';
import '../features/komsel/komsel_detail_screen.dart';
import '../features/activities/activities_screen.dart';
import '../features/announcements/announcements_screen.dart';
import '../features/devotion/devotion_screen.dart';
import '../features/prayer/prayer_screen.dart';
import '../features/gallery/gallery_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/admin/admin_panel_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/welcome',
  routes: [
    // Welcome / Onboarding
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),

    // Shell Route with Floating 5-Tab Navigation Bar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: FloatingNavBar(
            currentIndex: _calculateSelectedIndex(state.uri.path),
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/events');
                  break;
                case 2:
                  context.go('/komsel');
                  break;
                case 3:
                  context.go('/announcements');
                  break;
                case 4:
                  context.go('/profile');
                  break;
              }
            },
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/events',
          pageBuilder: (context, state) => const NoTransitionPage(child: EventsListScreen()),
        ),
        GoRoute(
          path: '/komsel',
          pageBuilder: (context, state) => const NoTransitionPage(child: KomselListScreen()),
        ),
        GoRoute(
          path: '/announcements',
          pageBuilder: (context, state) => const NoTransitionPage(child: AnnouncementsScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),

    // Details & Sub-screens (outside shell for full-screen immersive experience)
    GoRoute(
      path: '/events/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'event_01';
        return EventDetailScreen(eventId: id);
      },
    ),
    GoRoute(
      path: '/komsel/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'komsel_01';
        return KomselDetailScreen(komselId: id);
      },
    ),
    GoRoute(
      path: '/activities',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ActivitiesScreen(),
    ),
    GoRoute(
      path: '/devotions',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DevotionScreen(),
    ),
    GoRoute(
      path: '/prayers',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PrayerScreen(),
    ),
    GoRoute(
      path: '/gallery',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const GalleryScreen(),
    ),
    GoRoute(
      path: '/notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/admin',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AdminPanelScreen(),
    ),
  ],
);

int _calculateSelectedIndex(String location) {
  if (location.startsWith('/home')) return 0;
  if (location.startsWith('/events')) return 1;
  if (location.startsWith('/komsel')) return 2;
  if (location.startsWith('/announcements')) return 3;
  if (location.startsWith('/profile')) return 4;
  return 0;
}

// GoRouter configuration
import 'package:go_router/go_router.dart';
import 'package:ham_lookup/views/home_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
  ],
);
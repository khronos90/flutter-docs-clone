import 'package:docs_clone_flutter/screens/document.screen.dart';
import 'package:docs_clone_flutter/screens/home.screen.dart';
import 'package:docs_clone_flutter/screens/login.screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeScreen()),
  '/document/:id': (route) =>
      MaterialPage(child: DocumentScreen(id: route.pathParameters['id'] ?? '')),
});

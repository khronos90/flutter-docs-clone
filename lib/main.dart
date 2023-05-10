import 'package:docs_clone_flutter/models/error.model.dart';
import 'package:docs_clone_flutter/repository/auth.repository.dart';
import 'package:docs_clone_flutter/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? error;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    error = await ref.read(authRepositoryProvider).getUserData();
    if (error != null && error!.data != null) {
      ref.read(userProvider.notifier).update((state) => error!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        if (user != null && user.token.isNotEmpty) {
          return loggedInRoute;
        } else {
          return loggedOutRoute;
        }
      }),
      routeInformationParser: const RoutemasterParser(),
      // home: user == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}

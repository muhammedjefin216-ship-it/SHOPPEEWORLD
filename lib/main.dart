// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shoppee_world/user/main_screen.dart';
// import 'package:shoppee_world/user/views/auth/login/login_screen.dart';
// import 'package:shoppee_world/user/views/onboarding/onboarding_scren.dart';
// import 'package:shoppee_world/user/views/splash/splash_screen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// void main()async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: 'https://vdxqxeiugvylbocmmoly.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkeHF4ZWl1Z3Z5bGJvY21tb2x5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ5NzI1NjAsImV4cCI6MjEwMDU0ODU2MH0.wezGoHFBxXMJ5snJuJDpRhUlvS1_UE14ODVbGrsMeJ4',
//   );
//   runApp(const ProviderScope(child: ShopeeWorld()));
// }

// class ShopeeWorld extends StatelessWidget {
//   const ShopeeWorld({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Store",
//       theme: ThemeData(useMaterial3: true),
//       home: MainScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppee_world/user/main_screen.dart';
import 'package:shoppee_world/user/views/auth/login/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vdxqxeiugvylbocmmoly.supabase.co',
    anonKey: 'sb_publishable_gQSipJMJr-5F8NhcovSZvQ_sIt_JnSf',
  );

  runApp(
    const ProviderScope(
      child: ShopeeWorld(),
    ),
  );
}

class ShopeeWorld extends StatelessWidget {
  const ShopeeWorld({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Store",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    final session = supabase.auth.currentSession;

    if (session != null) {
      return const MainScreen();
    }

    return const LoginScreen();
  }
}

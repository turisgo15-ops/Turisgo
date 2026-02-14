import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:turisgo/PantallaPrincipal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mqkiesklveagjqdbdmuy.supabase.co',
    anonKey: 'TU_ANON_KEY',
  );

  runApp(Principal());
}

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Formulario",
      debugShowCheckedModeBanner: false,

      // 👇 IMPORTANTE
      locale: const Locale('es'),

      supportedLocales: const [Locale('es')],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: PantallaPrincipal(),
    );
  }
}

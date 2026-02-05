import 'package:flutter/material.dart';
import 'package:turisgo/PantallaPrincipal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mqkiesklveagjqdbdmuy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1xa2llc2tsdmVhZ2pxZGJkbXV5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1OTI0MDEsImV4cCI6MjA4MDE2ODQwMX0.zq8FmPvcsujFhMpe5N10USYBcr-4hPBjH8rpCbLH1EE',
  );

  runApp(Principal());
}

class Principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Formulario",
      home: PantallaPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

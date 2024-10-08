import 'package:cortes_energia/data/repository/cnel_cortes_luz_repository.dart';
import 'package:cortes_energia/data/repository/shared_prefs_documents_repository.dart';
import 'package:cortes_energia/ui/screens/home_screen.dart';
import 'package:cortes_energia/ui/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cortes de Energía',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (_) => HomeViewModel(
          CnelCortesLuzRepository(),
          SharedPrefsDocumentsRepository(
            SharedPreferencesAsync(),
          ),
        ),
        child: const HomeScreen(),
      ),
    );
  }
}

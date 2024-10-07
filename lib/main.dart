import 'package:cortes_energia/data/repository/cnel_cortes_luz_repository.dart';
import 'package:cortes_energia/ui/screens/home_screen.dart';
import 'package:cortes_energia/ui/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
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
        ),
        child: const HomeScreen(),
      ),
    );
  }
}

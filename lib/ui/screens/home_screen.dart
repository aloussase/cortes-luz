import 'dart:async';

import 'package:cortes_energia/domain/models/criterio.dart';
import 'package:cortes_energia/ui/viewmodels/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StreamSubscription<UiMessage> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = context.read<HomeViewModel>().messages.listen(
      (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: message.type == UiMessageKind.error
                ? Colors.red
                : Colors.indigo,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Consulta tu horario de corte de luz",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ConsultarHorariosForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ConsultarHorariosForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ConsultarHorariosForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Ingrese el número de documento",
                  label: Text("Documento"),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El número de documento es obligatorio';
                  }
                  return null;
                },
                onChanged: (value) {
                  context
                      .read<HomeViewModel>()
                      .add(DocumentoChanged(documento: value));
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                items: Criterio.values.map(
                  (criterio) {
                    return DropdownMenuItem(
                      value: criterio.value,
                      child: Text(criterio.displayName),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  context
                      .read<HomeViewModel>()
                      .add(CriterioChanged(criterio: value as String));
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Criterio",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El criterio es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<HomeViewModel>().add(ConsultarHorarios());
                  }
                },
                child: state.status == HomeStatus.loading
                    ? const CircularProgressIndicator()
                    : const Text("Consultar"),
              )
            ],
          ),
        );
      },
    );
  }
}

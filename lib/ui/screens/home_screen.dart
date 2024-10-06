import 'dart:async';

import 'package:cortes_energia/domain/models/criterio.dart';
import 'package:cortes_energia/ui/viewmodels/home_viewmodel.dart';
import 'package:cortes_energia/ui/widgets/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                const SizedBox(height: 20),
                ConsultarHorariosForm(),
                const SizedBox(height: 20),
                const CortesLuzInformation(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConsultarHorariosForm extends StatefulWidget {
  const ConsultarHorariosForm({super.key});

  @override
  State<ConsultarHorariosForm> createState() => _ConsultarHorariosFormState();
}

class _ConsultarHorariosFormState extends State<ConsultarHorariosForm> {
  final _formKey = GlobalKey<FormState>();

  final _documentoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final viewModel = context.read<HomeViewModel>();

    _documentoController.addListener(
      () => viewModel.add(
        DocumentoChanged(documento: _documentoController.text),
      ),
    );
  }

  @override
  void dispose() {
    _documentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _documentoController,
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
                value: state.criterio,
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

class CortesLuzInformation extends StatelessWidget {
  const CortesLuzInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        if (state.information == null) {
          return const Column();
        }

        final information = state.information!;

        return Column(
          children: [
            const TextDivider(
              text: "Información",
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              children: [
                const Text("Alimentador"),
                Text(information.alimentador),
                const Text("Cuenta"),
                Text(information.cuenta),
                const Text("Contrato"),
                Text(information.cuentaContrato),
                const Text("Dirección"),
                Text(information.direccion),
              ],
            ),
            const SizedBox(height: 20),
            const TextDivider(
              text: 'Cortes de Luz',
              color: Colors.blue,
            ),
          ],
        );
      },
    );
  }
}

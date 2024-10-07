import 'package:cortes_energia/domain/models/horario_corte.dart';

final class CortesLuzInformation {
  final String alimentador;
  final String cuentaContrato;
  final String cuenta;
  final String direccion;
  final List<HorarioCorte> horarios;

  CortesLuzInformation({
    required this.alimentador,
    required this.cuentaContrato,
    required this.cuenta,
    required this.direccion,
    required this.horarios,
  });
}

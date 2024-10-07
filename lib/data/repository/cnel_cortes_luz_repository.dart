import 'dart:convert';
import 'dart:io';

import 'package:cortes_energia/domain/models/cortes_luz_information.dart';
import 'package:cortes_energia/domain/models/horario_corte.dart';
import 'package:cortes_energia/domain/repository/cortes_luz_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CnelCortesLuzRepository extends CortesLuzRepository {
  @override
  Future<Either<String, CortesLuzInformation>> consultarCortesLuz(
    String documento,
    String criterio,
  ) async {
    final uri = Uri.https(
      "api.cnelep.gob.ec",
      "servicios-linea/v1/notificaciones/consultar/$documento/$criterio",
    );

    Response response;

    try {
      response = await http.get(uri);
    } on SocketException {
      return Either.left("No se pudo contactar al servidor");
    } catch (_) {
      return Either.left("Hubo un error al consultar los horarios");
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (json["resp"] == "ERROR") {
      final errorMessage = json["mensaje"];
      return Either.left(errorMessage);
    }

    final List<dynamic> data = json["notificaciones"];
    if (data.isEmpty) {
      return Either.left("No hay datos que mostrar");
    }

    final plan = data[0];

    final List<HorarioCorte> horarios = plan["detallePlanificacion"]
        .map<HorarioCorte>(
          (json) => HorarioCorte(
            fechaCorte: json["fechaCorte"],
            horaDesde: json["horaDesde"],
            horaHasta: json["horaHasta"],
          ),
        )
        .toList();

    final information = CortesLuzInformation(
      alimentador: plan["alimentador"],
      cuentaContrato: plan["cuentaContrato"],
      cuenta: plan["cuen"],
      direccion: plan["direccion"],
      horarios: horarios,
    );

    return Either.right(information);
  }
}

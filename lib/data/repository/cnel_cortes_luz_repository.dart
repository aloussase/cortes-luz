import 'dart:convert';

import 'package:cortes_energia/domain/models/cortes_luz_information.dart';
import 'package:cortes_energia/domain/repository/cortes_luz_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

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

    final response = await http.get(uri);
    final json = jsonDecode(response.body);

    if (json["resp"] == "ERROR") {
      final errorMessage = json["mensaje"];
      return Either.left(errorMessage);
    }

    final List<dynamic> data = json["notificaciones"];
    if (data.isEmpty) {
      return Either.left("No hay datos que mostrar");
    }

    final plan = data[0];

    final information = CortesLuzInformation(
      alimentador: plan["alimentador"],
      cuentaContrato: plan["cuentaContrato"],
      cuenta: plan["cuen"],
      direccion: plan["direccion"],
    );

    return Either.right(information);
  }
}

import 'package:cortes_energia/domain/models/cortes_luz_information.dart';
import 'package:fpdart/fpdart.dart';

abstract class CortesLuzRepository {
  Future<Either<String, CortesLuzInformation>> consultarCortesLuz(
    String documento,
    String criterio,
  );
}

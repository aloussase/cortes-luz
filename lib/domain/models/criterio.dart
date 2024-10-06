enum Criterio {
  cuentaContrato("CUENTA_CONTRATO", "Cuenta contrato"),
  codigoUnico("CUEN", "Código único (cuen)"),
  identificacion("IDENTIFICACION", "Número de identificación");

  final String value;
  final String displayName;

  const Criterio(this.value, this.displayName);
}

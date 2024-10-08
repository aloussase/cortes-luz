abstract class DocumentsRepository {
  Future<void> saveDocumentNumber(String documentNumber);

  Future<String?> getMostRecentDocumentNumber();
}

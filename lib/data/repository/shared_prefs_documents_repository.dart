import 'package:cortes_energia/domain/repository/documents_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class SharedPrefsDocumentsRepository implements DocumentsRepository {
  final SharedPreferencesAsync sharedPrefs;

  static const String sharedPrefsKey = "DOCUMENT_NUMBER";

  SharedPrefsDocumentsRepository(this.sharedPrefs);

  @override
  Future<String?> getMostRecentDocumentNumber() async =>
      await sharedPrefs.getString(sharedPrefsKey);

  @override
  Future<void> saveDocumentNumber(String documentNumber) async =>
      await sharedPrefs.setString(sharedPrefsKey, documentNumber);
}

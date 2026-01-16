import 'package:sqflite/sqflite.dart';
import '../../../core/services/database_service.dart';
import 'scan_history_model.dart';

class HistoryRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<int> saveScan(ScanRecord record) async {
    final db = await _dbService.database;
    return await db.insert('scan_history', record.toMap());
  }

  Future<List<ScanRecord>> getRecentScans() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      orderBy: 'timestamp DESC',
      limit: 10,
    );
    return List.generate(maps.length, (i) => ScanRecord.fromMap(maps[i]));
  }

  Future<int> getScanCount() async {
    final db = await _dbService.database;
    return Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM scan_history')) ??
        0;
  }

  Future<int> getUniqueSpeciesCount() async {
    final db = await _dbService.database;
    return Sqflite.firstIntValue(await db.rawQuery(
            'SELECT COUNT(DISTINCT fish_local_name) FROM scan_history')) ??
        0;
  }

  Future<List<ScanRecord>> getUniqueSpecies() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      groupBy: 'fish_local_name',
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) => ScanRecord.fromMap(maps[i]));
  }
}

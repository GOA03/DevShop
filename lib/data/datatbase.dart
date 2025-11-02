import 'package:dev_shop/data/cart_dao.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), "cartDatabase.db");
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(CartDao.sqlTable);
    },
    version: 1,
  );
}

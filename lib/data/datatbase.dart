import 'package:dev_shop/data/cart/cart_dao.dart';
import 'package:dev_shop/data/favorite/favorite_dao.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), "devShop.db");
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(CartDao.sqlTable);
      db.execute(FavoriteDao.sqlTable);
    },
    version: 3,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 3) {
        await db.execute(FavoriteDao.sqlTable);
      }
    },
  );
}

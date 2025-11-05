import 'package:dev_shop/data/datatbase.dart';
import 'package:dev_shop/data/favorite/favorite_model.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteDao {
  static const String _tablename = 'tableFavorite';
  static const String _userId = 'userId';
  static const String _proId = 'prodId';

  static const sqlTable =
      """
    CREATE TABLE $_tablename(
      $_userId INT,
      $_proId INT)
  """;

  List<FavoriteModel> toList(List<Map<String, dynamic>> favoriteList) {
    final List<FavoriteModel> list = [];
    for (Map<String, dynamic> line in favoriteList) {
      final FavoriteModel favoriteModel = FavoriteModel(
        line[_userId],
        line[_proId],
      );
      list.add(favoriteModel);
    }
    return list;
  }

  Map<String, dynamic> toMap(FavoriteModel cartModel) {
    final Map<String, dynamic> map = {};
    map[_proId] = cartModel.prodId;
    map[_userId] = cartModel.userId;
    return map;
  }

  Future<List<FavoriteModel>> findAll(int userId) async {
    final Database db = await getDatabase();
    print("============================\n\n\n\n\n\n");
    print("userId");
    print(userId);
    print("============================\n\n\n\n\n\n");
    final List<Map<String, dynamic>> result = await db.query(
      _tablename,
      where: '$_userId = ?',
      whereArgs: [userId],
    );
    return toList(result);
  }

  Future<List<FavoriteModel>> find(int prodId, int userId) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      _tablename,
      where: '$_proId = ? AND $_userId = ?',
      whereArgs: [prodId, userId],
    );
    return toList(result);
  }

  Future<bool> save(FavoriteModel favorite) async {
    final Database db = await getDatabase();
    var exist = await find(favorite.prodId, favorite.userId);

    Map<String, dynamic> cartMap = toMap(favorite);
    if (exist.isEmpty) {
      await db.insert(_tablename, cartMap);
      return true;
    } else {
      return false;
    }
  }

  Future<int> delete(int userId, int prodId) async {
    final Database db = await getDatabase();
    return db.delete(
      _tablename,
      where: "$_userId = ? AND $_proId = ? ",
      whereArgs: [userId, prodId],
    );
  }
}

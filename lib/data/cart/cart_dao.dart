import 'package:dev_shop/data/cart/cart_model.dart';
import 'package:dev_shop/data/datatbase.dart';
import 'package:sqflite/sqflite.dart';

class CartDao {
  static const String _tablename = 'tableCart';
  static const String _userId = 'userId';
  static const String _proId = 'prodId';
  static const String _quantity = 'quantity';

  static String sqlTable =
      """
    CREATE TABLE $_tablename(
      $_userId INT,
      $_proId INT,
      $_quantity INT
    )
  """;

  // Transsforma o map em list para ficar mais facil de trabalhar
  List<CartModel> toList(List<Map<String, dynamic>> cartList) {
    final List<CartModel> list = [];
    for (Map<String, dynamic> line in cartList) {
      final CartModel cartModel = CartModel(
        line[_quantity],
        line[_userId],
        line[_proId],
      );
      list.add(cartModel);
    }
    return list;
  }

  Map<String, dynamic> toMap(CartModel cartModel) {
    final Map<String, dynamic> map = {};
    map[_proId] = cartModel.prodId;
    map[_quantity] = cartModel.quantity;
    map[_userId] = cartModel.userId;
    return map;
  }

  //Retorna todos os itens do usuário
  Future<List<CartModel>> find(int prodId, int userId) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      _tablename,
      where: '$_proId = ? AND $_userId = ?',
      whereArgs: [prodId, userId],
    );
    return toList(result);
  }

  Future<List<CartModel>> findAll(int userId) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      _tablename,
      where: '$_userId = ?',
      whereArgs: [userId],
    );
    return toList(result);
  }

  Future<bool> save(CartModel cart) async {
    final Database db = await getDatabase();
    var exist = await find(cart.prodId, cart.userId);

    Map<String, dynamic> cartMap = toMap(cart);
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

  Future<int> deleteAll(int userId) async {
    final Database db = await getDatabase();
    return db.delete(_tablename, where: "$_userId = ?", whereArgs: [userId]);
  }

  Future<int> increaseQuantity(int userId, int prodId) {
    return find(prodId, userId).then((value) {
      CartModel cartModel = value[0];
      cartModel.quantity++;
      getDatabase().then((db) {
        db.update(
          _tablename,
          toMap(cartModel),
          where: "$_userId = ? AND $_proId = ? ",
          whereArgs: [userId, prodId],
        );
      });
      return cartModel.quantity;
    });
  }

  Future<int> decreaseQuantity(int userId, int prodId) {
    return find(prodId, userId).then((value) {
      CartModel cartModel = value[0];
      cartModel.quantity--;
      if (cartModel.quantity != 0) {
        getDatabase().then((db) {
          db.update(
            _tablename,
            toMap(cartModel),
            where: "$_userId = ? AND $_proId = ? ",
            whereArgs: [userId, prodId],
          );
        });
        return cartModel.quantity;
      }
      delete(userId, prodId);
      return 0;
    });
  }
}

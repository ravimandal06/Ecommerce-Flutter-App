import 'dart:convert';
import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../consts/api_consts.dart';
import '../models/categories_model.dart';
import '../models/products_model.dart';
import '../models/users_model.dart';

class APIHandler {
  static Future<List<dynamic>> getData(
      {required String target, String? limit}) async {
    try {
      var uri = Uri.https(
          BASE_URL,
          "api/v1/$target",
          target == "products"
              ? {
                  "offset": "0",
                  "limit": limit,
                }
              : {});
      var response = await http.get(uri);

      // print("response ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);
      List tempList = [];
      if (response.statusCode != 200) {
        throw data["message"];
      }
      for (var v in data) {
        tempList.add(v);
        // print("V $v \n\n");
      }
      return tempList;
    } catch (error) {
      log("An error occured $error");
      throw error.toString();
    }
  }

  static Future<List<ProductsModel>> getAllProducts(
      {required String limit}) async {
    List temp = await getData(
      target: "products",
      limit: limit,
    );
    return ProductsModel.productsFromSnapshot(temp);
  }

  static Future<List<CategoriesModel>> getAllCategories() async {
    List temp = await getData(target: "categories");
    return CategoriesModel.categoriesFromSnapshot(temp);
  }

  static Future<List<UsersModel>> getAllUsers() async {
    List temp = await getData(target: "users");
    return UsersModel.usersFromSnapshot(temp);
  }

  static Future<ProductsModel> getProductById({required String id}) async {
    try {
      var uri = Uri.https(
        BASE_URL,
        "api/v1/products/$id",
      );
      var response = await http.get(uri);

      // print("response ${jsonDecode(response.body)}");
      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data["message"];
      }
      return ProductsModel.fromJson(data);
    } catch (error) {
      log("an error occured while getting product info $error");
      throw error.toString();
    }
  }
}

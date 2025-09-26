import 'dart:convert';
import 'package:atbrakitchen_multivendor/api/local_client.dart';
import 'package:atbrakitchen_multivendor/common/enums/data_source_enum.dart';
import 'package:atbrakitchen_multivendor/common/models/product_model.dart';
import 'package:atbrakitchen_multivendor/common/models/restaurant_model.dart';
import 'package:atbrakitchen_multivendor/api/api_client.dart';
import 'package:atbrakitchen_multivendor/features/category/domain/models/category_model.dart';
import 'package:atbrakitchen_multivendor/features/category/domain/reposotories/category_repository_interface.dart';
import 'package:atbrakitchen_multivendor/util/app_constants.dart';
import 'package:get/get.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final ApiClient apiClient;

  CategoryRepository({required this.apiClient});

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(String? id) {
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryModel>?> getList({int? offset, DataSourceEnum? source, String? search}) async {
    List<CategoryModel>? categoryList;
    String cacheId = AppConstants.categoryUri;

    switch(source!){
      case DataSourceEnum.client:
        String uri = AppConstants.categoryUri;
        if (search != null && search.isNotEmpty) {
          uri += '?name=$search';
        }
        Response response = await apiClient.getData(uri);

        if(response.statusCode == 200){
          categoryList = [];
          response.body.forEach((category) {
            categoryList!.add(CategoryModel.fromJson(category));
          });
          LocalClient.organize(DataSourceEnum.client, cacheId, jsonEncode(response.body), apiClient.getHeader());
        }

      case DataSourceEnum.local:
        String? cacheResponseData = await LocalClient.organize(DataSourceEnum.local, cacheId, null, null);
        if(cacheResponseData != null) {
          categoryList = [];
          jsonDecode(cacheResponseData).forEach((category) {
            categoryList!.add(CategoryModel.fromJson(category));
          });
        }
    }
    return categoryList;
  }

  @override
  Future<List<CategoryModel>?> getSubCategoryList(String? parentID) async {
    List<CategoryModel>? subCategoryList;
    Response response = await apiClient.getData('${AppConstants.subCategoryUri}$parentID');
    if (response.statusCode == 200) {
      subCategoryList= [];
      subCategoryList.add(CategoryModel(id: int.parse(parentID!), name: 'all'.tr));
      response.body.forEach((category) => subCategoryList!.add(CategoryModel.fromJson(category)));
    }
    return subCategoryList;
  }

  @override
  Future<ProductModel?> getCategoryProductList(String? categoryID, int offset, String type) async {
    ProductModel? productModel;
    Response response = await apiClient.getData('${AppConstants.categoryProductUri}$categoryID?limit=10&offset=$offset&type=$type');
    if (response.statusCode == 200) {
      productModel = ProductModel.fromJson(response.body);
    }
    return productModel;
  }

  @override
  Future<RestaurantModel?> getCategoryRestaurantList(String? categoryID, int offset, String type) async {
    RestaurantModel? restaurantModel;
    Response response = await apiClient.getData('${AppConstants.categoryRestaurantUri}$categoryID?limit=10&offset=$offset&type=$type');
    if (response.statusCode == 200) {
      restaurantModel = RestaurantModel.fromJson(response.body);
    }
    return restaurantModel;
  }

  @override
  Future<Response> getSearchData(String? query, String? categoryID, bool isRestaurant, String type) async {
    return await apiClient.getData(
      '${AppConstants.searchUri}${isRestaurant ? 'restaurants' : 'products'}/search?name=$query&category_id=$categoryID&type=$type&offset=1&limit=50',
    );
  }

  @override
  Future update(Map<String, dynamic> body, int? id) {
    throw UnimplementedError();
  }
}
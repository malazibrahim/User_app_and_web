import 'package:atbrakitchen_multivendor/common/enums/data_source_enum.dart';
import 'package:atbrakitchen_multivendor/features/home/domain/models/advertisement_model.dart';

abstract class AdvertisementServiceInterface {
  Future<List<AdvertisementModel>?> getAdvertisementList({required DataSourceEnum source});
}
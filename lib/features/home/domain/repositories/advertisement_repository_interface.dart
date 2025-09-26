import 'package:atbrakitchen_multivendor/common/enums/data_source_enum.dart';
import 'package:atbrakitchen_multivendor/features/home/domain/models/advertisement_model.dart';
import 'package:atbrakitchen_multivendor/interface/repository_interface.dart';

abstract class AdvertisementRepositoryInterface extends RepositoryInterface{
  @override
  Future<List<AdvertisementModel>?> getList({int? offset, DataSourceEnum? source});
}
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';

abstract interface class IBatchDatasource {
  Future<List<BatchHiveModel>> getAllBatches();
  Future<BatchHiveModel> getBatchById(String batchId);
  Future<bool> createBatch(BatchHiveModel entity);
  Future<bool> updateBatch(BatchHiveModel entity);
  Future<bool> deleteBatch(String batchId);
}

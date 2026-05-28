import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = '${directory.path}/${HiveTableConstant.dbName}';

    Hive.init(path);
    _registerAdapter();
    await openBoxes();
    await insertDummyData();
  }

  Future<void> insertDummyData() async {
    final batchBox = Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);
    if (batchBox.isNotEmpty) return;

    final dummyBatches = [
      BatchHiveModel(batchName: '35-A'),
      BatchHiveModel(batchName: '35-B'),
      BatchHiveModel(batchName: '36-A'),
      BatchHiveModel(batchName: '36-B'),
      BatchHiveModel(batchName: '37-A'),
    ];
    for (var batch in dummyBatches) {
      await batchBox.put(batch.batchId, batch);
    }
    await batchBox.close();
  }

  // Register Adapters
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.batchTypeId)) {
      Hive.registerAdapter(BatchHiveModelAdapter());
    }
  }

  // Open Boxes
  Future<void> openBoxes() async {
    await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchTable);
  }
  // Close Boxes

  Future<void> close() async {
    await Hive.close();
  }

  // Batch Queries

  Box<BatchHiveModel> get _batchBox =>
      Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);

  // Create
  // 1, 34a, Active
  Future<BatchHiveModel> createBatch(BatchHiveModel model) async {
    await _batchBox.put(model.batchId, model);
    return model;
  }

  // getAllBatch
  List<BatchHiveModel> getAllBatches() {
    return _batchBox.values.toList();
  }

  // update
  Future<void> updateBranch(BatchHiveModel model) async {
    await _batchBox.put(model.batchId, model);
  }
}

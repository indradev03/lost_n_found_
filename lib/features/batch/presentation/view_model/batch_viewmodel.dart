import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_state.dart';

final batchViewModelProvider = NotifierProvider<BatchViewModel, BatchState>(
  () => BatchViewModel(),
);

class BatchViewModel extends Notifier<BatchState> {
  late final GetAllBatchUsecase _getAllBatchUsecase;
  late final CreateBatchUsecase _createBatchUsecase;
  late final UpdateBatchUsecase _updateBatchUsecase;

  @override
  BatchState build() {
    // initalize usecases
    _getAllBatchUsecase = ref.read(getAllBatchUsecaseProvider);
    _createBatchUsecase = ref.read(createBatchUsecaseProvider);
    _updateBatchUsecase = ref.read(updateBatchUsecaseProvider);
    return const BatchState();
  }

  Future<void> getAllBatches() async {
    state = state.copyWith(status: BatchStatus.loading);

    // wait for 2 seconds to show the loading state
    await Future.delayed(const Duration(seconds: 2));

    final result = await _getAllBatchUsecase();

    result.fold(
      (left) => state = state.copyWith(
        status: BatchStatus.error,
        errorMessage: left.message,
      ),
      (right) =>
          state = state.copyWith(status: BatchStatus.loaded, batches: right),
    );
  }

  // create batch
  Future<void> createBatch(String batchName) async {
    // progress bar lai ghumauna lai loading ma rakhne
    state = state.copyWith(status: BatchStatus.loading);

    final result = await _createBatchUsecase(
      CreateBatchUsecaseParams(batchName: batchName),
    );

    result.fold(
      (left) => state = state.copyWith(
        status: BatchStatus.error,
        errorMessage: left.message,
      ),
      (right) => state = state.copyWith(status: BatchStatus.loaded),
    );
  }

  // update batch
  Future<void> updateBatch(
    String batchId,
    String batchName,
    String? status,
  ) async {
    state = state.copyWith(status: BatchStatus.loading);

    final result = await _updateBatchUsecase(
      UpdateBatchUsecaseParams(
        batchId: batchId,
        batchName: batchName,
        status: status,
      ),
    );

    result.fold(
      (left) => state = state.copyWith(
        status: BatchStatus.error,
        errorMessage: left.message,
      ),
      (right) => state = state.copyWith(status: BatchStatus.loaded),
    );
  }
}

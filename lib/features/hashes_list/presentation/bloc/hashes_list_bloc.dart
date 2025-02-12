import 'package:bloc/bloc.dart';
import 'package:threedpass/common/logger.dart';
import 'package:threedpass/features/hashes_list/domain/entities/hash_object.dart';
import 'package:threedpass/features/hashes_list/domain/entities/snapshot.dart';
import 'package:threedpass/features/hashes_list/domain/repositories/hashes_repository.dart';

part 'hashes_list_event.dart';
part 'hashes_list_state.dart';

class HashesListBloc extends Bloc<HashesListEvent, HashesListState> {
  HashesListBloc({
    required this.hashesRepository,
  }) : super(HashesListInitial()) {
    on<DeleteHash>(_deleteHash);
    on<DeleteObject>(_deleteObject);
    on<AddObject>(_addObject);
    on<SaveSnapshot>(_saveSnapshot);
    on<ReplaceSnapshot>(_replaceSnapshot);
    on<_LoadHashesList>(_loadList);
  }

  final HashesRepository hashesRepository;

  Future<void> init() async {
    final objects = hashesRepository.getAll();
    add(_LoadHashesList(objects: objects));
  }

  Future<void> _loadList(
    _LoadHashesList event,
    Emitter<HashesListState> emit,
  ) async {
    emit(HashesListLoaded(objects: event.objects));
  }

  Future<void> _deleteHash(
    DeleteHash event,
    Emitter<HashesListState> emit,
  ) async {
    if (state is HashesListLoaded) {
      final list = (state as HashesListLoaded).objects;
      bool f = false;
      for (var obj in list) {
        if (obj.localId == event.object.localId) {
          // if only one snapshot, delete whole object
          if (obj.snapshots.length == 1) {
            add(DeleteObject(object: obj));
            return;
          }
          obj.snapshots.removeWhere(
            (snap) => snap == event.hash,
          );
          f = true;
          break;
        }
      }

      if (!f) {
        logger.e(
          'Not found an object with id=${event.object.localId} name=${event.object.name}',
        );
      } else {
        await hashesRepository.replaceObject(event.object);
      }
      emit(HashesListLoaded(objects: list));
    }
  }

  Future<void> _deleteObject(
    DeleteObject event,
    Emitter<HashesListState> emit,
  ) async {
    await hashesRepository.deleteObject(event.object);

    if (state is HashesListLoaded) {
      final list = (state as HashesListLoaded).objects;
      list.removeWhere((element) => element.localId == event.object.localId);
      emit(HashesListLoaded(objects: list));
    }
  }

  Future<void> _addObject(
    AddObject event,
    Emitter<HashesListState> emit,
  ) async {
    await hashesRepository.addObject(event.object);

    if (state is HashesListLoaded) {
      final list = (state as HashesListLoaded).objects;
      list.add(event.object);
      emit(HashesListLoaded(objects: list));
    }
  }

  Future<void> _saveSnapshot(
    SaveSnapshot event,
    Emitter<HashesListState> emit,
  ) async {
    if (state is HashesListLoaded) {
      final list = (state as HashesListLoaded).objects;
      bool f = false;
      for (var obj in list) {
        if (obj.localId == event.object.localId) {
          obj.snapshots.add(event.hash);
          f = true;
          break;
        }
      }
      if (!f) {
        logger.e(
          'Not found an object with id=${event.object.localId} name=${event.object.name}',
        );
      } else {
        await hashesRepository.replaceObject(event.object);
      }
      emit(HashesListLoaded(objects: list));
    }
  }

  Future<void> _replaceSnapshot(
    ReplaceSnapshot event,
    Emitter<HashesListState> emit,
  ) async {
    if (state is HashesListLoaded) {
      final list = (state as HashesListLoaded).objects;
      bool f = false;
      for (var obj in list) {
        // find object
        if (obj.localId == event.object.localId) {
          // find old snapshot place
          final oldSnapIndex = obj.snapshots.indexOf(event.oldSnapshot);
          // replace it with new one
          if (oldSnapIndex != -1) {
            obj.snapshots[oldSnapIndex] = event.newSnapshot;
            f = true;
          } else {
            logger.e(
              'Not found a snapshot in object ${obj.name}. Old snapshot name=${event.oldSnapshot.name}',
            );
          }
          break;
        }
      }
      if (!f) {
        logger.e(
          'Not found an object with id=${event.object.localId} name=${event.object.name}',
        );
      } else {
        await hashesRepository.replaceObject(event.object);
      }
      emit(HashesListLoaded(objects: list));
    }
  }
}

import 'dart:typed_data';

import 'package:smat_crow/features/domain/repository/firebase_repository.dart';

class UploadImageToStorageUseCase {
  final FirebaseRepository repository;

  UploadImageToStorageUseCase({required this.repository});

  Future<String> call(Uint8List file, bool isPost, String childName) {
    return repository.uploadImageToStorage(
      file,
      isPost,
      childName,
    );
  }
}

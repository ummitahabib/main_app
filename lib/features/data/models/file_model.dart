import 'package:smat_crow/utils2/constants.dart';

class FileModel {
  late List<String> files;
  late String folder;

  FileModel({required this.files, required this.folder});

  FileModel.fromJson(Map<String, dynamic> json) {
    files = json[FileConfig.files].cast<String>();
    folder = json[FileConfig.folderName];
  }
}

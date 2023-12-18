// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:smat_crow/features/data/models/file_model.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({
    Key? key,
    required this.title,
    required this.files,
    required this.folder,
  }) : super(key: key);
  final List<String> files;
  final String folder;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CustomImagePicker> {
  late List<FileModel> files = [];
  late FileModel selectedModel = FileModel(
    files: widget.files,
    folder: widget.folder,
  );
  late String image = emptyString;
  @override
  void initState() {
    super.initState();
    getImagesPath();
  }

  Future<void> getImagesPath() async {
    final imagePath = await StoragePath.imagesPath;
    final images = jsonDecode(imagePath!) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files.isNotEmpty) {
      setState(() {
        selectedModel = files[SpacingConstants.int0];
        image = files[SpacingConstants.int0].files[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.clear),
                    const SizedBox(width: 10),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<FileModel>(
                        items: getItems(),
                        onChanged: (FileModel? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedModel = newValue;
                              image = newValue.files[0];
                            });
                          }
                        },
                        value: selectedModel,
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            ),
            const Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height * SpacingConstants.zeroPoint45,
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      height: MediaQuery.of(context).size.height * SpacingConstants.zeroPoint45,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            const Divider(),
            if (selectedModel.files.isEmpty)
              Container()
            else
              SizedBox(
                height: MediaQuery.of(context).size.height * SpacingConstants.zeroPoint38,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: SpacingConstants.int4,
                    crossAxisSpacing: SpacingConstants.size4,
                    mainAxisSpacing: SpacingConstants.size4,
                  ),
                  itemBuilder: (_, i) {
                    final file = selectedModel.files[i];
                    return GestureDetector(
                      child: Image.file(
                        File(file),
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        setState(() {
                          image = file;
                        });
                      },
                    );
                  },
                  itemCount: selectedModel.files.length,
                ),
              )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<FileModel>> getItems() {
    return files
        .map(
          (e) => DropdownMenuItem<FileModel>(
            value: e,
            child: Text(
              e.folder,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        )
        .toList();
  }
}

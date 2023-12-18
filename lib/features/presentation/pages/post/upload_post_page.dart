import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/presentation/pages/post/widget/upload_post_main_widget.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({Key? key}) : super(key: key);

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  @override
  void initState() {
    super.initState();

    Pandora().getFromSharedPreferences(Const.uid).then((value) async {
      log(value);

      await Provider.of<GetSingleUserProvider>(context, listen: false)
          .getSingleUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider =
        Provider.of<GetSingleUserProvider>(context, listen: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(
          create: (_) => di.locator<PostProvider>(),
        ),
        ChangeNotifierProvider<GetSingleUserProvider>(
          create: (_) => di.locator<GetSingleUserProvider>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          try {
            if (userProvider.user != null) {
              return const UploadPostMainWidget();
            } else {
              return Center(
                child: Container(
                  child: const Text(
                    errorLoadingData,
                  ),
                ),
              );
            }
          } catch (error) {
            return Center(
              child: Container(
                child: const Text(
                  errorLoadingData,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

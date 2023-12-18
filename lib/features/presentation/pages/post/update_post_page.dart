import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/presentation/pages/post/widget/update_post_main_widget.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';

import 'package:smat_crow/utils2/service_locator.dart' as di;

class UpdatePostPage extends StatelessWidget {
  final PostEntity post;

  const UpdatePostPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(
          create: (context) => di.locator<PostProvider>(),
        ),
      ],
      child: UpdatePostMainWidget(
        post: post,
      ),
    );
  }
}

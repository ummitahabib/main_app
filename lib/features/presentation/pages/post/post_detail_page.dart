import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/presentation/pages/post/widget/post_detail_main_widget.dart';
import 'package:smat_crow/features/presentation/provider/post/get_single_post/get_single_post.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';

import 'package:smat_crow/utils2/service_locator.dart' as di;

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GetSinglePostProvider>(
          create: (context) => di.locator<GetSinglePostProvider>(),
        ),
        ChangeNotifierProvider<PostProvider>(
          create: (context) => di.locator<PostProvider>(),
        ),
      ],
      child: PostDetailMainWidget(postId: postId),
    );
  }
}

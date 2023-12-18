import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/app_entity.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/widgets/comment_main_widget.dart';
import 'package:smat_crow/features/presentation/provider/comment_state.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/features/presentation/provider/post/get_single_post/get_single_post.dart';
import 'package:smat_crow/features/presentation/provider/reply_provider.dart';

import 'package:smat_crow/utils2/service_locator.dart' as di;

class CommentPage extends StatelessWidget {
  final AppEntity appEntity;
  const CommentPage({
    Key? key,
    required this.appEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommentProvider>(
          create: (_) => di.locator<CommentProvider>(),
        ),
        ChangeNotifierProvider<GetSingleUserProvider>(
          create: (
            _,
          ) =>
              di.locator<GetSingleUserProvider>(),
        ),
        ChangeNotifierProvider<GetSinglePostProvider>(
          create: (_) => di.locator<GetSinglePostProvider>(),
        ),
        ChangeNotifierProvider<ReplyProvider>(
          create: (_) => di.locator<ReplyProvider>(),
        ),
      ],
      child: CommentMainWidget(
        appEntity: appEntity,
      ),
    );
  }
}

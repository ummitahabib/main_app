import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/comment/comment_entity.dart';
import 'package:smat_crow/features/presentation/provider/comment_state.dart';

import 'package:smat_crow/utils2/service_locator.dart' as di;

import 'widgets/edit_comment_main_widget.dart';

class EditCommentPage extends StatelessWidget {
  final CommentEntity comment;

  const EditCommentPage({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CommentProvider>(
          create: (context) => di.locator<CommentProvider>(),
        )
      ],
      child: EditCommentMainWidget(comment: comment),
    );
  }
}

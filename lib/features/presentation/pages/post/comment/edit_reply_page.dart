import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/reply/reply_entity.dart';
import 'package:smat_crow/features/presentation/pages/post/comment/widgets/edit_reply_main_widget.dart';
import 'package:smat_crow/features/presentation/provider/reply_provider.dart';

import 'package:smat_crow/utils2/service_locator.dart' as di;

class EditReplyPage extends StatelessWidget {
  final ReplyEntity reply;

  const EditReplyPage({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ReplyProvider>(
          create: (context) => di.locator<ReplyProvider>(),
        )
      ],
      child: EditReplyMainWidget(reply: reply),
    );
  }
}

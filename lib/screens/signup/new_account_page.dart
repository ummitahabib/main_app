import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'new_account_data.dart';

class NewAccountPage extends StatefulWidget {
  const NewAccountPage({
    Key? key,
  }) : super(key: key);

  @override
  _NewAccountPageState createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<NewAccountProvider>(context, listen: false).newAccount(context);

    //   Consumer<NewAccountProvider>(
    //   builder: (context, provider, child){
    //     return provider.newAccount(context);
    //   }
    // );
  }
}

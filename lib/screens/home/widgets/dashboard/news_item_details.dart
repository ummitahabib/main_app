import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsItemDetails extends StatefulWidget {
  final String url;

  const NewsItemDetails({super.key, required this.url});

  @override
  _NewsItemDetailsState createState() => _NewsItemDetailsState();
}

class _NewsItemDetailsState extends State<NewsItemDetails> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (finish) {
            setState(() {
              isLoading = false;
            });
          },
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: const Stack(),
          ),
      ],
    );
  }
}

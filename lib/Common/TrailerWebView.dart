import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrailerWebView extends StatefulWidget {
  const TrailerWebView({super.key});

  @override
  State<TrailerWebView> createState() => _TrailerWebViewState();
}

class _TrailerWebViewState extends State<TrailerWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JS 허용
      ..loadRequest(Uri.parse('https://www.youtube.com/embed/SVUGCy4GL7s')); // 유튜브 영상 링크
    // embed만 가능함 / watch 부분을 embed로 바꿔서 사용
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('예고편')),
      body: WebViewWidget(controller: _controller),
    );
  }
}

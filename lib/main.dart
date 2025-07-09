import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clearsay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ClearsayWebView(),
    );
  }
}

class ClearsayWebView extends StatefulWidget {
  const ClearsayWebView({super.key});

  @override
  State<ClearsayWebView> createState() => _ClearsayWebViewState();
}

class _ClearsayWebViewState extends State<ClearsayWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isOffline = false;
  final String homeUrl = 'https://clearsay.co.uk/';

  @override
  void initState() {
    super.initState();
    _checkConnection();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;
            if (url.startsWith('https://clearsay.co.uk')) {
              return NavigationDecision.navigate;
            } else {
              _launchInBrowser(Uri.parse(url));
              return NavigationDecision.prevent;
            }
          },
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() => _isOffline = true),
        ),
      );
  }

  Future<void> _checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final online = connectivityResult != ConnectivityResult.none;

    setState(() {
      _isOffline = !online;
    });

    if (online) {
      _controller.loadRequest(Uri.parse(homeUrl));
    }
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clearsay'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (_isOffline)
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/splash/splash_image.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No internet connection.\nPlease connect and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _checkConnection,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            WebViewWidget(controller: _controller),
          if (_isLoading && !_isOffline)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: !_isOffline
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _controller.loadRequest(Uri.parse(homeUrl));
              },
              icon: const Icon(Icons.home),
              label: const Text('Home'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                if (await _controller.canGoBack()) {
                  _controller.goBack();
                }
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
          ],
        ),
      )
          : null,
    );
  }
}

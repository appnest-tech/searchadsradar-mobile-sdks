import 'package:flutter/material.dart';
import 'package:searchadsradar/searchadsradar.dart';

const _apiKey = String.fromEnvironment('SAR_API_KEY');
const _serverURL = String.fromEnvironment('SAR_SERVER_URL');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SearchAdsRadar.configure(
    apiKey: _apiKey,
    serverURL: _serverURL.isEmpty ? null : _serverURL,
    debug: true,
  );
  runApp(const VerificationApp());
}

class VerificationApp extends StatelessWidget {
  const VerificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    final keyLabel = _apiKey.isEmpty
        ? 'NO KEY - run with --dart-define=SAR_API_KEY=sar_live_...'
        : 'configured: ${_apiKey.length <= 12 ? _apiKey : '${_apiKey.substring(0, 12)}...'}';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('SARKit verification')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(keyLabel),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => SearchAdsRadar.identify('verify-user-1'),
              child: const Text('identify(verify-user-1)'),
            ),
            FilledButton(
              onPressed: () => SearchAdsRadar.track('verify_tap', {
                'string': 'v',
                'int': 1,
                'double': 2.5,
                'bool': true,
              }),
              child: const Text('track(verify_tap)'),
            ),
            FilledButton(
              onPressed: SearchAdsRadar.reset,
              child: const Text('reset()'),
            ),
          ],
        ),
      ),
    );
  }
}

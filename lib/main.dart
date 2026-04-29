// lib/main.dart
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Visibility;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'root.dart';
import './core/util/appsflyer_helper.dart';
import './core/util/admob_manager.dart';
import './presentation/providers/app_state_provider.dart'; 

// AppsFlyerからのeventIdをプロバイダーに設定するためのグローバル変数
late ProviderContainer providerContainer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebaseの初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // AdMobの初期化
  await AdMobManager.instance.initialize();
    
  // 環境変数とMapboxの設定
  await dotenv.load(fileName: '.env');
  final mapboxAccessToken = dotenv.env['MAP_BOX_API_KEY'] ?? '';
  MapboxOptions.setAccessToken(mapboxAccessToken);
  MapboxMapsOptions.setLanguage("ja");
  
  // Riverpodのコンテナを作成
  providerContainer = ProviderContainer();
  
  // AppsFlyerの初期化
  final appsFlyerHelper = AppsFlyerHelper();
  await appsFlyerHelper.init(
    eventIdCallback: (String? eventId) {
      // ディープリンクからeventIdを受け取った場合
      if (eventId != null) {
        debugPrint("AppsFlyerからeventIdを受信: $eventId");
        
        // プロバイダーに値を設定
        providerContainer.read(deepLinkEventIdProvider.notifier).state = eventId;
        providerContainer.read(deepLinkProcessedProvider.notifier).state = false;
      }
    }
  );
  
  runApp(
    UncontrolledProviderScope(
      container: providerContainer,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEADS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RootPage(),
    );
  }
}
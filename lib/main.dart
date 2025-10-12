import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_girok_app/core/theme/theme.dart';
import 'package:flutter_girok_app/firebase_options.dart';
import 'package:flutter_girok_app/presentation/pages/splash/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterLocalization.instance.ensureInitialized();
  FlutterLocalization.instance.init(
    mapLocales: [const MapLocale('ko', {})],
    initLanguageCode: 'ko',
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TODO : 개발용 로그아웃 지우기!!
  // await FirebaseAuth.instance.signOut();

  await dotenv.load(fileName: ".env");

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationsDelegates = <LocalizationsDelegate>[];
    localizationsDelegates.addAll(
      FlutterLocalization.instance.localizationsDelegates,
    );
    localizationsDelegates.add(SfGlobalLocalizations.delegate);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: SplashPage(),
      localizationsDelegates: localizationsDelegates,
      supportedLocales: [const Locale('ko')],
      locale: Locale('ko'),
    );
  }
}

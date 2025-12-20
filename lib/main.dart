import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/game_cubit.dart';
import 'bloc/purchase_cubit.dart';
import 'bloc/locale_cubit.dart';
import 'services/purchase_service.dart';
import 'screens/game_screen.dart';
import 'package:card_love/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize PurchaseService
  final purchaseService = PurchaseService();

  runApp(MyApp(
    prefs: prefs,
    purchaseService: purchaseService,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final PurchaseService purchaseService;

  const MyApp({
    super.key,
    required this.prefs,
    required this.purchaseService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(prefs),
        ),
        BlocProvider<PurchaseCubit>(
          create: (context) => PurchaseCubit(purchaseService, prefs)..initialize(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Love Quest',
            debugShowCheckedModeBanner: false,
            locale: locale,
            // Internationalization support
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fr', ''), // French
              Locale('en', ''), // English
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.pinkAccent,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            home: Builder(
              builder: (context) {
                final currentLocale = Localizations.localeOf(context);
                final purchaseCubit = context.read<PurchaseCubit>();

                return BlocProvider(
                  key: ValueKey(currentLocale.languageCode),
                  create: (context) => GameCubit(
                    purchaseCubit: purchaseCubit,
                    locale: currentLocale,
                  )..initializeGame(),
                  child: const GameScreen(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

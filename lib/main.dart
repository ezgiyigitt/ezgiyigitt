import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'game/brick_up_game.dart';
import 'services/ad_service.dart';
import 'ui/overlays/drop_controls_overlay.dart';
import 'ui/overlays/game_over_dialog.dart';
import 'ui/overlays/how_to_play_dialog.dart';
import 'ui/overlays/hud_overlay.dart';
import 'ui/overlays/victory_dialog.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/level_select_screen.dart';
import 'viewmodels/game_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize AdMob SDK — loads first ads in the background
  await AdService.instance.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => GameViewModel(),
      child: const BrickUpApp(),
    ),
  );
}

class BrickUpApp extends StatelessWidget {
  const BrickUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrickUp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Baloo 2: a plump, rounded cartoon face — the look casual mobile
        // games use for chunky buttons and big friendly headings.
        textTheme: GoogleFonts.baloo2TextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE65100),
          brightness: Brightness.light,
        ),
      ),
      home: const RootNavigator(),
    );
  }
}

class RootNavigator extends StatelessWidget {
  const RootNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = context.select<GameViewModel, AppScreen>((vm) => vm.currentScreen);

    switch (screen) {
      case AppScreen.home:
        return const HomeScreen();
      case AppScreen.howToPlay:
        return const Stack(
          children: [
            HomeScreen(),
            HowToPlayDialog(),
          ],
        );
      case AppScreen.levelSelect:
        return const LevelSelectScreen();
      case AppScreen.playing:
        return const GameScreen();
    }
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final BrickUpGame _game;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<GameViewModel>();
    _game = BrickUpGame(viewModel: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<BrickUpGame>(
        game: _game,
        overlayBuilderMap: {
          'controls': (context, game) => const DropControlsOverlay(),
          'hud': (context, game) => const HudOverlay(),
          'victory': (context, game) => const VictoryDialog(),
          'game_over': (context, game) => const GameOverDialog(),
        },
        initialActiveOverlays: const [
          'controls',
          'hud',
          'victory',
          'game_over',
        ],
      ),
    );
  }
}

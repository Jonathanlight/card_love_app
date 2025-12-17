import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../bloc/game_cubit.dart';
import '../bloc/game_state.dart';
import '../models/card_model.dart';
import '../widgets/game_card_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final CardSwiperController _swiperController = CardSwiperController();
  List<GameCard> _displayCards = [];

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    // Delay to show animation before drawing next card
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<GameCubit>().drawCard();
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<GameCubit, GameState>(
            listener: (context, state) {
              if (state.status == GameStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Une erreur est survenue'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.status == GameStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (state.status == GameStatus.initial) {
                return _buildWelcomeScreen(context);
              }

              if (state.status == GameStatus.finished) {
                return _buildFinishedScreen(context, state);
              }

              if (state.status == GameStatus.playing && state.currentCard != null) {
                // Create a list with current card for swiper
                _displayCards = [state.currentCard!];

                return Column(
                  children: [
                    _buildHeader(state),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: CardSwiper(
                            controller: _swiperController,
                            cardsCount: _displayCards.length,
                            onSwipe: _onSwipe,
                            numberOfCardsDisplayed: 1,
                            backCardOffset: const Offset(0, 0),
                            padding: const EdgeInsets.all(24.0),
                            cardBuilder: (
                              context,
                              index,
                              horizontalThresholdPercentage,
                              verticalThresholdPercentage,
                            ) {
                              return GameCardWidget(
                                card: _displayCards[index],
                                width: MediaQuery.of(context).size.width * 0.85,
                                height: MediaQuery.of(context).size.height * 0.6,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    _buildBottomControls(context, state),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite,
            size: 100,
            color: Colors.pinkAccent,
          ),
          const SizedBox(height: 24),
          const Text(
            'CARD LOVE',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Découvrez-vous autrement avec des questions\nqui rapprochent les cœurs',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 60),
          _buildLegend(),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              context.read<GameCubit>().startGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
            child: const Text(
              'COMMENCER LE JEU',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildLegendItem(
            color: const Color(0xFFE53935),
            label: 'Questions Sexy',
            icon: Icons.whatshot,
          ),
          const SizedBox(height: 12),
          _buildLegendItem(
            color: const Color(0xFF1E88E5),
            label: 'Vie de Couple',
            icon: Icons.favorite,
          ),
          const SizedBox(height: 12),
          _buildLegendItem(
            color: const Color(0xFF212121),
            label: 'Infidélité',
            icon: Icons.warning_amber,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(GameState state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CARD LOVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Swipe pour la prochaine carte',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${state.remainingCards}/${state.totalCards}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, GameState state) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.close,
            color: Colors.red,
            onPressed: () {
              _showEndGameDialog(context);
            },
          ),
          _buildControlButton(
            icon: Icons.refresh,
            color: Colors.orange,
            onPressed: () {
              context.read<GameCubit>().newGame();
            },
          ),
          _buildControlButton(
            icon: Icons.arrow_forward,
            color: Colors.green,
            onPressed: state.hasCardsLeft
                ? () {
                    _swiperController.swipe(CardSwiperDirection.right);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        elevation: 8,
      ),
      child: Icon(icon, size: 32),
    );
  }

  Widget _buildFinishedScreen(BuildContext context, GameState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.celebration,
            size: 100,
            color: Colors.amber,
          ),
          const SizedBox(height: 24),
          const Text(
            'PARTIE TERMINÉE',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Vous avez tiré ${state.drawnCards.length} cartes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: () {
              context.read<GameCubit>().newGame();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
            child: const Text(
              'NOUVELLE PARTIE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEndGameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Terminer le jeu?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Voulez-vous vraiment terminer le jeu?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('ANNULER'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GameCubit>().endGame();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('TERMINER'),
          ),
        ],
      ),
    );
  }
}

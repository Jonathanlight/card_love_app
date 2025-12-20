import 'package:flutter/material.dart';
import 'package:card_love/l10n/generated/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.aboutTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App icon/logo
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Introduction
                      Text(
                        l10n.rulesIntro,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Game Rules Section
                      _buildSectionTitle(l10n.gameRules),
                      const SizedBox(height: 16),
                      _buildSubSectionTitle(l10n.rulesHowToPlay),
                      const SizedBox(height: 12),
                      _buildRuleStep(l10n.rulesStep1),
                      _buildRuleStep(l10n.rulesStep2),
                      _buildRuleStep(l10n.rulesStep3),
                      _buildRuleStep(l10n.rulesStep4),
                      _buildRuleStep(l10n.rulesStep5),
                      const SizedBox(height: 24),

                      // Card Types Section
                      _buildSectionTitle(l10n.cardTypes),
                      const SizedBox(height: 16),
                      _buildCardType(l10n.cardTypeHot),
                      _buildCardType(l10n.cardTypeCouple),
                      _buildCardType(l10n.cardTypeTabou),
                      _buildCardType(l10n.cardTypeFun),
                      const SizedBox(height: 24),

                      // Tips Section
                      _buildSectionTitle(l10n.tips),
                      const SizedBox(height: 16),
                      _buildTip(l10n.tip1),
                      _buildTip(l10n.tip2),
                      _buildTip(l10n.tip3),
                      _buildTip(l10n.tip4),
                      const SizedBox(height: 48),

                      // Developer signature
                      Center(
                        child: Column(
                          children: [
                            Divider(
                              color: Colors.white.withOpacity(0.2),
                              thickness: 1,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.developer,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.developerName,
                              style: const TextStyle(
                                color: Colors.pinkAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.developerTitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.pinkAccent,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRuleStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildCardType(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }
}

# Card Love - Jeu de Cartes pour Couples

Une application Flutter interactive de questions pour couples avec 3 niveaux de cartes.

## Caractéristiques

- **30 cartes au total** réparties en 3 catégories:
  - 🔴 **Cartes Rouges** (10) - Questions sexy et intimes
  - 🔵 **Cartes Bleues** (10) - Questions sur la vie de couple
  - ⚫ **Cartes Noires** (10) - Questions sur l'infidélité

- **Animation de swipe** fluide pour tirer les cartes
- **Gestion d'état avec Bloc/Cubit** pour une architecture propre
- **Interface moderne** avec des dégradés et animations
- **Aucune carte dupliquée** - chaque carte ne peut être tirée qu'une fois par partie
- **Système de jeu complet** avec possibilité de terminer ou relancer

## Structure du Projet

```
lib/
├── bloc/
│   ├── game_cubit.dart      # Gestion de l'état du jeu
│   └── game_state.dart      # États du jeu
├── models/
│   ├── card_model.dart      # Modèle de données des cartes
│   └── card_service.dart    # Service de chargement des cartes
├── screens/
│   └── game_screen.dart     # Écran principal du jeu
├── widgets/
│   └── game_card_widget.dart # Widget d'affichage des cartes
└── main.dart                 # Point d'entrée de l'app

assets/
└── data/
    └── cards.json           # Fichier JSON des questions
```

## Modifier les Questions

Toutes les questions sont stockées dans le fichier `assets/data/cards.json`. Vous pouvez facilement les modifier ou en ajouter de nouvelles.

### Format JSON

```json
{
  "cards": [
    {
      "id": 1,
      "type": "red",
      "question": "Votre question ici"
    }
  ]
}
```

### Types de Cartes

- `"red"` - Cartes rouges (questions sexy)
- `"blue"` - Cartes bleues (vie de couple)
- `"black"` - Cartes noires (infidélité)

### Exemple de Modification

Pour ajouter une nouvelle carte rouge:

```json
{
  "id": 31,
  "type": "red",
  "question": "Quelle est ta nouvelle question sexy?"
}
```

**Important**: Assurez-vous que chaque carte a un ID unique!

## Installation et Exécution

### Prérequis

- Flutter SDK (version 3.10.4 ou supérieure)
- Dart SDK

### Installation

1. Clonez ou téléchargez le projet

2. Installez les dépendances:
```bash
flutter pub get
```

3. Lancez l'application:
```bash
flutter run
```

## Dépendances Utilisées

- **flutter_bloc** ^8.1.3 - Gestion d'état
- **equatable** ^2.0.5 - Comparaison d'objets
- **flutter_card_swiper** ^7.0.1 - Animation de swipe

## Comment Jouer

1. **Écran d'accueil**: Appuyez sur "COMMENCER LE JEU"

2. **Tirer une carte**:
   - Swipez la carte vers la droite ou la gauche
   - Ou utilisez le bouton flèche verte

3. **Contrôles disponibles**:
   - ❌ Bouton rouge: Terminer le jeu
   - 🔄 Bouton orange: Nouvelle partie
   - ➡️ Bouton vert: Passer à la carte suivante

4. **Fin du jeu**:
   - Le jeu se termine automatiquement après toutes les cartes
   - Vous pouvez lancer une nouvelle partie à tout moment

## Personnalisation

### Changer les Couleurs des Cartes

Modifiez les gradients dans `lib/models/card_model.dart`:

```dart
LinearGradient getCardGradient() {
  switch (type) {
    case CardType.red:
      return const LinearGradient(
        colors: [Color(0xFFFF6B6B), Color(0xFFE53935), Color(0xFFC62828)],
      );
    // ...
  }
}
```

### Ajouter des Images PNG

Pour utiliser vos propres images de fond de carte:

1. Ajoutez vos images dans `assets/images/`
2. Modifiez le widget `GameCardWidget` dans `lib/widgets/game_card_widget.dart`
3. Remplacez le `Container` avec gradient par un `Image.asset()`

Exemple:
```dart
decoration: BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/${card.type.name}_card.png'),
    fit: BoxFit.cover,
  ),
)
```

## Fonctionnalités Techniques

### Gestion d'État avec Bloc

L'application utilise le pattern Bloc/Cubit:

- **GameState**: Contient l'état actuel du jeu
  - Cartes disponibles
  - Cartes déjà tirées
  - Carte actuelle
  - Statut du jeu

- **GameCubit**: Gère la logique du jeu
  - `initializeGame()`: Charge les cartes depuis le JSON
  - `startGame()`: Démarre une nouvelle partie
  - `drawCard()`: Tire une carte aléatoire
  - `newGame()`: Réinitialise le jeu
  - `endGame()`: Termine la partie

### Système Anti-Doublons

Chaque carte tirée est retirée de la liste des cartes disponibles et ajoutée à la liste des cartes tirées. Cela garantit qu'une carte ne peut pas être tirée deux fois dans la même partie.

## Support et Contribution

Pour toute question ou suggestion d'amélioration, n'hésitez pas à ouvrir une issue ou proposer une pull request.

## Licence

Ce projet est libre d'utilisation pour un usage personnel ou commercial.

---

**Amusez-vous bien et profitez de moments de complicité!** ❤️

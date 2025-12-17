# Guide des Images - Card Love

## Structure des Images

Le jeu utilise **3 images PNG** comme fond de cartes, une pour chaque type:

```
assets/images/
├── card_red.png    → Fond pour les 10 cartes rouges (questions sexy)
├── card_blue.png   → Fond pour les 10 cartes bleues (vie de couple)
└── card_black.png  → Fond pour les 10 cartes noires (infidélité)
```

## Comment ça marche

### Attribution Automatique

Chaque carte dans le JSON a un champ `"image"` qui pointe vers l'image correspondante selon son type:

```json
{
  "id": 1,
  "type": "red",
  "question": "Votre question ici",
  "image": "assets/images/card_red.png"
}
```

### Affichage des Cartes

Les cartes sont affichées avec:
1. **L'image PNG en fond** (couverture complète avec `BoxFit.cover`)
2. **Un overlay sombre** (30-50% d'opacité) pour améliorer la lisibilité du texte
3. **Un motif décoratif** léger par-dessus
4. **Le texte de la question** centré en blanc

### Fallback Automatique

Si une image ne peut pas être chargée, le système utilise automatiquement un **dégradé de couleur** correspondant au type de carte:

- **Rouge**: Dégradé de #FF6B6B → #E53935 → #C62828
- **Bleu**: Dégradé de #42A5F5 → #1E88E5 → #1565C0
- **Noir**: Dégradé de #424242 → #212121 → #000000

## Personnalisation des Images

### Remplacer les Images Existantes

Pour personnaliser vos cartes, remplacez simplement les fichiers PNG dans `assets/images/`:

1. Créez vos nouvelles images (recommandé: 800x1200px minimum)
2. Nommez-les exactement:
   - `card_red.png`
   - `card_blue.png`
   - `card_black.png`
3. Placez-les dans `assets/images/`
4. Relancez l'application

### Recommandations pour les Images

**Dimensions recommandées:**
- Largeur: 800-1200px
- Hauteur: 1200-1800px
- Ratio: 2:3 (format portrait)
- Format: PNG avec transparence possible

**Design:**
- Utilisez des couleurs qui correspondent au thème (rouge, bleu, noir)
- Laissez de l'espace au centre pour le texte de la question
- Évitez les détails trop fins (l'overlay sombre sera appliqué)
- Testez la lisibilité du texte blanc sur votre image

### Ajouter des Images Uniques par Carte

Si vous voulez une image différente pour **chaque carte** (30 images au total):

1. Créez 30 images PNG avec des noms uniques:
   ```
   red_card_1.png, red_card_2.png, ..., red_card_10.png
   blue_card_1.png, blue_card_2.png, ..., blue_card_10.png
   black_card_1.png, black_card_2.png, ..., black_card_10.png
   ```

2. Modifiez le fichier `assets/data/cards.json` pour chaque carte:
   ```json
   {
     "id": 1,
     "type": "red",
     "question": "Votre question",
     "image": "assets/images/red_card_1.png"
   }
   ```

3. Assurez-vous que toutes les images sont dans `assets/images/`

## Modifier l'Overlay

Si vos images sont trop sombres ou trop claires, vous pouvez ajuster l'overlay dans `lib/widgets/game_card_widget.dart`:

```dart
// Dark overlay for better text readability
Positioned.fill(
  child: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.3),  // Changez cette valeur (0.0 à 1.0)
          Colors.black.withOpacity(0.5),  // Changez cette valeur (0.0 à 1.0)
        ],
      ),
    ),
  ),
),
```

**Valeurs suggérées:**
- Images claires: 0.4 - 0.6
- Images moyennes: 0.3 - 0.5 (défaut)
- Images sombres: 0.1 - 0.3

## Résolution de Problèmes

### Image ne s'affiche pas

1. Vérifiez que le fichier existe dans `assets/images/`
2. Vérifiez le nom exact (sensible à la casse)
3. Assurez-vous que `pubspec.yaml` contient:
   ```yaml
   assets:
     - assets/images/
   ```
4. Relancez `flutter pub get`
5. Redémarrez l'application (hot reload ne suffit pas pour les assets)

### Image pixelisée

Utilisez des images haute résolution (minimum 800x1200px)

### Texte illisible

Augmentez l'opacité de l'overlay ou utilisez une image moins chargée

## Structure du Code

**Modèle de carte** (`lib/models/card_model.dart`):
```dart
class GameCard {
  final String? image;  // Chemin vers l'image PNG
}
```

**Widget de carte** (`lib/widgets/game_card_widget.dart`):
```dart
Image.asset(
  card.image!,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    // Fallback vers gradient si erreur
  },
)
```

## Exemples de Styles

### Style Romantique
- Utilisez des textures douces (rose, rouge pastel)
- Motifs de cœurs ou fleurs

### Style Moderne
- Dégradés géométriques
- Couleurs vives et contrastées

### Style Élégant
- Textures marbrées ou velours
- Couleurs profondes et riches

---

**Note**: Les images actuelles (`card_red.png`, `card_blue.png`, `card_black.png`) sont déjà configurées et prêtes à l'emploi!

# Mise à jour des cartes de boutique avec images et noms de types

## ✅ Modifications effectuées

### 1. Ajout du champ `imagePath` au modèle Pack

**Fichier**: `lib/models/pack_model.dart`

- Ajouté le champ `imagePath` pour stocker le chemin de l'image de chaque pack
- Mis à jour la liste `props` pour inclure `imagePath`

### 2. Configuration des images pour chaque pack

**Fichier**: `lib/constants/pack_constants.dart`

Ajout des chemins d'images pour les 4 packs:

| Pack | Image | Chemin |
|------|-------|--------|
| Pack Hot | card_hot.png | `assets/images/card_hot.png` |
| Pack Couple | card_couple_long_time.png | `assets/images/card_couple_long_time.png` |
| Pack Tabou | card_tabou.png | `assets/images/card_tabou.png` |
| Pack Fun | card_fun.png | `assets/images/card_fun.png` |

### 3. Mise à jour du widget PackCardWidget

**Fichier**: `lib/widgets/pack_card_widget.dart`

**Ajouts**:

1. **Image de la carte** (lignes 42-84):
   - Affichage de l'image du pack en haut de la carte
   - Dimensions: 120px de hauteur × 80px de largeur
   - Coins arrondis (12px)
   - Fallback vers l'icône si l'image n'est pas trouvée

2. **Label du type de carte** (lignes 72-81):
   - Affiche le nom du type sous l'image:
     - "Question Sexy" pour Hot
     - "Vie de Couple" pour Couple
     - "Infidélité" pour Tabou
     - "Question Fun" pour Fun
   - Texte semi-transparent avec letterspacing

3. **Méthode `_getCardTypeName()`** (lignes 285-296):
   - Retourne le nom localisé du type de carte
   - Utilise les clés de localisation existantes

## 🎨 Résultat visuel

Chaque carte de pack dans la boutique affiche maintenant:

```
┌─────────────────────────┐
│   [Image de la carte]   │  ← 120×80px, card_hot.png
│    "Question Sexy"       │  ← Nom du type
│                          │
│  🔥 Pack Hot             │  ← Icône + Nom
│                          │
│  Questions ultra         │  ← Description
│  intimes et sensuelles   │
│                          │
│  [50 cartes]             │  ← Badge nombre
│                          │
│  0,99€      [ACHETER]    │  ← Prix + Bouton
└─────────────────────────┘
```

## 📋 Images vérifiées

Toutes les images requises existent dans `assets/images/`:

```bash
✅ card_hot.png (18.7 KB)
✅ card_couple_long_time.png (26.8 KB)
✅ card_tabou.png (21.1 KB)
✅ card_fun.png (20.6 KB)
```

Les images sont déjà déclarées dans `pubspec.yaml` via:
```yaml
assets:
  - assets/images/
```

## 🔄 Flow d'affichage

1. **ShopScreen** charge la liste des packs
2. Pour chaque pack, **PackCardWidget** est créé
3. Le widget charge l'image depuis `pack.imagePath`
4. Si l'image existe → Affichée avec `Image.asset()`
5. Si l'image manque → Fallback vers l'icône du pack
6. Le label du type est récupéré via `_getCardTypeName()`
7. Le texte est localisé (français/anglais)

## 🌍 Localisation

Les noms de types utilisent les clés de localisation existantes:

| Type | Français | English |
|------|----------|---------|
| Hot | Question Sexy | Sexy Question |
| Couple | Vie de Couple | Couple Life |
| Tabou | Infidélité | Infidelity |
| Fun | Question Fun | Fun Question |

Définis dans:
- `lib/l10n/app_fr.arb` (lignes 209-227)
- `lib/l10n/app_en.arb` (lignes 209-227)

## 🧪 Comment tester

1. **Lancer l'app**:
   ```bash
   flutter run
   ```

2. **Accéder à la boutique**:
   - Cliquer sur le bouton "panier" en haut à droite

3. **Vérifier les cartes**:
   - ✅ Pack Hot → Image rouge avec flamme
   - ✅ Pack Couple → Image bleue avec cœur
   - ✅ Pack Tabou → Image noire avec triangle
   - ✅ Pack Fun → Image jaune/orange avec étoile

4. **Vérifier les labels**:
   - Sous chaque image: "Question Sexy", "Vie de Couple", etc.
   - En français par défaut
   - Changer de langue → Labels en anglais

5. **Tester le fallback**:
   - Si une image manque, l'icône du pack s'affiche à la place

## 📐 Dimensions et style

### Image de la carte
- **Hauteur**: 120px
- **Largeur**: 80px
- **Fit**: cover (couvre tout le container)
- **Border radius**: 12px

### Label du type
- **Font size**: 13px
- **Font weight**: 600 (semi-bold)
- **Couleur**: Blanc avec 95% d'opacité
- **Letter spacing**: 0.5px

### Icône (si image manque)
- **Size**: 48px
- **Couleur**: Blanc
- **Background**: Blanc 20% d'opacité

## 🔧 Structure du code

### Pack Model
```dart
class Pack {
  final String imagePath;  // Nouveau champ
  // ... autres champs
}
```

### PackCardWidget - Section image
```dart
// Image preview
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.asset(
    pack.imagePath,
    height: 120,
    width: 80,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      // Fallback vers icône
      return Container(...);
    },
  ),
)

// Type label
Text(
  _getCardTypeName(l10n, pack),
  style: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Colors.white.withOpacity(0.95),
  ),
)
```

### Méthode de récupération du nom
```dart
String _getCardTypeName(AppLocalizations l10n, Pack pack) {
  switch (pack.type) {
    case PackType.hot:
      return l10n.questionSexy;
    case PackType.couple:
      return l10n.vieDeCouple;
    case PackType.tabou:
      return l10n.infidelite;
    case PackType.fun:
      return l10n.questionFun;
  }
}
```

## ✅ Checklist de test

- [ ] Les 4 images s'affichent correctement dans la boutique
- [ ] Pack Hot → Image rouge "card_hot.png"
- [ ] Pack Couple → Image bleue "card_couple_long_time.png"
- [ ] Pack Tabou → Image noire "card_tabou.png"
- [ ] Pack Fun → Image jaune "card_fun.png"
- [ ] Les labels de types s'affichent sous les images
- [ ] Les labels sont en français par défaut
- [ ] Changer de langue → Labels en anglais
- [ ] Si une image manque, l'icône s'affiche
- [ ] Les images ont les bonnes dimensions (120×80)
- [ ] Le style général de la carte est cohérent

## 🎯 Résumé des changements

| Fichier | Modification | Lignes |
|---------|--------------|--------|
| `pack_model.dart` | Ajout champ `imagePath` | 20, 31, 80 |
| `pack_constants.dart` | Configuration des images | 29, 40, 51, 62 |
| `pack_card_widget.dart` | Affichage image + label type | 42-84, 285-296 |

**Total**: 3 fichiers modifiés, ~60 lignes ajoutées

---

**Les cartes de boutique affichent maintenant les images et les noms des types!** 🎨✅

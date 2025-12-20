# Guide - Mode Test et Changement de Langue

## 🔧 Problèmes Corrigés

### 1. ✅ Changement de langue des cartes
**Problème**: Au clic sur le bouton de langue, les cartes ne changeaient pas de langue.

**Solution**: Ajout d'une clé (`key: ValueKey(currentLocale.languageCode)`) au `BlocProvider` du `GameCubit` dans `main.dart`. Cela force Flutter à recréer le `GameCubit` avec la nouvelle locale quand la langue change.

**Fichier modifié**: `lib/main.dart` ligne 85

**Comment ça marche**:
1. L'utilisateur clique sur 🇫🇷 ou 🇬🇧
2. `LocaleCubit` émet la nouvelle locale
3. `MaterialApp` est reconstruit
4. La clé change (de 'fr' à 'en' ou vice versa)
5. Flutter détruit l'ancien `GameCubit` et en crée un nouveau
6. Le nouveau `GameCubit` charge les cartes du bon fichier JSON

---

### 2. ✅ Test des achats in-app sans configuration des stores
**Problème**: Impossible de tester les achats in-app avec `flutter run --debug` car les produits ne sont pas configurés dans Google Play Console / App Store Connect.

**Solution**: Ajout d'un **mode test** dans `PurchaseCubit` qui simule les achats localement sans connexion aux stores.

**Fichier modifié**: `lib/bloc/purchase_cubit.dart`

---

## 🧪 Mode Test

### Activation/Désactivation

Dans `lib/bloc/purchase_cubit.dart` ligne 21:

```dart
// TEST MODE: Set to true to bypass IAP and test UI locally
static const bool _testMode = true;  // ← Changez cette valeur
```

- **`_testMode = true`**: Mode test activé (par défaut)
  - Aucune connexion aux stores
  - Achats simulés localement
  - Parfait pour développement et tests UI

- **`_testMode = false`**: Mode production
  - Connexion aux stores Google/Apple
  - Achats réels
  - Nécessite configuration dans les stores

### Fonctionnalités en Mode Test

#### ✅ Ce qui fonctionne:
- ✅ Interface boutique complète
- ✅ Achat de packs (simulé avec délai de 1 seconde)
- ✅ Filtrage des cartes selon packs possédés
- ✅ Restauration des achats (depuis SharedPreferences)
- ✅ Détection utilisateur legacy
- ✅ Sauvegarde persistante des achats

#### ⚠️ Limites:
- ⚠️ Pas de prix affichés (les produits du store ne sont pas chargés)
- ⚠️ Pas de validation par les stores Apple/Google
- ⚠️ Les achats ne sont stockés que localement

### Comment Tester

1. **Activer le mode test** (déjà fait par défaut):
   ```dart
   static const bool _testMode = true;
   ```

2. **Lancer l'app**:
   ```bash
   flutter run
   ```

3. **Tester le flow complet**:
   - Ouvrir la boutique (bouton panier en haut à droite)
   - Cliquer sur "Acheter" pour un pack
   - Voir le loading pendant 1 seconde
   - Le pack devient "Possédé"
   - Retourner au jeu
   - Les nouvelles cartes du pack sont maintenant accessibles

4. **Tester le changement de langue**:
   - Sur l'écran d'accueil, cliquer sur 🇫🇷 ou 🇬🇧
   - L'interface change immédiatement
   - Commencer le jeu
   - Les cartes sont dans la langue sélectionnée

5. **Tester la restauration**:
   - Cliquer sur "Restaurer les achats"
   - Les achats locaux sont rechargés
   - Voir un message de confirmation

### Retour au Mode Production

Quand vous êtes prêt à tester avec les vrais stores:

1. **Configurer les produits**:
   - Google Play Console: créer 4 produits in-app
   - App Store Connect: créer 4 achats in-app
   - Utiliser les IDs définis dans `pack_constants.dart`

2. **Désactiver le mode test**:
   ```dart
   static const bool _testMode = false;
   ```

3. **Build et upload**:
   ```bash
   # Android
   flutter build appbundle
   # Upload vers Google Play (Internal Testing)

   # iOS
   flutter build ios
   # Upload vers TestFlight
   ```

4. **Tester avec comptes sandbox**:
   - Android: Ajouter testeurs dans Google Play Console
   - iOS: Créer comptes sandbox dans App Store Connect

---

## 📱 Tests Recommandés

### Test 1: Changement de langue
- [ ] Démarrer l'app en français
- [ ] Cliquer sur 🇬🇧 English
- [ ] Vérifier que l'interface passe en anglais
- [ ] Commencer le jeu
- [ ] Tirer une carte → doit être en anglais
- [ ] Retourner à l'accueil
- [ ] Cliquer sur 🇫🇷 Français
- [ ] Commencer le jeu
- [ ] Tirer une carte → doit être en français

### Test 2: Achat de pack (mode test)
- [ ] Ouvrir la boutique
- [ ] Noter les 4 packs disponibles
- [ ] Acheter le "Pack Hot"
- [ ] Voir le loading
- [ ] Le pack devient "Possédé"
- [ ] Retourner au jeu
- [ ] Vérifier que de nouvelles cartes rouges sont disponibles
- [ ] Compter le total de cartes disponibles

### Test 3: Persistance
- [ ] Acheter un pack
- [ ] Fermer complètement l'app
- [ ] Relancer l'app
- [ ] Ouvrir la boutique
- [ ] Vérifier que le pack est toujours "Possédé"
- [ ] Jouer → les cartes du pack sont toujours accessibles

### Test 4: Restauration
- [ ] Acheter 2-3 packs
- [ ] Cliquer sur "Restaurer les achats"
- [ ] Vérifier le message de confirmation
- [ ] Tous les packs achetés sont toujours marqués "Possédé"

---

## 🐛 Dépannage

### Les cartes ne changent pas de langue
- Vérifiez que vous retournez bien à l'écran d'accueil pour changer de langue
- Le changement de langue recrée le GameCubit, donc le jeu redémarre

### "Store not available" en mode production
- Normal si `_testMode = false` et que les produits ne sont pas configurés
- Solution: activer le mode test OU configurer les stores

### Les achats ne persistent pas
- Vérifiez que vous n'avez pas effacé les données de l'app
- En mode test, les achats sont stockés dans SharedPreferences
- Désinstaller/réinstaller l'app efface les achats en mode test

### Impossible de tester les paiements réels
- Les paiements réels nécessitent:
  1. Produits configurés dans Google Play Console / App Store Connect
  2. App uploadée vers Internal Testing (Android) ou TestFlight (iOS)
  3. Comptes testeurs configurés
  4. Mode test désactivé (`_testMode = false`)

---

## 📝 Notes Importantes

### Mode Test vs Mode Production

| Fonctionnalité | Mode Test | Mode Production |
|----------------|-----------|-----------------|
| Connexion IAP | ❌ Non | ✅ Oui |
| Prix affichés | ❌ Non | ✅ Oui |
| Achats simulés | ✅ Oui (1s) | ❌ Non |
| Achats réels | ❌ Non | ✅ Oui |
| Configuration stores | ❌ Non requis | ✅ Requis |
| Stockage | Local only | Store + Local |
| Validation | Aucune | Par store |

### Avant la Release

**N'OUBLIEZ PAS** de désactiver le mode test avant la release:

```dart
// Dans lib/bloc/purchase_cubit.dart
static const bool _testMode = false;  // ⚠️ IMPORTANT
```

Sinon, les utilisateurs ne pourront pas faire d'achats réels!

---

## ✅ Résumé

Les deux problèmes sont maintenant corrigés:

1. **✅ Changement de langue**: Fonctionne parfaitement, les cartes se rechargent dans la bonne langue
2. **✅ Test des achats**: Mode test activé par défaut, vous pouvez tester toute l'interface sans configurer les stores

Pour développer et tester, gardez `_testMode = true`.

Quand vous serez prêt pour la production, mettez `_testMode = false` et configurez les stores.

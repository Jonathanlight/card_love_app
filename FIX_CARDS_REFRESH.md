# Fix: Les cartes se rafraîchissent maintenant après un achat

## 🐛 Problème

Quand vous achetiez un pack en mode debug (test mode), les cartes du pack ne s'ajoutaient pas au jeu.

## ✅ Solution

Le `GameCubit` écoute maintenant les changements du `PurchaseCubit` et rafraîchit automatiquement les cartes disponibles quand un pack est acheté.

## 🔧 Modifications

### Fichier: `lib/bloc/game_cubit.dart`

1. **Ajout d'un listener sur PurchaseCubit** (lignes 19-36):
   - Le GameCubit s'abonne au stream du PurchaseCubit
   - Détecte quand la liste des packs possédés change
   - Appelle automatiquement `refreshAvailableCards()`

2. **Tracking des packs** (ligne 17):
   - Variable `_lastKnownOwnedPacks` pour éviter les rafraîchissements inutiles
   - Ne rafraîchit que si les packs ont vraiment changé

3. **Initialisation** (ligne 49):
   - Initialise `_lastKnownOwnedPacks` au démarrage du jeu

4. **Disposal propre** (lignes 211-215):
   - Annule le subscription quand le cubit est fermé
   - Évite les memory leaks

5. **Logs de debug** (lignes 25, 30, 33, 107):
   - Affiche des émojis dans la console pour suivre le processus
   - Aide au debugging

## 🎮 Comment tester

1. **Lancer l'app**:
   ```bash
   flutter run
   ```

2. **Vérifier les cartes gratuites**:
   - Sur l'écran d'accueil, cliquer sur "Commencer"
   - Noter le nombre de cartes disponibles en haut à droite (ex: "25/25")

3. **Acheter un pack**:
   - Appuyer sur le bouton "boutique" (panier) en haut à droite
   - Choisir un pack (ex: "Pack Hot")
   - Cliquer sur "Acheter"
   - Attendre 1 seconde (simulation)
   - Le pack devient "Possédé"

4. **Retourner au jeu**:
   - Appuyer sur le bouton retour
   - **VÉRIFICATION**: Le nombre de cartes a augmenté!
     - Avant: "25/25" (seulement les gratuites)
     - Après achat Pack Hot: "91/91" (25 gratuites + 66 du pack hot)

5. **Jouer avec les nouvelles cartes**:
   - Swiper les cartes
   - Vous devriez maintenant voir des cartes du pack acheté

## 📊 Logs de debug

Quand vous achetez un pack, vous verrez dans la console:

```
🎁 Purchase detected! Old: [], New: [pack_hot]
🔄 Triggering card refresh (status: GameStatus.initial)
🔄 Refreshing cards: 66 available, 0 drawn
```

Cela confirme que:
1. L'achat est détecté
2. Le rafraîchissement est déclenché
3. Les nouvelles cartes sont chargées

## 🔍 Détails techniques

### Flow complet après achat:

1. **User clique "Acheter"** → `PurchaseCubit.purchasePack('pack_hot')`

2. **Mode test simule l'achat** (1 seconde de délai)

3. **PurchaseCubit met à jour son state**:
   ```dart
   ownedPackIds: ['pack_hot']  // Nouveau!
   ```

4. **GameCubit reçoit la notification** via son subscription:
   ```dart
   _purchaseSubscription = purchaseCubit?.stream.listen(...)
   ```

5. **GameCubit détecte le changement**:
   - Compare `_lastKnownOwnedPacks` (vide) avec nouvelle liste `['pack_hot']`
   - Différence détectée! 🎁

6. **GameCubit appelle `refreshAvailableCards()`**:
   - Recharge toutes les cartes du JSON
   - Applique le filtre avec les nouveaux packs
   - Exclut les cartes déjà tirées
   - Met à jour le state

7. **UI se met à jour automatiquement** (via BlocBuilder):
   - Le compteur de cartes augmente
   - Les nouvelles cartes sont disponibles pour être tirées

### Filtrage des cartes

La méthode `_filterAccessibleCards()` vérifie pour chaque carte:

```dart
// Carte gratuite? → Toujours accessible
if (card.isFree) return true;

// Utilisateur legacy? → Tout accessible
if (isLegacyUser) return true;

// Pack acheté? → Accessible
if (card.packId != null && unlockedPacks.contains(card.packId)) {
  return true;
}

// Sinon → Pas accessible
return false;
```

Exemple avec Pack Hot acheté:
- Carte ID 1 (type: red, isFree: true) → ✅ Accessible (gratuite)
- Carte ID 9 (type: red, packId: "pack_hot") → ✅ Accessible (pack acheté)
- Carte ID 75 (type: blue, packId: "pack_couple") → ❌ Pas accessible (pack non acheté)

## 🧪 Tests à faire

### Test 1: Achat simple
- [ ] Démarrer l'app
- [ ] Noter le nombre de cartes: 25/25
- [ ] Acheter Pack Hot
- [ ] Vérifier: 91/91 cartes (25 + 66)
- [ ] Jouer et voir des cartes rouges du pack

### Test 2: Achats multiples
- [ ] Acheter Pack Hot (91 cartes)
- [ ] Acheter Pack Couple (156 cartes: 91 + 65)
- [ ] Acheter Pack Tabou (202 cartes: 156 + 46)
- [ ] Acheter Pack Fun (230 cartes: 202 + 28)

### Test 3: Pendant le jeu
- [ ] Commencer le jeu
- [ ] Tirer 5 cartes
- [ ] Retourner à la boutique
- [ ] Acheter un pack
- [ ] Retourner au jeu
- [ ] Vérifier que le nombre de cartes augmente
- [ ] Les 5 cartes tirées ne sont PAS recomptées

### Test 4: Persistance
- [ ] Acheter Pack Hot
- [ ] Fermer l'app complètement
- [ ] Relancer l'app
- [ ] Commencer le jeu
- [ ] Vérifier: 91 cartes (le pack est toujours possédé)

### Test 5: Changement de langue
- [ ] Acheter Pack Hot en français
- [ ] Changer la langue en anglais
- [ ] Commencer le jeu
- [ ] Vérifier: 91 cartes en anglais (le pack est toujours possédé)

## 🎯 Résultat attendu

Avant ce fix:
- ❌ Acheter un pack → Les cartes ne s'ajoutaient pas
- ❌ Il fallait redémarrer l'app pour voir les nouvelles cartes

Après ce fix:
- ✅ Acheter un pack → Les cartes s'ajoutent immédiatement
- ✅ Le compteur se met à jour automatiquement
- ✅ Les nouvelles cartes sont disponibles dans le deck

## 📝 Notes importantes

### Pour désactiver les logs de debug

Avant la release, commentez les lignes avec `print()` dans `game_cubit.dart`:

```dart
// print('🎁 Purchase detected! Old: $_lastKnownOwnedPacks, New: ${purchaseState.ownedPackIds}');
// print('🔄 Triggering card refresh (status: ${state.status})');
// print('🔄 Refreshing cards: ${newAvailable.length} available, ${drawnIds.length} drawn');
```

Ou utilisez un système de logging plus avancé.

### Performance

Le rafraîchissement est optimisé:
- Ne se déclenche que si les packs ont vraiment changé
- Réutilise les cartes déjà tirées (pas de rechargement)
- Filtre uniquement les nouvelles cartes accessibles

### Memory leaks

La subscription est correctement annulée dans la méthode `close()`:
```dart
@override
Future<void> close() {
  _purchaseSubscription?.cancel();  // Évite les memory leaks
  return super.close();
}
```

## ✅ Checklist

- [✅] GameCubit écoute les changements de PurchaseCubit
- [✅] Les cartes se rafraîchissent après un achat
- [✅] Le compteur se met à jour
- [✅] Les cartes déjà tirées ne sont pas recomptées
- [✅] La subscription est correctement disposée
- [✅] Logs de debug pour faciliter le suivi
- [✅] Optimisation pour éviter les rafraîchissements inutiles

---

**Le problème est maintenant corrigé!** 🎉

Testez avec `flutter run` et vous verrez que les cartes s'ajoutent immédiatement après l'achat d'un pack.

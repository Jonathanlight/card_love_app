# Guide de Publication sur Google Play - Love Quest

## ✅ Étapes Complétées

Votre application **Love Quest** est maintenant prête pour la publication sur Google Play Store !

### Ce qui a été fait :

1. **Keystore créé** : `android/love-quest-key.jks`
   - Alias: `love-quest`
   - Validité: 10,000 jours (~27 ans)
   - ⚠️ **IMPORTANT** : Gardez ce fichier en sécurité et ne le perdez jamais !

2. **Configuration de signature**
   - Fichier `android/key.properties` créé avec les informations de signature
   - `android/app/build.gradle.kts` configuré pour la signature release

3. **Package ID mis à jour** : `com.lovequest.app`

4. **Android App Bundle (AAB) construit** :
   - Fichier: `build/app/outputs/bundle/release/app-release.aab`
   - Taille: 44.9MB
   - ✅ Signé et prêt pour la publication

## 📱 Prochaines Étapes pour Publier sur Google Play

### 1. Créer un Compte Google Play Developer

1. Allez sur [Google Play Console](https://play.google.com/console)
2. Payez les frais d'inscription unique de **99 USD**
3. Complétez votre profil de développeur

### 2. Créer une Nouvelle Application

1. Dans la Play Console, cliquez sur "**Créer une application**"
2. Sélectionnez la langue par défaut : **Français**
3. Nom de l'application : **Love Quest**
4. Type : **Application**
5. Catégorie : **Divertissement** ou **Style de vie**

### 3. Préparer les Ressources Requises

Vous aurez besoin de :

#### Icône de l'application
- Format: PNG
- Taille: 512 x 512 pixels
- Fond transparent ou couleur unie

#### Bannière de fonctionnalité
- Format: PNG ou JPG
- Taille: 1024 x 500 pixels

#### Captures d'écran (minimum 2, maximum 8)
- **Téléphone** :
  - Minimum: 320px
  - Maximum: 3840px
  - Ratio d'aspect: 16:9 à 9:16
- Recommandé: 1080 x 1920 pixels ou 1080 x 2340 pixels

#### Descriptions
- **Titre court** (max 30 caractères):
  ```
  Love Quest - Questions Couples
  ```

- **Description courte** (max 80 caractères):
  ```
  Découvrez-vous autrement avec des questions qui rapprochent les cœurs
  ```

- **Description complète** (max 4000 caractères):
  ```
  Love Quest est une application interactive conçue pour les couples qui souhaitent approfondir leur relation à travers des questions engageantes et amusantes.

  🎮 FONCTIONNALITÉS :

  • Trois catégories de questions :
    - Questions Sexy 🔥
    - Vie de Couple 💕
    - Infidélité ⚠️

  • Interface intuitive avec système de swipe
  • Sauvegardez vos questions favorites ⭐
  • Partagez vos questions préférées
  • Design moderne et élégant

  💑 PARFAIT POUR :

  • Les nouveaux couples qui veulent mieux se connaître
  • Les couples établis qui cherchent à raviver la flamme
  • Les soirées en amoureux
  • Les moments d'intimité et de connexion

  🎯 COMMENT JOUER :

  1. Swipez pour découvrir une nouvelle question
  2. Répondez honnêtement avec votre partenaire
  3. Sauvegardez vos questions favorites
  4. Partagez celles qui vous ont marqués

  Love Quest transforme vos conversations en moments mémorables et renforce votre complicité.

  Téléchargez maintenant et commencez votre quête d'amour ! 💕
  ```

### 4. Télécharger l'AAB

1. Dans la Play Console, allez dans **Production** > **Versions**
2. Cliquez sur "**Créer une version**"
3. Téléchargez le fichier AAB :
   ```
   build/app/outputs/bundle/release/app-release.aab
   ```
4. Suivez les instructions pour compléter la version

### 5. Remplir les Informations Obligatoires

#### Confidentialité
- Créez une politique de confidentialité (obligatoire)
- Hébergez-la sur un site web accessible publiquement

#### Classification du contenu
- Remplissez le questionnaire de classification
- Catégorie suggérée : **Teens** (13+) ou **Mature** (17+) selon le contenu

#### Public cible
- Groupe d'âge : **13 ans et plus** ou **18 ans et plus**

#### Coordonnées
- Adresse e-mail pour le support utilisateur

### 6. Soumettre pour Révision

1. Vérifiez que tous les éléments requis sont complétés (✓)
2. Cliquez sur "**Examiner la version**"
3. Cliquez sur "**Commencer le déploiement en production**"

### 7. Délai de Publication

- **Première révision** : 1 à 7 jours
- **Mises à jour** : Généralement 24 à 48 heures

## 🔐 Sécurité du Keystore

**⚠️ TRÈS IMPORTANT ⚠️**

Le fichier `android/love-quest-key.jks` est **ESSENTIEL** :

- Sans ce fichier, vous ne pourrez **JAMAIS** mettre à jour votre application
- Faites des **sauvegardes** sur plusieurs supports (cloud, disque dur externe, etc.)
- Ne le partagez **JAMAIS** publiquement
- Ne le commitez **PAS** dans Git

### Informations du Keystore

- **Fichier** : `android/love-quest-key.jks`
- **Alias** : `love-quest`
- **Mot de passe du store** : `lovequest2024`
- **Mot de passe de la clé** : `lovequest2024`

⚠️ Conservez ces informations dans un endroit sûr (gestionnaire de mots de passe).

## 📊 Versions Futures

Pour créer une nouvelle version :

1. Mettez à jour la version dans `android/app/build.gradle.kts` :
   ```kotlin
   versionCode = 2  // Incrémentez de 1
   versionName = "1.0.1"  // Version lisible
   ```

2. Reconstruisez l'AAB :
   ```bash
   flutter build appbundle --release
   ```

3. Téléchargez le nouveau AAB dans la Play Console

## 💡 Conseils Supplémentaires

- **Optimisation ASO** : Utilisez des mots-clés pertinents dans le titre et la description
- **Répondez aux avis** : Engagez-vous avec vos utilisateurs
- **Tests bêta** : Utilisez la piste de test interne/bêta avant la production
- **Analytics** : Intégrez Firebase Analytics pour suivre l'utilisation

## 🆘 Support

Si vous rencontrez des problèmes :

1. Consultez la [documentation Google Play](https://support.google.com/googleplay/android-developer)
2. Vérifiez les [politiques du Play Store](https://play.google.com/about/developer-content-policy/)
3. Contactez le support Google Play Console

---

**Bonne chance avec la publication de Love Quest ! 🚀💕**

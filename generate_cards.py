#!/usr/bin/env python3
import json

# Read original cards.json
with open('assets/data/cards.json', 'r', encoding='utf-8') as f:
    data = json.load(f)
    cards = data['cards']

# Separate by type
red_cards = [c for c in cards if c['type'] == 'red']
blue_cards = [c for c in cards if c['type'] == 'blue']
black_cards = [c for c in cards if c['type'] == 'black']

print(f"Original: {len(red_cards)} red, {len(blue_cards)} blue, {len(black_cards)} black")

# Mark free cards (select mildest questions from each type)
# We'll mark the first few as free for simplicity
# Red: 8 free, rest in pack_hot
# Blue: 10 free, rest in pack_couple
# Black: 5 black, rest in pack_tabou

# Process red cards
for i, card in enumerate(red_cards):
    card['packId'] = None if i < 8 else 'pack_hot'
    card['isFree'] = i < 8

# Process blue cards
for i, card in enumerate(blue_cards):
    card['packId'] = None if i < 10 else 'pack_couple'
    card['isFree'] = i < 10

# Process black cards
for i, card in enumerate(black_cards):
    card['packId'] = None if i < 5 else 'pack_tabou'
    card['isFree'] = i < 5

# Combine back
all_cards = red_cards + blue_cards + black_cards

# Re-assign IDs sequentially
for i, card in enumerate(all_cards, 1):
    card['id'] = i

# Add 30 new fun cards (in French)
fun_questions_fr = [
    "Si tu pouvais avoir un super-pouvoir pour 24h, lequel choisirais-tu?",
    "Quelle est la chose la plus embarrassante qui te soit arrivée en public?",
    "Si tu devais vivre dans une autre époque, laquelle choisirais-tu?",
    "Quel est le mensonge le plus stupide que tu as dit et auquel on a cru?",
    "Si tu pouvais inviter 3 personnes (vivantes ou mortes) à dîner, qui seraient-elles?",
    "Quelle est la chose la plus folle que tu aies faite sous l'influence de l'alcool?",
    "Si tu gagnais au loto demain, quelle serait la première chose que tu achèterais?",
    "Quel est ton guilty pleasure (plaisir coupable) que peu de gens connaissent?",
    "Si tu devais changer de prénom, lequel choisirais-tu?",
    "Quelle est la pire blague que tu aies jamais racontée?",
    "Si tu pouvais être invisible pendant une journée, que ferais-tu?",
    "Quel est ton pire rendez-vous Tinder/date en ligne?",
    "Si tu devais manger la même chose tous les jours pour le reste de ta vie, ce serait quoi?",
    "Quelle célébrité aimerais-tu rencontrer et pourquoi?",
    "Quel est le surnom le plus ridicule qu'on t'ait donné?",
    "Si tu pouvais lire dans les pensées de quelqu'un pendant 1h, qui choisirais-tu?",
    "Quelle est ta danse la plus embarrassante quand personne ne regarde?",
    "Si tu devais participer à une émission de téléréalité, laquelle choisirais-tu?",
    "Quel est le pire film que tu aies regardé jusqu'au bout?",
    "Si tu pouvais échanger de vie avec quelqu'un pour une semaine, qui choisirais-tu?",
    "Quelle est la chose la plus bizarre que tu aies mangée?",
    "Si tu avais un animal de compagnie exotique, ce serait quoi?",
    "Quel est ton karaoké signature (chanson que tu chantes toujours)?",
    "Si tu devais te faire tatouer quelque chose maintenant, ce serait quoi?",
    "Quelle est ta pire habitude dont tu n'es pas fier(ère)?",
    "Si tu pouvais maîtriser un instrument de musique instantanément, lequel choisirais-tu?",
    "Quel est le plus grand risque que tu aies pris dans ta vie?",
    "Si tu devais vivre dans un film ou série, lequel choisirais-tu?",
    "Quelle est la chose la plus spontanée que tu aies faite?",
    "Si tu pouvais avoir une conversation avec ton moi de 10 ans, que lui dirais-tu?"
]

# Add fun cards
for i, question in enumerate(fun_questions_fr, 1):
    fun_card = {
        "id": len(all_cards) + i,
        "type": "fun",
        "question": question,
        "image": "assets/images/card_fun.png",
        "packId": None if i <= 2 else "pack_fun",  # First 2 are free
        "isFree": i <= 2
    }
    all_cards.append(fun_card)

# Save cards_fr.json
with open('assets/data/cards_fr.json', 'w', encoding='utf-8') as f:
    json.dump({"cards": all_cards}, f, ensure_ascii=False, indent=2)

print(f"✓ Created cards_fr.json with {len(all_cards)} cards")
print(f"  Free: {sum(1 for c in all_cards if c['isFree'])} cards")
print(f"  Pack Hot: {sum(1 for c in all_cards if c['packId'] == 'pack_hot')} cards")
print(f"  Pack Couple: {sum(1 for c in all_cards if c['packId'] == 'pack_couple')} cards")
print(f"  Pack Tabou: {sum(1 for c in all_cards if c['packId'] == 'pack_tabou')} cards")
print(f"  Pack Fun: {sum(1 for c in all_cards if c['packId'] == 'pack_fun')} cards")

# Create English version with placeholders
cards_en = []
for card in all_cards:
    card_en = card.copy()
    card_en['question'] = "TODO: User will provide English translation"
    cards_en.append(card_en)

# Save cards_en.json
with open('assets/data/cards_en.json', 'w', encoding='utf-8') as f:
    json.dump({"cards": cards_en}, f, ensure_ascii=False, indent=2)

print(f"✓ Created cards_en.json with {len(cards_en)} cards (placeholders for translation)")

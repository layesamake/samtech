# Accessibilité

| Élément | Valeur |
|---|---|
| Statut | Exigences minimales de la Starter |
| Version | 1.0 |
| Date | 14 juillet 2026 |

## 1. Objectif

Rendre les parcours essentiels utilisables par des personnes ayant des limitations visuelles, motrices ou cognitives, ainsi que dans des conditions réelles : petit écran, soleil, fatigue, faible maîtrise numérique ou téléphone lent.

## 2. Perception visuelle

- Contraste conforme aux niveaux AA applicables pour textes et composants.
- Aucun statut dépendant uniquement de la couleur.
- Texte redimensionnable sans masquer l'action principale.
- Valeurs financières affichées avec suffisamment d'espace et sans troncature silencieuse.
- Graphiques accompagnés de valeurs ou d'une liste accessible.

## 3. Interaction

- Cibles tactiles d'au moins 48 points logiques lorsque possible.
- Espacement suffisant entre actions opposées, notamment enregistrer et annuler.
- Aucun geste complexe obligatoire ; toute action par balayage possède une alternative visible.
- Le délai d'une action n'expire pas sans possibilité de prolongation lorsque cela est pertinent.

## 4. Lecteurs d'écran

- Ordre de lecture identique à l'ordre visuel logique.
- Libellés complets pour icônes, statuts, montants et progression.
- Les changements importants sont annoncés sans répéter toute la page.
- Une ligne de contact est annoncée comme une unité avec nom, statut et prochaine action.
- Les graphiques ont une description et un accès aux données détaillées.

## 5. Saisie

- Chaque champ possède un libellé persistant.
- Les erreurs identifient le champ et la correction attendue.
- Le clavier correspond au type de donnée.
- La saisie ne dépend pas uniquement d'un masque strict incompatible avec les habitudes locales.
- Les formulaires conservent les valeurs après une erreur.

## 6. Compréhension

- Une phrase courte explique les conséquences d'une action sensible.
- Les termes métier restent constants : prospect, client, relance, facture, paiement.
- Les états calculés sont expliqués lorsque nécessaire.
- Les messages WhatsApp indiquent explicitement que l'envoi est effectué dans l'application externe.
- Les écrans vides proposent une prochaine action claire.

## 7. Mouvement et temps

- Respect de la préférence de réduction de mouvement.
- Pas de clignotement ni animation répétitive.
- Une animation ne porte jamais seule une information.
- Les indicateurs de progression proposent un texte lorsque l'opération dépasse une courte durée.

## 8. Tests requis

- Android TalkBack et iOS VoiceOver sur les parcours P0 ;
- tailles de texte standard et très grande ;
- contraste clair et sombre si le thème sombre est livré ;
- navigation avec clavier sur les environnements qui la supportent ;
- test manuel avec une seule main ;
- audit des messages d'erreur et confirmations sensibles.

## 9. Critère de sortie

Aucun parcours P0 ne peut être considéré terminé si l'utilisateur ne peut pas identifier le contrôle principal, comprendre une erreur, atteindre l'action suivante ou connaître le résultat avec les technologies d'assistance prises en charge.


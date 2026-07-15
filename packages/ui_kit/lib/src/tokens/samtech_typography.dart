import 'package:flutter/material.dart';

/// Tokens typographiques SAMTECH.
///
/// Utilise la police système de chaque plateforme dans la V1.
/// Conformes à `docs/04_DESIGN/DESIGN_SYSTEM.md`.
abstract final class SamtechTypography {
  /// Chiffre principal exceptionnel — 32/700.
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  /// Titre d'écran — 24/700.
  static const TextStyle title1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  /// Section majeure — 20/600.
  static const TextStyle title2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  /// Carte ou sous-section — 17/600.
  static const TextStyle title3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  /// Contenu principal — 16/400.
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// Métadonnées lisibles — 14/400.
  static const TextStyle bodyCompact = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Boutons et champs — 14/600.
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// Aide secondaire — 12/400.
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}

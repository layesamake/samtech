import 'package:flutter/material.dart';

/// Tokens de couleurs SAMTECH.
///
/// Conformes au design system documenté dans `docs/04_DESIGN/DESIGN_SYSTEM.md`.
/// Les couleurs de marque restent proposées tant que l'identité SAMTECH
/// n'est pas officiellement approuvée.
abstract final class SamtechColors {
  // ── Couleurs de marque ──────────────────────────────────────────────

  /// Navigation, action principale (clair).
  static const Color primaryLight = Color(0xFF174A7E);

  /// Navigation, action principale (sombre).
  static const Color primaryDark = Color(0xFF8FC8FF);

  /// Contenu sur primaire (clair).
  static const Color onPrimaryLight = Color(0xFFFFFFFF);

  /// Contenu sur primaire (sombre).
  static const Color onPrimaryDark = Color(0xFF002F52);

  /// Accent, succès commercial (clair).
  static const Color secondaryLight = Color(0xFF007C78);

  /// Accent, succès commercial (sombre).
  static const Color secondaryDark = Color(0xFF6EDBD4);

  /// Contenu sur secondaire (clair).
  static const Color onSecondaryLight = Color(0xFFFFFFFF);

  /// Contenu sur secondaire (sombre).
  static const Color onSecondaryDark = Color(0xFF003735);

  // ── Surfaces neutres ────────────────────────────────────────────────

  /// Fond de page (clair).
  static const Color canvasLight = Color(0xFFF6F8FB);

  /// Fond de page (sombre).
  static const Color canvasDark = Color(0xFF101418);

  /// Surface de base (clair).
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Surface de base (sombre).
  static const Color surfaceDark = Color(0xFF181C20);

  /// Surface élevée (clair).
  static const Color raisedLight = Color(0xFFFFFFFF);

  /// Surface élevée (sombre).
  static const Color raisedDark = Color(0xFF20252A);

  /// Surface subtile (clair).
  static const Color subtleLight = Color(0xFFEDF2F7);

  /// Surface subtile (sombre).
  static const Color subtleDark = Color(0xFF293038);

  /// Bordure par défaut (clair).
  static const Color borderLight = Color(0xFFCBD5E1);

  /// Bordure par défaut (sombre).
  static const Color borderDark = Color(0xFF46515C);

  // ── Texte ───────────────────────────────────────────────────────────

  /// Texte principal (clair).
  static const Color textPrimaryLight = Color(0xFF16202A);

  /// Texte principal (sombre).
  static const Color textPrimaryDark = Color(0xFFF1F5F9);

  /// Texte secondaire (clair).
  static const Color textSecondaryLight = Color(0xFF526170);

  /// Texte secondaire (sombre).
  static const Color textSecondaryDark = Color(0xFFB8C2CC);

  /// Texte désactivé (clair).
  static const Color textDisabledLight = Color(0xFF8A98A6);

  /// Texte désactivé (sombre).
  static const Color textDisabledDark = Color(0xFF788590);

  // ── Couleurs sémantiques ────────────────────────────────────────────

  /// Paiement réussi, sauvegarde réussie.
  static const Color success = Color(0xFF18794E);

  /// Grâce de licence, échéance proche.
  static const Color warning = Color(0xFF9A6700);

  /// Erreur, retard, action destructive.
  static const Color danger = Color(0xFFB42318);

  /// Information et synchronisation future.
  static const Color info = Color(0xFF175CD3);
}

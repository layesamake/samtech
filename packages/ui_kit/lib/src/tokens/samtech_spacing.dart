/// Tokens d'espacement SAMTECH.
///
/// Base de 4 points, conformes à `docs/04_DESIGN/DESIGN_SYSTEM.md`.
abstract final class SamtechSpacing {
  /// 4 points logiques.
  static const double space1 = 4;

  /// 8 points logiques.
  static const double space2 = 8;

  /// 12 points logiques.
  static const double space3 = 12;

  /// 16 points logiques — marge d'écran téléphone.
  static const double space4 = 16;

  /// 20 points logiques.
  static const double space5 = 20;

  /// 24 points logiques — marge d'écran large.
  static const double space6 = 24;

  /// 32 points logiques.
  static const double space8 = 32;

  /// 40 points logiques.
  static const double space10 = 40;

  /// 48 points logiques — cible tactile minimale.
  static const double space12 = 48;

  /// Marge d'écran par défaut sur téléphone.
  static const double screenMarginPhone = space4;

  /// Marge d'écran par défaut sur grand écran.
  static const double screenMarginLarge = space6;
}

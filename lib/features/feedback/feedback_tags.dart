import '../../l10n/app_localizations.dart';

/// The review "pills", Airbnb-style: a short, fixed vocabulary so answers
/// aggregate cleanly. Ids are the stored value and never change; labels
/// are localized at display time.
///
/// Two sets, picked by the rating: a happy player is asked what worked, an
/// unhappy one what to fix. Both end in "Other" so the comment field has
/// a reason to exist.
abstract final class FeedbackTags {
  static const positive = [
    'easy_scoring',
    'rules_helpful',
    'looks_great',
    'fast',
    'stats_fun',
    'share_card',
    'other',
  ];

  static const improvement = [
    'confusing',
    'missing_feature',
    'bug',
    'too_many_taps',
    'rules_unclear',
    'translation',
    'other',
  ];

  /// Ratings of 4 and 5 count as positive; 3 and below ask what to fix.
  static List<String> forRating(int? rating) =>
      rating != null && rating >= 4 ? positive : improvement;

  static String label(AppLocalizations l10n, String id) => switch (id) {
    'easy_scoring' => l10n.tagEasyScoring,
    'rules_helpful' => l10n.tagRulesHelpful,
    'looks_great' => l10n.tagLooksGreat,
    'fast' => l10n.tagFast,
    'stats_fun' => l10n.tagStatsFun,
    'share_card' => l10n.tagShareCard,
    'confusing' => l10n.tagConfusing,
    'missing_feature' => l10n.tagMissingFeature,
    'bug' => l10n.tagBug,
    'too_many_taps' => l10n.tagTooManyTaps,
    'rules_unclear' => l10n.tagRulesUnclear,
    'translation' => l10n.tagTranslation,
    _ => l10n.tagOther,
  };
}

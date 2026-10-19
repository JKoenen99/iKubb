/// System-independent feedback event (SPEC: "rich, portable data").
///
/// One flat JSON document per moment the app asked for feedback, whether
/// the player answered or dismissed. The shape is the contract: it is what
/// the local outbox stores, what the Supabase sink posts, and what any
/// future backend receives unchanged. Breaking changes bump
/// [FeedbackEvent.schemaVersion]; additive context fields do not.
///
/// Every field is a primitive or a string-keyed map of primitives so the
/// document loads into Postgres `jsonb`, BigQuery, a spreadsheet, or a
/// `jq` pipeline without a transformation step. Timestamps are ISO 8601 in
/// UTC. Tags are stable snake_case ids, never the localized labels.
library;

/// Where in the journey the prompt was shown.
enum FeedbackTrigger {
  /// End of a game or match, on the win overlay.
  gameEnd,

  /// Last card of the "Teach me the game" tour.
  tourEnd,

  /// The always-available row in Settings.
  settings,
}

/// What the player did with the prompt.
enum FeedbackResponse { submitted, dismissed }

class FeedbackEvent {
  const FeedbackEvent({
    required this.eventId,
    required this.installId,
    required this.occurredAt,
    required this.trigger,
    required this.response,
    this.rating,
    this.tags = const [],
    this.comment,
    required this.locale,
    required this.appVersion,
    required this.buildNumber,
    required this.platform,
    required this.osVersion,
    this.storeReviewRequested = false,
    this.context = const {},
  }) : assert(rating == null || (rating >= 1 && rating <= 5));

  /// Version of this document shape.
  static const int schemaVersion = 1;

  /// Longest comment stored (and enforced by the UI).
  static const int maxCommentLength = 300;

  /// UUID v4, unique per event; the idempotency key for any sink.
  final String eventId;

  /// UUID v4 generated once per installation (reset on reinstall). It is
  /// the only identifier: no account, no name, no device identifier.
  final String installId;
  final DateTime occurredAt;
  final FeedbackTrigger trigger;
  final FeedbackResponse response;

  /// 1–5, null when dismissed.
  final int? rating;

  /// Stable tag ids from [FeedbackTags]; never localized text.
  final List<String> tags;

  /// Free text, trimmed, ≤ [maxCommentLength]; null when empty.
  final String? comment;

  /// BCP 47 language tag the UI was showing.
  final String locale;
  final String appVersion;
  final String buildNumber;

  /// `ios`, `android`, `web`, `macos`, ...
  final String platform;
  final String osVersion;

  /// Whether this event led to the native store-review prompt.
  final bool storeReviewRequested;

  /// Trigger-specific facts (game mode, players, throws, ...). Flat map of
  /// primitives so it stays queryable as JSON.
  final Map<String, Object?> context;

  Map<String, Object?> toJson() => {
    'schema_version': schemaVersion,
    'event_id': eventId,
    'install_id': installId,
    'occurred_at': occurredAt.toUtc().toIso8601String(),
    'trigger': triggerName(trigger),
    'response': response.name,
    'rating': rating,
    'tags': tags,
    'comment': comment,
    'locale': locale,
    'app_version': appVersion,
    'build_number': buildNumber,
    'platform': platform,
    'os_version': osVersion,
    'store_review_requested': storeReviewRequested,
    'context': context,
  };

  factory FeedbackEvent.fromJson(Map<String, Object?> json) => FeedbackEvent(
    eventId: json['event_id'] as String,
    installId: json['install_id'] as String,
    occurredAt: DateTime.parse(json['occurred_at'] as String),
    trigger: FeedbackTrigger.values.byName(_camel(json['trigger'] as String)),
    response: FeedbackResponse.values.byName(json['response'] as String),
    rating: (json['rating'] as num?)?.toInt(),
    tags: [for (final t in (json['tags'] as List?) ?? const []) t as String],
    comment: json['comment'] as String?,
    locale: json['locale'] as String,
    appVersion: json['app_version'] as String,
    buildNumber: json['build_number'] as String,
    platform: json['platform'] as String,
    osVersion: json['os_version'] as String,
    storeReviewRequested: json['store_review_requested'] as bool? ?? false,
    context: ((json['context'] as Map?) ?? const {}).cast<String, Object?>(),
  );

  FeedbackEvent copyWith({bool? storeReviewRequested}) => FeedbackEvent(
    eventId: eventId,
    installId: installId,
    occurredAt: occurredAt,
    trigger: trigger,
    response: response,
    rating: rating,
    tags: tags,
    comment: comment,
    locale: locale,
    appVersion: appVersion,
    buildNumber: buildNumber,
    platform: platform,
    osVersion: osVersion,
    storeReviewRequested: storeReviewRequested ?? this.storeReviewRequested,
    context: context,
  );

  /// The stored (snake_case) name of a trigger: `game_end`, `tour_end`,
  /// `settings`.
  static String triggerName(FeedbackTrigger trigger) => trigger.name
      .replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

  static String _camel(String snake) =>
      snake.replaceAllMapped(RegExp('_([a-z])'), (m) => m[1]!.toUpperCase());
}

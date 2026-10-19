import 'dart:convert';

import 'package:http/http.dart' as http;

import 'feedback_event.dart';

/// Where feedback goes after the local outbox. A sink receives the
/// system-independent JSON document and reports whether it was accepted;
/// the repository marks accepted events as synced and retries the rest.
abstract class FeedbackSink {
  /// True when every event was accepted (the caller marks them synced).
  Future<bool> send(List<FeedbackEvent> events);
}

/// No backend configured: events stay in the local outbox (and remain
/// exportable). This is what tests and the web preview run with.
class NoopFeedbackSink implements FeedbackSink {
  const NoopFeedbackSink();

  @override
  Future<bool> send(List<FeedbackEvent> events) async => false;
}

/// Supabase via its plain PostgREST endpoint — no SDK, no lock-in beyond
/// a URL and a publishable (anon) key. The table stores the full document as `jsonb`
/// plus a few extracted columns for SQL (see supabase/migrations). Row
/// Level Security lets the anon key INSERT only; it can never read back.
///
/// Configure at build time:
///   flutter build ipa --dart-define=SUPABASE_URL=https://xyz.supabase.co \
///                     --dart-define=SUPABASE_ANON_KEY=eyJ...
class SupabaseFeedbackSink implements FeedbackSink {
  SupabaseFeedbackSink({
    required this.projectUrl,
    required this.anonKey,
    this.table = 'feedback_events',
    http.Client? client,
  }) : _client = client ?? http.Client();

  static const _envUrl = String.fromEnvironment('SUPABASE_URL');
  static const _envKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// The sink the build was configured for, or the no-op when the
  /// dart-defines are absent.
  static FeedbackSink fromEnvironment({http.Client? client}) =>
      _envUrl.isEmpty || _envKey.isEmpty
      ? const NoopFeedbackSink()
      : SupabaseFeedbackSink(
          projectUrl: _envUrl,
          anonKey: _envKey,
          client: client,
        );

  final String projectUrl;
  final String anonKey;
  final String table;
  final http.Client _client;

  /// One request per event (volumes are tiny), so a single duplicate
  /// never fails a whole batch. A 409 means the row is already there —
  /// a retry after a lost response — and counts as delivered. The app key
  /// has INSERT only, so `ON CONFLICT` (which needs SELECT) is not used.
  @override
  Future<bool> send(List<FeedbackEvent> events) async {
    for (final event in events) {
      if (!await _sendOne(event)) return false;
    }
    return true;
  }

  Future<bool> _sendOne(FeedbackEvent event) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$projectUrl/rest/v1/$table'),
            headers: {
              'apikey': anonKey,
              // A legacy anon key is a JWT and doubles as the bearer token;
              // a modern publishable key (sb_publishable_...) must not.
              if (anonKey.startsWith('eyJ')) 'Authorization': 'Bearer $anonKey',
              'Content-Type': 'application/json',
              'Prefer': 'return=minimal',
            },
            body: jsonEncode(_row(event)),
          )
          .timeout(const Duration(seconds: 10));
      final code = response.statusCode;
      return (code >= 200 && code < 300) || code == 409;
    } on Object {
      return false; // offline, DNS, timeout: the outbox keeps it
    }
  }

  /// One row: the whole document in `payload`, and the fields worth a
  /// column of their own for indexing and GROUP BY.
  static Map<String, Object?> _row(FeedbackEvent e) => {
    'event_id': e.eventId,
    'install_id': e.installId,
    'occurred_at': e.occurredAt.toUtc().toIso8601String(),
    'trigger': FeedbackEvent.triggerName(e.trigger),
    'response': e.response.name,
    'rating': e.rating,
    'tags': e.tags,
    'comment': e.comment,
    'locale': e.locale,
    'app_version': e.appVersion,
    'platform': e.platform,
    'payload': e.toJson(),
  };
}

import 'call_contact.dart';

/// Response of `GET /list/{id}`.
class ListDetails {
  final int pending;
  final int called;
  final int rescheduled;
  final List<CallContact> calls;

  const ListDetails({
    required this.pending,
    required this.called,
    required this.rescheduled,
    required this.calls,
  });

  int get total => pending + called + rescheduled;

  static int _int(dynamic v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;

  factory ListDetails.fromJson(Map<String, dynamic> json) => ListDetails(
        pending: _int(json['pending']),
        called: _int(json['called']),
        rescheduled: _int(json['rescheduled']),
        calls: (json['calls'] is List ? json['calls'] as List : const [])
            .whereType<Map>()
            .map((e) => CallContact.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}

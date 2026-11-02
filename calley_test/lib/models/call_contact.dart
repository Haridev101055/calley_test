/// A single contact inside a list's `calls` array.
/// Only FirstName / LastName are guaranteed by the docs, so every other
/// field is parsed defensively.
class CallContact {
  final String firstName;
  final String lastName;
  final String? phone;
  final String? status;
  final Map<String, dynamic> raw;

  const CallContact({
    required this.firstName,
    required this.lastName,
    this.phone,
    this.status,
    this.raw = const {},
  });

  String get fullName {
    final n = '$firstName $lastName'.trim();
    return n.isEmpty ? 'Unknown' : n;
  }

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    final s = (f + l).toUpperCase();
    return s.isEmpty ? '?' : s;
  }

  static String? _pick(Map<String, dynamic> j, List<String> keys) {
    for (final k in keys) {
      final v = j[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return null;
  }

  factory CallContact.fromJson(Map<String, dynamic> json) => CallContact(
        firstName: (json['FirstName'] ?? json['firstName'] ?? '').toString(),
        lastName: (json['LastName'] ?? json['lastName'] ?? '').toString(),
        phone: _pick(json, ['Phone', 'phone', 'Mobile', 'mobile', 'Number', 'number']),
        status: _pick(json, ['Status', 'status']),
        raw: json,
      );
}

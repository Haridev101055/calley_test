/// A call list returned by `GET /list?userId=...`.
class CallList {
  final String id;
  final String name;
  final List<dynamic> agents;
  final String clientId;

  const CallList({
    required this.id,
    required this.name,
    required this.agents,
    required this.clientId,
  });

  factory CallList.fromJson(Map<String, dynamic> json) => CallList(
        id: (json['_id'] ?? json['id'] ?? '').toString(),
        name: (json['name'] ?? 'Untitled list').toString(),
        agents: json['agents'] is List ? json['agents'] as List : const [],
        clientId: (json['clientId'] ?? '').toString(),
      );
}

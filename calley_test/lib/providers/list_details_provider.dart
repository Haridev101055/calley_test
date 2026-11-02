import 'package:flutter/foundation.dart';

import '../models/call_contact.dart';
import '../models/list_details.dart';
import '../services/api_service.dart';
import 'lists_provider.dart';

class ListDetailsProvider extends ChangeNotifier {
  ListDetailsProvider(this._api, this.listId);
  final ApiService _api;
  final String listId;

  LoadState state = LoadState.idle;
  ListDetails? details;
  String? error;
  String _query = '';

  String get query => _query;
  set query(String v) {
    _query = v.trim().toLowerCase();
    notifyListeners();
  }

  List<CallContact> get filteredCalls {
    final calls = details?.calls ?? const <CallContact>[];
    if (_query.isEmpty) return calls;
    return calls
        .where((c) =>
            c.fullName.toLowerCase().contains(_query) ||
            (c.phone ?? '').contains(_query))
        .toList();
  }

  Future<void> load() async {
    state = LoadState.loading;
    error = null;
    notifyListeners();
    try {
      details = await _api.fetchListDetails(listId);
      state = LoadState.success;
    } catch (e) {
      error = e.toString();
      state = LoadState.error;
    }
    notifyListeners();
  }
}

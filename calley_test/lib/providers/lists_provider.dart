import 'package:flutter/foundation.dart';

import '../models/call_list.dart';
import '../services/api_service.dart';

enum LoadState { idle, loading, success, error }

class ListsProvider extends ChangeNotifier {
  ListsProvider(this._api);
  final ApiService _api;

  LoadState state = LoadState.idle;
  List<CallList> lists = [];
  String? error;

  Future<void> load() async {
    state = LoadState.loading;
    error = null;
    notifyListeners();
    try {
      lists = await _api.fetchLists();
      state = LoadState.success;
    } catch (e) {
      error = e.toString();
      state = LoadState.error;
    }
    notifyListeners();
  }
}

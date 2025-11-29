import 'package:flutter/foundation.dart';

/// Global notifier to force chat list UI refresh
class ChatRefreshNotifier extends ChangeNotifier {
  static final ChatRefreshNotifier _instance = ChatRefreshNotifier._internal();
  factory ChatRefreshNotifier() => _instance;
  ChatRefreshNotifier._internal();

  int _refreshCounter = 0;
  int get refreshCounter => _refreshCounter;

  void forceRefresh() {
    _refreshCounter++;
    notifyListeners();
    print('🔄 ChatRefreshNotifier - Force refresh called, counter: $_refreshCounter');
  }
}


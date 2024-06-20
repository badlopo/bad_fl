import 'dart:async';

import 'package:bad_fl/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum SearchEvent {
  /// the inner [ScrollController] is not attached to any client
  noListAttached,

  /// search is triggered while still in pending state
  rejected,

  /// search is triggered while there is no more data
  noMoreData,

  /// trigger when fetcher returns `null`
  fetcherFailed,
}

/// combination of pending state and result container
class BadSearchState<T> extends ChangeNotifier
    implements ValueListenable<(bool, List<T>)> {
  bool _pending = false;

  bool get isPending => _pending;

  set pending(bool to) {
    _pending = to;
    notifyListeners();
  }

  final List<T> _result = [];

  List<T> get result => _result;

  @override
  get value => (_pending, _result);

  void add(T item) {
    _result.add(item);
    notifyListeners();
  }

  void addAll(Iterable<T> iterable) {
    _result.addAll(iterable);
    notifyListeners();
  }

  void clear() {
    _result.clear();
    notifyListeners();
  }
}

/// Provides everything you need for paged search
/// (keywords, page numbers, page size, pending status, results, next page, re-search, etc.)
///
/// Recommended to use with [ValueListenableBuilder]
mixin BadSearchMixin<ListItemType> {
  /// this should be attached to the list container the data is displayed in,
  /// whether it's a `ListView`, `GridView`, `CustomScrollView`, etc.
  @nonVirtual
  final ScrollController sc = ScrollController();

  /// the page size to search
  ///
  /// Default to `20`
  final int pageSize = 20;

  /// whether the search is at the end
  bool _isEnd = false;

  /// the target string to search (optional)
  String _target = '';

  /// the target string to search (read-only)
  @nonVirtual
  String get target => _target;

  /// the next page number to search
  int _pageNo = 1;

  /// the next page number to search (read-only)
  @nonVirtual
  int get pageNo => _pageNo;

  /// search state (pending state & result container)
  @nonVirtual
  final BadSearchState<ListItemType> searchState = BadSearchState();

  /// reset the search status for a new search
  ///
  /// - scroll to top if the [sc] is attached
  /// - reset [_isEnd] to false
  /// - reset [_pageNo] to 1
  /// - clear [searchState]
  void _resetStatus() {
    if (sc.hasClients) {
      sc.jumpTo(0);
    } else {
      onSearchEvent(SearchEvent.noListAttached);
    }

    _isEnd = false;
    _pageNo = 1;
    searchState.clear();
  }

  /// override this method to handle search event (do some log, toast, etc).
  void onSearchEvent(SearchEvent event) {
    BadFl.log(module: 'BadSearchMixin', message: 'SearchEvent(${event.name})');
  }

  /// specific implementation of data request. It should return an `Iterable<ListItemType>` (success) or `null` (failed).
  ///
  /// Note: this should never be called directly, use [nextPage], [reloadPage] or [searchPage] when needed.
  Future<Iterable<ListItemType>?> fetcher(String target, int pageNo);

  /// try using [fetcher] to get the next page data and process it.
  /// - if still in pending state, trigger [SearchEvent.rejected]
  /// - (else) if there is no more data, trigger [SearchEvent.noMoreData]
  /// - (else) call [fetcher] with [_target] and [_pageNo]
  /// - success: append the data to [searchState], update [_pageNo] and [_isEnd]
  /// - failed: trigger [SearchEvent.fetcherFailed]
  ///
  /// see also: [reloadPage], [searchPage]
  @nonVirtual
  Future<void> nextPage() async {
    if (searchState.isPending) {
      onSearchEvent(SearchEvent.rejected);
      return;
    } else if (_isEnd) {
      onSearchEvent(SearchEvent.noMoreData);
      return;
    }

    // lock the search
    searchState.pending = true;

    // do search
    Iterable<ListItemType>? items = await fetcher(_target, _pageNo);
    if (items == null) {
      onSearchEvent(SearchEvent.fetcherFailed);
    } else {
      if (items.length < pageSize) _isEnd = true;
      searchState.addAll(items);
      _pageNo += 1;
    }

    // unlock the search
    searchState.pending = false;
  }

  /// redo search with the same target from the first page.
  ///
  /// see also: [nextPage], [searchPage]
  @nonVirtual
  Future<void> reloadPage() {
    _resetStatus();
    return nextPage();
  }

  /// search the first page with a new target.
  ///
  /// see also: [nextPage], [reloadPage]
  @nonVirtual
  Future<void> searchPage(String newTarget) {
    _resetStatus();
    _target = newTarget;
    return nextPage();
  }
}

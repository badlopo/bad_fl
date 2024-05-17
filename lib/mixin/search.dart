import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

/// The [BadSearchMixin] provides a simple way to implement paging queries.
mixin BadSearchMixin<ListItemType> on GetxController {
  /// this should be attached to the list container the data is displayed in,
  /// whether it's a [ListView] or something else.
  final ScrollController sc = ScrollController();

  /// a [RxBool] to indicate if the search is pending.
  final RxBool pending = false.obs;

  /// the page size to search, default to `20`, override it if needed.
  final int pageSize = 20;

  /// whether there is no more data to search.
  bool _isEnd = false;

  /// the target string to search (optional)
  String _target = '';

  /// the target string to search (read-only)
  String get target => _target;

  /// the next page number to search
  int _pageNo = 1;

  /// the next page number to search (read-only)
  int get pageNo => _pageNo;

  /// a [RxList] to store the search result, its generic type is [ListItemType].
  final RxList<ListItemType> resultList = <ListItemType>[].obs;

  /// reset the search status for a new search
  ///
  /// - scroll to top if the [sc] is attached
  /// - reset [_isEnd] to false
  /// - reset [_pageNo] to 1
  /// - clear [resultList]
  void _resetStatus() {
    if (sc.hasClients) {
      sc.jumpTo(0);
    } else {
      onSearchEvent(SearchEvent.noListAttached);
    }

    _isEnd = false;
    _pageNo = 1;
    resultList.clear();
  }

  /// override this method to handle search event (log, toast, etc).
  void onSearchEvent(SearchEvent event) {}

  /// specific implementation of data request. It should return an [Iterable] of [ListItemType] (success) or `null` (failed).
  ///
  /// **NOTE:** this should never be called directly, use [nextPage], [reloadPage] or [searchPage] instead.
  Future<Iterable<ListItemType>?> fetcher(String target, int pageNo);

  /// try using [fetcher] to get the next page data and process it.
  /// - if still in pending state, trigger [SearchEvent.pending]
  /// - (else) if there is no more data, trigger [SearchEvent.noMoreData]
  /// - (else) call [fetcher] with [_target] and [_pageNo]
  ///   - success: append the data to [resultList], update [_pageNo] and [_isEnd]
  ///   - failed: trigger [SearchEvent.fetcherFailed]
  ///
  /// see also: [reloadPage], [searchPage]
  Future<void> nextPage() async {
    if (pending.isTrue) {
      onSearchEvent(SearchEvent.rejected);
      return;
    } else if (_isEnd) {
      onSearchEvent(SearchEvent.noMoreData);
      return;
    }

    // lock the search
    pending.value = true;

    // do search
    Iterable<ListItemType>? items = await fetcher(_target, _pageNo);
    if (items == null) {
      onSearchEvent(SearchEvent.fetcherFailed);
    } else {
      if (items.length < pageSize) _isEnd = true;
      resultList.addAll(items);
      _pageNo += 1;
    }

    // unlock the search
    pending.value = false;
  }

  /// redo search with the same target from the first page.
  ///
  /// see also: [nextPage], [searchPage]
  Future<void> reloadPage() async {
    _resetStatus();
    await nextPage();
  }

  /// search a new target from the first page.
  ///
  /// see also: [nextPage], [reloadPage]
  Future<void> searchPage(String newTarget) {
    _resetStatus();
    _target = newTarget;
    return nextPage();
  }
}

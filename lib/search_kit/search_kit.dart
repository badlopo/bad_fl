import 'package:bad_fl/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// trait bound
abstract class _WithResult<T> {
  List<T> get result;
}

/// state of search kit
///
/// non-blocking state:
/// - idle
/// - done
///
/// blocking state:
/// - loading
/// - loadingMore
sealed class SearchState<T> {
  const SearchState();
}

/// state::idle
class _Idle<T> extends SearchState<T> {
  const _Idle();
}

/// state::loading
class _Loading<T> extends SearchState<T> {
  const _Loading();
}

/// state::loadingMore
class _LoadingMore<T> extends SearchState<T> implements _WithResult<T> {
  @override
  final List<T> result;

  const _LoadingMore(this.result);
}

/// state::done
class _Done<T> extends SearchState<T> implements _WithResult<T> {
  @override
  final List<T> result;

  const _Done(this.result);
}

/// maintain everything you need for searching
class BadSearchKitStatus<T> extends ChangeNotifier
    implements ValueListenable<SearchState<T>> {
  /// current state of search kit
  SearchState<T> _state;

  /// current state of search kit
  @override
  SearchState<T> get value => _state;

  BadSearchKitStatus() : _state = const _Idle();

  /// change the state to 'idle'
  ///
  /// Note: you can call this method to reset the search kit (e.g. press a clear button)
  @protected
  void idle() {
    if (_state is! _Idle) {
      _state = const _Idle();
      notifyListeners();
    }
  }

  /// change the state to 'done' if not,
  /// then append the items to the result
  ///
  /// Note: do not call this method directly, trigger it by performing a search action
  @protected
  void done(Iterable<T> items) {
    if (_state is _Loading<T>) {
      _state = _Done(items.toList());
    } else if (_state is _LoadingMore<T>) {
      _state = _Done((_state as _LoadingMore<T>).result)..result.addAll(items);
    } else {
      throw StateError('Not in blocking state');
    }

    notifyListeners();
  }

  /// transition from non-blocking state to blocking state (depending on the current state),
  /// this will happen when the search action is performed
  ///
  /// Note: do not call this method directly, trigger it by performing a search action
  @protected
  void block(int pageNo) {
    if (_state is _Idle<T>) {
      _state = const _Loading();
    } else if (_state is _Done<T>) {
      if (pageNo == 1) {
        _state = const _Loading();
      } else {
        _state = _LoadingMore((_state as _Done<T>).result);
      }
    } else {
      throw StateError('Not in non-blocking state');
    }

    notifyListeners();
  }

  /// transition from blocking state to non-blocking state (depending on the current state),
  /// this will happen when the search action is completed with a empty result (no more data)
  ///
  /// Note: do not call this method directly, trigger it by performing a search action
  @protected
  void unblock() {
    if (_state is _Loading<T>) {
      _state = const _Idle();
    } else if (_state is _LoadingMore<T>) {
      _state = _Done((_state as _LoadingMore<T>).result);
    } else {
      throw StateError('Not in blocking state');
    }

    notifyListeners();
  }

  /// scroll controller for the scrollable widget that contains the search result
  final ScrollController sc = ScrollController();

  int _pageNo = 1;

  String _searchTarget = '';

  bool _isEnd = false;

  void _resetState() {
    _pageNo = 1;
    _isEnd = false;
    if (sc.hasClients) sc.jumpTo(0);
    if (_state is _Done) (_state as _Done).result.clear();
  }
}

/// all the methods to perform search actions
mixin BadSearchKitMixin<T> {
  /// search kit status
  final BadSearchKitStatus<T> _status = BadSearchKitStatus<T>();

  /// search kit status
  BadSearchKitStatus<T> get searchKit => _status;

  /// the page size to search
  ///
  /// Default to `20`
  final int pageSize = 20;

  /// current page number, starting from `1`
  int get pageNo => _status._pageNo;

  /// current search target
  String get searchTarget => _status._searchTarget;

  // region callbacks: override these methods to handle search events
  /// callback when search is triggered while still in loading state
  void onReject() {
    BadFl.log(
      module: 'BadSearchKit',
      message: 'search is triggered while still in loading state',
    );
  }

  /// callback when search is triggered while there is no more data
  void onNoMoreData() {
    BadFl.log(
      module: 'BadSearchKit',
      message: 'search is triggered while there is no more data',
    );
  }

  /// callback when the fetcher returns `null`
  void onFetcherFailed() {
    BadFl.log(module: 'BadSearchKit', message: 'fetcher failed');
  }

  // endregion

  // region actions: call these methods to perform search actions
  /// fetch for the next page if the search state is `done` and not at the end.
  @nonVirtual
  Future<void> nextPage() async {
    if (_status._state is _Loading || _status._state is _LoadingMore) {
      onReject();
      return;
    } else if (_status._state is _Done && _status._isEnd) {
      onNoMoreData();
      return;
    }

    // set loading only when fetching the first page
    _status.block(_status._pageNo);

    Iterable<T>? items = await fetcher(_status._searchTarget, _status._pageNo);
    if (items == null) {
      onFetcherFailed();
      _status.unblock();
      return;
    } else {
      final int count = items.length;

      // update '_isEnd'
      if (count < pageSize) _status._isEnd = true;

      if (count == 0) {
        onNoMoreData();
        _status.unblock();
      } else {
        _status.done(items);
        _status._pageNo += 1;
      }
    }
  }

  /// redo search with the same target (if any) from the first page.
  @nonVirtual
  Future<void> reloadPage() {
    _status._resetState();
    return nextPage();
  }

  /// search the first page with a new target.
  @nonVirtual
  Future<void> searchPage(String searchTarget) {
    _status._resetState();
    _status._searchTarget = searchTarget;
    return nextPage();
  }

  /// try to clear the page if not in loading state, return whether the page is cleared.
  @nonVirtual
  bool clearPage() {
    if (_status._state is _Loading || _status._state is _LoadingMore) {
      onReject();
      return false;
    } else {
      _status._resetState();
      _status._searchTarget = '';
      _status.idle();
      return true;
    }
  }

  // endregion

  /// specific implementation of data request.
  /// in a way, this implementation should not throw errors
  /// (if any error occurs, handle it internally and return null)
  ///
  /// Note: It should return an `Iterable<T>` (success) or `null` (failed).
  Future<Iterable<T>?> fetcher(String target, int pageNo);
}

/// a builder widget that helps to build a search kit widget
class BadSearchKitBuilder<T> extends StatelessWidget {
  /// search kit status
  final BadSearchKitStatus<T> searchKit;

  /// show this widget when idle (no search, no target, no result)
  final Widget idleView;

  /// show this widget when searching for the first page (pageNo=1)
  final Widget loadingView;

  /// show this widget when search result is not empty
  final Widget Function(
    BuildContext context,
    ScrollController sc,
    List<T> result,
  ) listViewBuilder;

  const BadSearchKitBuilder({
    super.key,
    required this.searchKit,
    required this.idleView,
    required this.loadingView,
    required this.listViewBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SearchState<T>>(
      valueListenable: searchKit,
      builder: (context, state, _) {
        switch (state) {
          case _Idle():
            return idleView;
          case _Loading():
            return loadingView;
          case _LoadingMore():
          case _Done():
            return listViewBuilder(
              context,
              searchKit.sc,
              (state as _WithResult<T>).result,
            );
        }
      },
    );
  }
}

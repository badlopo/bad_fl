import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Trait bound.
abstract class _WithResult<T> {
  List<T> get result;
}

/// Current state of search kit.
sealed class SearchStatus<T> {
  const SearchStatus();
}

class SearchStatusIdle<T> extends SearchStatus<T> {
  const SearchStatusIdle();
}

class SearchStatusLoading<T> extends SearchStatus<T> {
  const SearchStatusLoading();
}

class SearchStatusLoadingMore<T> extends SearchStatus<T>
    implements _WithResult<T> {
  @override
  final List<T> result;

  const SearchStatusLoadingMore(this.result);
}

class SearchStatusDone<T> extends SearchStatus<T> implements _WithResult<T> {
  @override
  final List<T> result;

  const SearchStatusDone(this.result);
}

/// State of search kit.
class SearchKitState<Q, T> extends ChangeNotifier
    implements ValueListenable<SearchStatus<T>> {
  /// Current state of search kit.
  SearchStatus<T> _state;

  @override
  SearchStatus<T> get value => _state;

  /// private constructor
  SearchKitState._() : _state = const SearchStatusIdle();

  /// Change the state to `idle`.
  ///
  /// This will be called by `clearPage`.
  ///
  /// DO NOT call this method directly, trigger it by performing a search action.
  @protected
  void idle() {
    if (_state is! SearchStatusIdle) {
      _state = const SearchStatusIdle();
      notifyListeners();
    }
  }

  /// Change the state to `done` if not, then append the items to the result.
  ///
  /// This will be called when `fetcher` finished. And the next state depends on the result of `fetcher`.
  ///
  /// DO NOT call this method directly, trigger it by performing a search action.
  @protected
  void done(Iterable<T>? items) {
    if (_state is SearchStatusLoading<T>) {
      if (items?.isNotEmpty != true) {
        _state = SearchStatusIdle();
      } else {
        _state = SearchStatusDone(items!.toList());
      }
    } else if (_state is SearchStatusLoadingMore<T>) {
      _state = SearchStatusDone((_state as SearchStatusLoadingMore<T>).result);
      if (items?.isNotEmpty == true) {
        (_state as SearchStatusDone).result.addAll(items!);
      }
    } else {
      throw StateError('Unexpected transition');
    }

    notifyListeners();
  }

  /// Change the state to `loading` / `loading more` depends on the page to load.
  ///
  /// This will be called when a search action (reload, search, next page) is performed.
  ///
  /// DO NOT call this method directly, trigger it by performing a search action.
  @protected
  void load(int pageNo) {
    if (_state is SearchStatusIdle<T>) {
      _state = const SearchStatusLoading();
    } else if (_state is SearchStatusDone<T>) {
      if (pageNo == 1) {
        _state = const SearchStatusLoading();
      } else {
        _state =
            SearchStatusLoadingMore((_state as SearchStatusDone<T>).result);
      }
    } else {
      throw StateError('Unexpected transition');
    }

    notifyListeners();
  }

  /// Modify inner status by apply a custom `fn`.
  ///
  /// NOTE: it may break relationship of `status` and `pageNo`、`isEnd`
  void unsafeMutate(SearchStatus<T> Function(SearchStatus<T> status) fn) {
    _state = fn(_state);

    notifyListeners();
  }

  /// Scroll controller for the scrollable widget that show the search result.
  ///
  /// You SHOULD attach this to the scrollable widget so that search kit
  /// can update scroll position (to `0`) when result list is cleared.
  final ScrollController sc = ScrollController();

  /// Next page to fetch. (NOT current page)
  int _pageNo = 1;

  /// The target to search.
  Q? _searchTarget;

  bool _isEnd = false;

  /// Reset all state except `searchTarget` to initial.
  void _resetState() {
    _pageNo = 1;
    _isEnd = false;
    if (sc.hasClients) sc.jumpTo(0);
    if (_state is SearchStatusDone) (_state as SearchStatusDone).result.clear();
  }
}

enum EndStrategy {
  /// result of `fetcher` is empty
  empty,

  /// result of `fetcher` is less than `pageSize`
  notEnough
}

/// Search kit provide a encapsulation of search behaviors,
/// includes search, next page, reload, clear.
///
/// Use [SearchKitWidgetBuilder] to display the corresponding
/// widget of various states during search.
///
/// Note: A search request will be rejected if previous one
/// is still running, rather than cancel the previous and
/// start the new request.
///
/// ## Concept
///
/// Search State:
/// - `idle`
/// - `loading`
/// - `loadingMore`
/// - `done`
///
/// Action Callback:
/// - `onReject`
/// - `onNoMoreData`
/// - `onFetcherFailed`
///
/// Action:
/// - `nextPage`
/// - `reloadPage`
/// - `searchPage`
/// - `clearPage`
mixin SearchKitMixin<Q, T> {
  /// Search kit state.
  final SearchKitState<Q, T> _state = SearchKitState<Q, T>._();

  SearchKitState<Q, T> get searchKit => _state;

  EndStrategy get endStrategy => EndStrategy.notEnough;

  /// Default to `20`.
  final int pageSize = 20;

  /// The number of page to fetch (NOT current page)
  int get pageNo => _state._pageNo;

  /// The target to search.
  Q? get searchTarget => _state._searchTarget;

  /// ACTION CALLBACK: a search request is performed while search kit is in loading state (`loading` / `loadingMore`).
  ///
  /// Override to customize
  void onReject() {
    // no-op
  }

  /// Callback when search is triggered while there is no more data
  ///
  /// Override to customize
  void onNoMoreData() {
    // no-op
  }

  /// Callback when the fetcher returns `null` (which means failed)
  ///
  /// Override to customize
  void onFetcherFailed() {
    // no-op
  }

  /// Request the next page with current target
  @nonVirtual
  Future<void> nextPage() async {
    if (_state._state is SearchStatusLoading ||
        _state._state is SearchStatusLoadingMore) {
      onReject();
      return;
    } else if (_state._state is SearchStatusDone && _state._isEnd) {
      onNoMoreData();
      return;
    }

    // update state
    _state.load(_state._pageNo);

    Iterable<T>? items = await fetcher(_state._searchTarget, _state._pageNo);
    if (items == null) {
      onFetcherFailed();
    } else {
      final bool isEnd = switch (endStrategy) {
        EndStrategy.empty => items.isEmpty,
        EndStrategy.notEnough => items.length < pageSize,
      };

      if (isEnd) _state._isEnd = true;

      if (items.isEmpty) {
        onNoMoreData();
      } else {
        _state._pageNo += 1;
      }
    }

    // update state
    _state.done(items);
  }

  /// Perform a search with current target from the first page
  @nonVirtual
  Future<void> reloadPage() {
    _state._resetState();
    return nextPage();
  }

  /// Perform a search with given target from the first page
  @nonVirtual
  Future<void> searchPage(Q searchTarget) {
    _state._resetState();
    _state._searchTarget = searchTarget;
    return nextPage();
  }

  /// Reset state to initial.
  @nonVirtual
  bool clearPage() {
    if (_state._state is SearchStatusLoading ||
        _state._state is SearchStatusLoadingMore) {
      onReject();
      return false;
    } else {
      _state._resetState();
      _state._searchTarget = null;
      _state.idle();
      return true;
    }
  }

  /// Implementation of your data acquisition.
  ///
  /// This SHOULD NOT throw error. (you SHOULD handle errors yourself in your implementation)
  ///
  /// Returns `Iterable<T>` on success, `null` on failure.
  Future<Iterable<T>?> fetcher(Q? target, int pageNo);
}

typedef ListWidgetBuilder<T> = Widget Function(
    BuildContext context, ScrollController sc, List<T> data);

/// Display the corresponding widget of various states during search.
class SearchKitWidgetBuilder<Q, T> extends StatelessWidget {
  /// Search kit state
  final SearchKitState<Q, T> searchKit;

  /// The widget to display when search kit is in `idle` state
  final Widget idleWidget;

  /// The widget to display when search kit is in `loading` state
  final Widget loadingWidget;

  /// Builder of the widget to display when search kit has non-empty result (in `done` / `loadingMore` state)
  final ListWidgetBuilder<T> listWidgetBuilder;

  const SearchKitWidgetBuilder({
    super.key,
    required this.searchKit,
    required this.idleWidget,
    required this.loadingWidget,
    required this.listWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SearchStatus<T>>(
      valueListenable: searchKit,
      builder: (context, state, _) {
        switch (state) {
          case SearchStatusIdle():
            return idleWidget;
          case SearchStatusLoading():
            return loadingWidget;
          case SearchStatusLoadingMore():
          case SearchStatusDone():
            return listWidgetBuilder(
              context,
              searchKit.sc,
              (state as _WithResult<T>).result,
            );
        }
      },
    );
  }
}

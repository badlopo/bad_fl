part of 'route.dart';

class _AsideMenuRoute extends StatelessWidget {
  final String currentRoute;
  final String targetRoute;
  final String title;
  final String description;

  bool get active => currentRoute == targetRoute;

  const _AsideMenuRoute({
    required this.currentRoute,
    required this.targetRoute,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: active ? Colors.blue.shade50 : Colors.white,
      ),
      child: Row(
        children: [
          active
              ? Container(
                  width: 4,
                  height: 24,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    color: Colors.blue,
                  ),
                )
              : const SizedBox(width: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 28, right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BadText(title, fontSize: 14),
                  BadText(description, color: Colors.grey, fontSize: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return BadClickable(
      onClick: () {
        if (active) return;
        Navigator.of(context).pushReplacementNamed(targetRoute);
      },
      child: inner,
    );
  }
}

class _AppAside extends StatelessWidget {
  const _AppAside();

  Iterable<Widget> _expandMenuItems(String current) sync* {
    AsideMenuGroup? group;
    List<AsideMenuItem> groupItem = [];

    for (final menuItem in menuItems) {
      if (menuItem is AsideMenuGroup) {
        if (group == null) {
          group = menuItem;
        } else {
          yield BadExpansible(
            headerBuilder: (controller) {
              return BadClickable(
                onClick: () => controller.toggle(),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      const Icon(Icons.widgets_outlined),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: BadText(group!.name),
                        ),
                      ),
                      controller.isExpanded
                          ? const Icon(Icons.expand_less_outlined)
                          : const Icon(Icons.expand_more_outlined),
                    ],
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final groupItem in groupItem)
                  switch (groupItem) {
                    AsideMenuGroup() => BadText(groupItem.name),
                    AsideMenuSubtitle() => Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                        ),
                        child: BadText(
                          groupItem.name,
                          color: Colors.blue.shade50,
                          fontSize: 14,
                        ),
                      ),
                    AsideMenuRoute() => _AsideMenuRoute(
                        currentRoute: current,
                        targetRoute: groupItem.path,
                        title: groupItem.names.en,
                        description: groupItem.names.zh,
                      ),
                  },
              ],
            ),
          );

          group = menuItem;
          groupItem = [];
        }
      } else {
        groupItem.add(menuItem);
      }
    }

    if (group != null) {
      yield BadExpansible(
        headerBuilder: (controller) {
          return BadClickable(
            onClick: () => controller.toggle(),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  const Icon(Icons.widgets_outlined),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: BadText(group!.name),
                    ),
                  ),
                  controller.isExpanded
                      ? const Icon(Icons.expand_less_outlined)
                      : const Icon(Icons.expand_more_outlined),
                ],
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final groupItem in groupItem)
              switch (groupItem) {
                AsideMenuGroup() => BadText(groupItem.name),
                AsideMenuSubtitle() => Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: BadText(
                      groupItem.name,
                      color: Colors.blue.shade50,
                      fontSize: 14,
                    ),
                  ),
                AsideMenuRoute() => _AsideMenuRoute(
                    currentRoute: current,
                    targetRoute: groupItem.path,
                    title: groupItem.names.en,
                    description: groupItem.names.zh,
                  ),
              },
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.settingsOf(context)!.name ?? '';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [..._expandMenuItems(current)],
      ),
    );
  }
}

class AppLayout extends StatelessWidget {
  final ({String en, String zh}) names;

  final Widget child;

  const AppLayout({super.key, required this.names, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(names.en)),
      drawer: const Drawer(child: _AppAside()),
      body: child,
    );
  }
}

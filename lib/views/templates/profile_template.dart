import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/stores/profile_store.dart';
import 'package:student_for_student_mobile/views/organisms/screen_navigation_bar.dart';

const _totalSpace = 390.0;
var _remainSpace = 0.0;

/// returns the given size if still enought place, else returns the remaining place.
///
/// [times] is the number of times the given size has to be removed from the remaining space.
/// Even if [times] is greater than 1, the returned size is [wantedSize].
double _getRemainsSpace(double wantedSize, {int times = 1}) {
  times = times < 0 ? 0 : times;
  if (wantedSize.isNegative) return 0;
  wantedSize = wantedSize * times;
  if (_remainSpace > wantedSize) {
    _remainSpace -= wantedSize;
    return wantedSize;
  } else {
    final remains = _remainSpace;
    _remainSpace = 0;
    return remains;
  }
}

class NestedScollableTabBarViewTemplate extends StatelessWidget {
  const NestedScollableTabBarViewTemplate({
    super.key,
    required this.title,
    required this.tabBarPair,
  });

  final Widget title;
  final TabBarPair tabBarPair;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarPair.length,
      child: Scaffold(
        body: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  elevation: 4,
                  backgroundColor: Colors.white,
                  toolbarHeight: 390,
                  expandedHeight: 390,
                  title: title,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(90),
                    child: _TabBar(tabs: tabBarPair.tabs),
                  ),
                )
              ];
            },
            // The nested scrollable body
            body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: tabBarPair.views
                    .map((tabBarPairView) => SingleChildScrollView(
                          physics: tabBarPairView.isEmpty
                              ? const NeverScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          child: tabBarPairView.view,
                        ))
                    .toList())),
        bottomNavigationBar: const ScreenNavigationBar(),
      ),
    );
  }
}

// This widget does not need to be moved in another file,
// here it is just to make the code more readable.
class _TabBar extends StatelessWidget {
  const _TabBar({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final Map<String, Icon> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      height: 50,
      decoration: BoxDecoration(
          color: const Color(0xFF85a074),
          borderRadius: BorderRadius.circular(25.0)),
      child: TabBar(
          isScrollable: false,
          padding: const EdgeInsets.all(5),
          unselectedLabelColor: Colors.black,
          indicator: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Color(0xff46543d),
          ),
          tabs: tabs.entries
              .map((entry) => Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        entry.value,
                        const SizedBox(width: 10),
                        Text(entry.key),
                      ],
                    ),
                  ))
              .toList()),
    );
  }
}

// ------------------
// Models
// ------------------
class TabBarPair {
  /// [tabs] and [views] must have the same length
  TabBarPair({required this.tabs, required this.views})
      : assert(tabs.length == views.length,
            'tabs length [${tabs.length}] and views length [${views.length}] must be equal');
  final Map<String, Icon> tabs;
  final List<TabBarPairView> views;

  int get length => tabs.length;
}

class TabBarPairView {
  TabBarPairView({
    required this.isEmpty,
    required this.view,
  });

  final bool isEmpty;
  final Widget view;
}

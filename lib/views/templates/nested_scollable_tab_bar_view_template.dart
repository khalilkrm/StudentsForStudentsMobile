import 'package:flutter/material.dart';
import 'package:student_for_student_mobile/views/organisms/screen_navigation_bar.dart';

const _tabBarHeight = 50.0;
const _tabBarVeticalMargin = 20.0;
const _tabBarPadding = 5.0;

const _navBarHeight =
    100.0 + (_tabBarHeight + (_tabBarVeticalMargin * 2)) + (_tabBarPadding * 2);

const _defaultTitleHeight = 50.0;

class NestedScollableTabBarViewTemplate extends StatefulWidget {
  const NestedScollableTabBarViewTemplate({
    super.key,
    required this.title,
    required this.tabs,
    required this.views,
  }) : assert(tabs.length == views.length,
            'tabs length [${tabs.length}] and views length [${views.length}] must be equal');

  final Widget title;
  final List<Widget> tabs;
  final List<TabBarViewModel> views;

  @override
  State<NestedScollableTabBarViewTemplate> createState() =>
      _NestedScollableTabBarViewTemplateState();
}

class _NestedScollableTabBarViewTemplateState
    extends State<NestedScollableTabBarViewTemplate> {
  final GlobalKey _titleKey = GlobalKey();
  Size _titleSize = const Size(0, _defaultTitleHeight);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getSizeAndPosition());
  }

  _getSizeAndPosition() {
    RenderBox? cardBox =
        _titleKey.currentContext?.findRenderObject() as RenderBox?;
    setState(() {
      _titleSize = cardBox?.size ?? const Size(0, _defaultTitleHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  centerTitle: false,
                  pinned: true,
                  floating: true,
                  elevation: 4,
                  backgroundColor: Colors.grey.shade100,
                  toolbarHeight: _navBarHeight + _titleSize.height,
                  expandedHeight: _navBarHeight + _titleSize.height,
                  title: Container(
                    key: _titleKey,
                    child: widget.title,
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(
                        _tabBarHeight + (_tabBarVeticalMargin * 2)),
                    child: _TabBar(tabs: widget.tabs),
                  ),
                )
              ];
            },
            // The nested scrollable body
            body: Container(
                color: Colors.grey.shade100,
                child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: widget.views
                        .map((w) => w.makeScrollable
                            ? SingleChildScrollView(
                                padding: const EdgeInsets.all(10),
                                physics: const BouncingScrollPhysics(),
                                child: w.child)
                            : w.child)
                        .toList()))),
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

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          horizontal: 10, vertical: _tabBarVeticalMargin),
      height: _tabBarHeight,
      decoration: BoxDecoration(
          color: const Color(0xFF85a074),
          borderRadius: BorderRadius.circular(25.0)),
      child: TabBar(
          padding: const EdgeInsets.all(_tabBarPadding),
          unselectedLabelColor: Colors.black,
          indicator: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Color(0xff46543d),
          ),
          tabs: tabs.map((widget) => Tab(child: widget)).toList()),
    );
  }
}

class TabBarViewModel {
  final bool makeScrollable;
  final Widget child;

  TabBarViewModel({
    required this.makeScrollable,
    required this.child,
  });
}

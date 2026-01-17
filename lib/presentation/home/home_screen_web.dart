import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/presentation/widgets/controllers/expanded_collapsed_menu_controller.dart';

class HomeScreenWeb extends ConsumerStatefulWidget {
  const HomeScreenWeb({super.key});

  @override
  ConsumerState<HomeScreenWeb> createState() => _HomeScreenWebState();
}

class _HomeScreenWebState extends ConsumerState<HomeScreenWeb> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalRangeController = ScrollController();
  final ScrollController _horizontalCompetitionController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState?.openDrawer();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _horizontalRangeController.dispose();
    _horizontalCompetitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //MENU
    final menuExpanded = ref.watch(menuExpandedProvider);
    final menuWidth = menuExpanded ? 280.0 : 72.0;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  width: menuWidth,
                  child: SizedBox(
                    width: menuWidth,
                    child: _buildMenu(menuExpanded),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Ranges',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          Scrollbar(
                            controller: _horizontalRangeController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: _horizontalRangeController,
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Events',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                          Scrollbar(
                            thumbVisibility: true,
                            controller: _horizontalCompetitionController,
                            child: SingleChildScrollView(
                              controller: _horizontalCompetitionController,
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                    _buildCard(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text('RangeConnect',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
                    CircleAvatar(
                      child: Text(
                        kIsWeb ? 'WS' : 'MS',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: Text(
            'Card',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(bool expanded) {
    return Material(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: Row(
                children: [
                  if (expanded)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SizeTransition(
                          sizeFactor: anim,
                          axis: Axis.horizontal,
                          child: child,
                        ),
                      ),
                      child: expanded
                          ? Align(
                              key: const ValueKey('MenuLabel'),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Menu',
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            )
                          : const SizedBox(key: ValueKey('collapsed')),
                    ),
                  if (expanded) const Spacer(),
                  if (!expanded)
                    IconButton(
                        onPressed: () {
                          ref.read(menuExpandedProvider.notifier).toggle();
                        },
                        icon: const Icon(
                          Icons.menu,
                        )),
                  if (expanded)
                    IconButton(
                        onPressed: () {
                          ref.read(menuExpandedProvider.notifier).toggle();
                        },
                        icon: const Icon(Icons.arrow_back)),
                ],
              )),
          tile(Icons.home, 'Home', expanded),
          tile(Icons.settings, 'Settings', expanded),
        ],
      ),
    );
  }

  Widget tile(IconData icon, String label, bool expanded) {
    return ListTile(
      leading: Icon(icon),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SizeTransition(
            sizeFactor: anim,
            axis: Axis.horizontal,
            child: child,
          ),
        ),
        child: expanded
            ? Align(
                key: ValueKey(label),
                alignment: Alignment.centerLeft,
                child: Text(label,
                    maxLines: 1, overflow: TextOverflow.fade, softWrap: false),
              )
            : const SizedBox(key: ValueKey('collapsed')),
      ),
      minLeadingWidth: 0,
    );
  }
}

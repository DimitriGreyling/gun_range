import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/presentation/widgets/controllers/expanded_collapsed_menu_controller.dart';
import 'package:gun_range_app/presentation/widgets/loading_card_widget.dart';
import 'package:gun_range_app/providers/supabase_provider.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      ref.read(rangeViewModelProvider.notifier).fetchRanges();
      ref.read(rangeViewModelProvider.notifier).fetchEvents();
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

    //Ranges and Events would be fetched from ViewModels
    final rangeState = ref.watch(rangeViewModelProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            _buildHeader(),
            const SizedBox(height: 16.0),
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
                                        rangeState.isLoadingRanges ||
                                                rangeState.ranges.isNotEmpty
                                            ? MainAxisAlignment.spaceEvenly
                                            : MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        rangeState.isLoadingRanges ||
                                                rangeState.ranges.isNotEmpty
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.center,
                                    children: rangeState.isLoadingRanges
                                        ? [
                                            const LoadingCardWidget(lineCount: 3),
                                            const LoadingCardWidget(lineCount: 3),
                                            const LoadingCardWidget(lineCount: 3),
                                          ]
                                        : rangeState.ranges.isNotEmpty
                                            ? [
                                                for (var range
                                                    in rangeState.ranges)
                                                  _buildCard(),
                                              ]
                                            : [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3,
                                                  child: Text(
                                                    'No Ranges Available',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ),
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
                                        rangeState.isLoadingEvents ||
                                                rangeState.events.isNotEmpty
                                            ? MainAxisAlignment.spaceEvenly
                                            : MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        rangeState.isLoadingEvents ||
                                                rangeState.events.isNotEmpty
                                            ? CrossAxisAlignment.start
                                            : CrossAxisAlignment.center,
                                    children: rangeState.isLoadingEvents
                                        ? [
                                            const LoadingCardWidget(lineCount: 3),
                                            const LoadingCardWidget(lineCount: 3),
                                            const LoadingCardWidget(lineCount: 3),
                                          ]
                                        : rangeState.events.isNotEmpty
                                            ? [
                                                for (var event
                                                    in rangeState.events)
                                                  _buildCard(),
                                              ]
                                            : [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3,
                                                  child: Text(
                                                    'No Events Available',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
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
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 3,
        child: LayoutBuilder(
          builder: (context, constraints) {
            Widget line(double factor) => Skeleton.shade(
                  child: Container(
                    width: constraints.maxWidth * factor,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton.shade(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 6,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (int i = 0; i < 3; i++) ...[
                  line(factors[i % factors.length]),
                  const SizedBox(height: 8),
                ],
              ],
            );
          },
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
          bottomLeft: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              child: Row(
            children: [
              Column(
                children: [
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
                ],
              ),
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

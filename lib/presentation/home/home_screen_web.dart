import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/core/routing/app_router.dart';
import 'package:gun_range_app/data/models/event.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/presentation/widgets/loading_card_widget.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    //Ranges and Events would be fetched from ViewModels
    final rangeState = ref.watch(rangeViewModelProvider);

    //Get user authentication state
    final isAuthed = ref.watch(isAuthenticatedProvider);

    User? currentUser;

    if (isAuthed) {
      currentUser =
          ref.read(rangeViewModelProvider.notifier).getCurrentUser() as User?;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Scrollbar(
                                controller: _horizontalRangeController,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: _horizontalRangeController,
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          rangeState.isLoadingRanges ||
                                                  rangeState.ranges.isNotEmpty
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.center,
                                      children: rangeState.isLoadingRanges
                                          ? [
                                              const LoadingCardWidget(
                                                  lineCount: 3),
                                              const LoadingCardWidget(
                                                  lineCount: 3),
                                              const LoadingCardWidget(
                                                  lineCount: 3),
                                            ]
                                          : rangeState.ranges.isNotEmpty
                                              ? [
                                                  for (var range
                                                      in rangeState.ranges)
                                                    _buildCardRange(
                                                        range: range,
                                                        isAuthed: isAuthed,
                                                        user: currentUser),
                                                ]
                                              : [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    height:
                                                        MediaQuery.of(context)
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
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Events',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: _horizontalCompetitionController,
                                child: SingleChildScrollView(
                                  controller: _horizontalCompetitionController,
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          rangeState.isLoadingEvents ||
                                                  rangeState.events.isNotEmpty
                                              ? MainAxisAlignment.spaceEvenly
                                              : MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          rangeState.isLoadingEvents ||
                                                  rangeState.events.isNotEmpty
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.center,
                                      children: rangeState.isLoadingEvents
                                          ? [
                                              const LoadingCardWidget(
                                                  lineCount: 3),
                                              const LoadingCardWidget(
                                                  lineCount: 3),
                                              const LoadingCardWidget(
                                                  lineCount: 3),
                                            ]
                                          : rangeState.events.isNotEmpty
                                              ? [
                                                  for (var event
                                                      in rangeState.events)
                                                    _buildCardEvent(
                                                        event: event,
                                                        isAuthed: isAuthed,
                                                        user: currentUser),
                                                ]
                                              : [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    height:
                                                        MediaQuery.of(context)
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

  Widget _buildCardEvent({Event? event, required bool isAuthed, User? user}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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

                return Stack(
                  children: [
                    Column(
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
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              Text(event?.title ?? 'Range Name',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(event?.description ?? 'Range Location',
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                      )),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    child: const Text('OPEN'),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.3),
                        ),
                        onPressed: !isAuthed
                            ? null
                            : () {
                                if (user == null) return;

                                ref
                                    .read(rangeViewModelProvider.notifier)
                                    .addFavorite(
                                      user.id,
                                      event?.id ?? '',
                                    );
                              },
                        icon: Icon(
                          Icons.favorite_border_outlined,
                          color: isAuthed ? Colors.red : null,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardRange({Range? range, required bool isAuthed, User? user}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => {
          context.go('/range-detail/${range?.id}'),
        },
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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

                return Stack(
                  children: [
                    Column(
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
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              Text(range?.name ?? 'Range Name',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(range?.description ?? 'Range Location',
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        overflow: TextOverflow.ellipsis,
                                      )),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    child: const Text('OPEN'),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.3),
                        ),
                        onPressed: !isAuthed
                            ? null
                            : () {
                                if (user == null) return;

                                ref
                                    .read(rangeViewModelProvider.notifier)
                                    .addFavorite(
                                      user?.id ??
                                          '', // Replace with actual user ID
                                      range?.id ?? '',
                                    );
                              },
                        icon: Icon(
                          Icons.favorite_border_outlined,
                          color: isAuthed ? Colors.red : null,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

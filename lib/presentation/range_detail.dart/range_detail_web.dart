import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/presentation/widgets/review_widget.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RangeDetailWeb extends ConsumerStatefulWidget {
  final String? rangeId;
  const RangeDetailWeb({super.key, this.rangeId});

  @override
  ConsumerState<RangeDetailWeb> createState() => _RangeDetailWebState();
}

class _RangeDetailWebState extends ConsumerState<RangeDetailWeb> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRangeDetails();
    });
  }

  Future<void> _loadRangeDetails() async {
    await ref
        .watch(rangeDetailViewModelProvider.notifier)
        .fetchRangeDetail(widget.rangeId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final rangeDetailState = ref.watch(rangeDetailViewModelProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPictureSection(
              isLoading: rangeDetailState.isLoading,
              range: rangeDetailState.range,
            ),
            const SizedBox(height: 16),
            _buildInfoSection(
              isLoading: rangeDetailState.isLoading,
              range: rangeDetailState.range,
            ),
            const SizedBox(height: 16),
            ReviewsSection(
              rangeId: widget.rangeId ?? '',
              isLoading: rangeDetailState.isLoadingReviews,
              // initialReviews: rangeDetailState.reviews,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPictureSection({
    bool isLoading = false,
    Range? range,
  }) {
    return Skeletonizer(
      enabled: isLoading,
      child: Skeleton.leaf(
        enabled: isLoading,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: const Center(child: Text('Picture Section Placeholder')),
        ),
      ),
    );
  }

  Widget _buildInfoSection({bool isLoading = false, Range? range}) {
    return Skeletonizer(
      enabled: isLoading,
      child: Skeleton.leaf(
        enabled: isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    range?.name ?? 'Loading name...',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Book Now'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withOpacity(0.3)),
                          foregroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.onSurface),
                          elevation: WidgetStateProperty.all<double>(0),
                        ),
                        onPressed: () {},
                        child: const Text('Reviews'),
                      ),
                    ],
                  )
                ],
              ),
            if (!isLoading) const SizedBox(height: 8),
            if (!isLoading)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    range?.description ?? 'Loading description...',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    maxLines: _isExpanded ? null : 3,
                  ),
                  if ((range?.description?.length ?? 0) > 0)
                    const SizedBox(height: 8),
                  if ((range?.description?.length ?? 0) > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.transparent),
                            foregroundColor: WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.onSurface),
                            elevation: WidgetStateProperty.all<double>(0),
                          ),
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(_isExpanded ? 'Read less' : 'Read more'),
                        ),
                      ],
                    )
                ],
              ),
            if (isLoading) _buildLines(3),
          ],
        ),
      ),
    );
  }

  Widget _buildLines(int lineCount) {
    return LayoutBuilder(builder: (context, constraints) {
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
        children: List<Widget>.generate(lineCount, (i) {
          final factors = [0.85, 0.55, 0.70];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              line(factors[i % factors.length]),
              const SizedBox(height: 8),
            ],
          );
        }),
      );
    });
  }
}

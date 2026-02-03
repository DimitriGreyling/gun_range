import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/core/constants/general_constants.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReviewsSection extends ConsumerStatefulWidget {
  final String rangeId;
  final bool isLoading;

  const ReviewsSection({
    super.key,
    required this.rangeId,
    required this.isLoading,
    // initialReviews is no longer needed
  });

  @override
  ConsumerState<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends ConsumerState<ReviewsSection> {
  final Set<int> _expandedReviews = {};
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReviews();
    });
  }

  Future<void> _loadReviews({int page = 1}) async {
    setState(() {
      _isLoadingMore = true;
    });

    final pagedItems =
        await ref.read(rangeDetailViewModelProvider.notifier).fetchReviews(
              rangeId: widget.rangeId,
              page: page,
              pageSize: GeneralConstants.pageSize,
            );

    setState(() {
      _isLoadingMore = false;
      if (pagedItems != null) {
        _currentPage = page;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pagedItems = ref.watch(rangeDetailViewModelProvider).reviews;
    final reviews = pagedItems?.items ?? [];
    final totalCount = pagedItems?.totalCount ?? 0;
    final hasMore = pagedItems?.hasMore ?? false;
    final int totalPages =
        (totalCount / GeneralConstants.pageSize).ceil().clamp(1, 9999);

    if (widget.isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                final isExpanded = _expandedReviews.contains(index);
                const reviewText = 'Loading review content...';
                const showReadMore = reviewText.length > 100;

                return Skeletonizer(
                  enabled: true,
                  child: Skeleton.leaf(
                    enabled: true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Loading...'),
                                    _buildRatingStars(5),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Loading review content...',
                                  maxLines: isExpanded ? null : 2,
                                  overflow: isExpanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                ),
                                if (showReadMore)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (isExpanded) {
                                              _expandedReviews.remove(index);
                                            } else {
                                              _expandedReviews.add(index);
                                            }
                                          });
                                        },
                                        child: Text(isExpanded
                                            ? 'Read less'
                                            : 'Read more'),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
    if (reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text('No reviews yet.'),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: _currentPage > 1 && !_isLoadingMore
                    ? () => _loadReviews(page: _currentPage - 1)
                    : null,
              ),
              Text('Page $_currentPage of $totalPages'),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed:
                    (_currentPage < totalPages && !_isLoadingMore && hasMore)
                        ? () => _loadReviews(page: _currentPage + 1)
                        : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                final isExpanded = _expandedReviews.contains(index);
                final reviewText = review?.description ?? '';
                final showReadMore = reviewText.length > 100;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 0,
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(review?.title ?? ''),
                                _buildRatingStars(review?.rating),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reviewText,
                              maxLines: isExpanded ? null : 2,
                              overflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            if (showReadMore)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isExpanded) {
                                          _expandedReviews.remove(index);
                                        } else {
                                          _expandedReviews.add(index);
                                        }
                                      });
                                    },
                                    child: Text(
                                        isExpanded ? 'Read less' : 'Read more'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int? rating) {
    final stars = <Widget>[];
    final filledStars = rating ?? 0;
    const totalStars = GeneralConstants.ratingLimit;

    for (var i = 0; i < filledStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }
    for (var i = filledStars; i < totalStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
    }

    return Row(children: stars);
  }
}

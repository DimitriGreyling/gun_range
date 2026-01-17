import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

const factors = [0.85, 0.55, 0.70];

class LoadingCardWidget extends StatelessWidget {
  final int lineCount;
  const LoadingCardWidget({super.key, required this.lineCount});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Card(
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
                  for (int i = 0; i < lineCount; i++) ...[
                    line(factors[i % factors.length]),
                    const SizedBox(height: 8),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

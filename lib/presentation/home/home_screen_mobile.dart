import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/presentation/widgets/event_card_widget.dart';

class HomeScreenMobile extends ConsumerWidget {
  HomeScreenMobile({Key? key}) : super(key: key);

  ScrollController _scrollControllerRanges = ScrollController();
  ScrollController _scrollControllerEvents = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'San Francisco, CA',
                        style: TextStyle(
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.expand_more,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications,
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(Icons.search,
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600]),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search ranges or events...',
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          hintStyle: TextStyle(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[600]),
                        ),
                        style: TextStyle(
                            color: theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.tune,
                          color: theme.brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600]),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            // Featured Ranges Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Featured Ranges',
                      style: TextStyle(
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  TextButton(
                    onPressed: () {},
                    child: Text('See All',
                        style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            // Featured Ranges Carousel
            SizedBox(
              height: 220,
              child: ListView(
                controller: _scrollControllerRanges,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBDE7aJE9xr_kNqHlKkFU7qMXelX2IXwUMu6iiQIeYvklO7uXcZ5M5tizq1rK7EjNXDgDeLoKW2wtPA7h0V1E0Td_enoQlystQezmfDaWF9EPl9WXqCWHn4MvI2cF5FT9vsM59bfMem77rHoK4j79RZlOIISlPVUZnJfk8casX8kBSRr7hOCHLpZjicXcYGOOtK-k7--lnoBDT65lh_UcE8VEan4XlN36XgJUTDWZVtYXY43ITxR1LC0tnk8ASJuER-GDvR4c-yh79n',
                    name: 'SafeShot Range',
                    details: '1.2 mi away - 4.8 stars',
                  ),
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCVqEaRPV6m6GEfqV93SJ_9-6vOnsdKA2JN_H2i3uTBST5Ks0u9IDkM50TmcPpL4VLXXmDEPtffqWSbkI9atTD760UL7hU7lunYznRX3P_31Hho4xZV0miTBAQQ5cyjKaGsRrqfhVR71qW502iE874XCrFYAg6Z3VJHAeqbkHfPoVGxMdg4i9eplaoR_7KiljSVGzOUy3Crtp7endEhv4X2Xg4NiG-A5jKi7OLWCvERv7Cz6_Yt5zXu19PCF6WOlZDoOBKRf56N6mJA',
                    name: 'Frontier Firing Lines',
                    details: '3.5 mi away - 4.9 stars',
                  ),
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCXRlY_71gRY6kpWdwuLDbwG2uwZTZ9xtQL-WrgzU0WpXmcMhO0BEONp615tjV5E52w7jZohRb4gIvNZAFKFWdcedcYoeXFmZNVbxQwGf2GzJ0FFiouh74Dqshsac4WD6n56T2dCu0ktJ1OGtzezHL2yAuQ4-v76M2sQULVKggfMW78w9_H2bzFEYPkVQHzkAiO46pXGt1iSqhQC9BPTHYT0KonDUuzOAQjd3ttq-DOnvJMIo6s3xiICdNMeYIo_HsRfC5slWkhfPpC',
                    name: 'Precision Marksmanship Center',
                    details: '5.1 mi away - 4.7 stars',
                  ),
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCVqEaRPV6m6GEfqV93SJ_9-6vOnsdKA2JN_H2i3uTBST5Ks0u9IDkM50TmcPpL4VLXXmDEPtffqWSbkI9atTD760UL7hU7lunYznRX3P_31Hho4xZV0miTBAQQ5cyjKaGsRrqfhVR71qW502iE874XCrFYAg6Z3VJHAeqbkHfPoVGxMdg4i9eplaoR_7KiljSVGzOUy3Crtp7endEhv4X2Xg4NiG-A5jKi7OLWCvERv7Cz6_Yt5zXu19PCF6WOlZDoOBKRf56N6mJA',
                    name: 'Frontier Firing Lines',
                    details: '3.5 mi away - 4.9 stars',
                  ),
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCVqEaRPV6m6GEfqV93SJ_9-6vOnsdKA2JN_H2i3uTBST5Ks0u9IDkM50TmcPpL4VLXXmDEPtffqWSbkI9atTD760UL7hU7lunYznRX3P_31Hho4xZV0miTBAQQ5cyjKaGsRrqfhVR71qW502iE874XCrFYAg6Z3VJHAeqbkHfPoVGxMdg4i9eplaoR_7KiljSVGzOUy3Crtp7endEhv4X2Xg4NiG-A5jKi7OLWCvERv7Cz6_Yt5zXu19PCF6WOlZDoOBKRf56N6mJA',
                    name: 'Frontier Firing Lines',
                    details: '3.5 mi away - 4.9 stars',
                  ),
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCVqEaRPV6m6GEfqV93SJ_9-6vOnsdKA2JN_H2i3uTBST5Ks0u9IDkM50TmcPpL4VLXXmDEPtffqWSbkI9atTD760UL7hU7lunYznRX3P_31Hho4xZV0miTBAQQ5cyjKaGsRrqfhVR71qW502iE874XCrFYAg6Z3VJHAeqbkHfPoVGxMdg4i9eplaoR_7KiljSVGzOUy3Crtp7endEhv4X2Xg4NiG-A5jKi7OLWCvERv7Cz6_Yt5zXu19PCF6WOlZDoOBKRf56N6mJA',
                    name: 'Frontier Firing Lines',
                    details: '3.5 mi away - 4.9 stars',
                  ),
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCVqEaRPV6m6GEfqV93SJ_9-6vOnsdKA2JN_H2i3uTBST5Ks0u9IDkM50TmcPpL4VLXXmDEPtffqWSbkI9atTD760UL7hU7lunYznRX3P_31Hho4xZV0miTBAQQ5cyjKaGsRrqfhVR71qW502iE874XCrFYAg6Z3VJHAeqbkHfPoVGxMdg4i9eplaoR_7KiljSVGzOUy3Crtp7endEhv4X2Xg4NiG-A5jKi7OLWCvERv7Cz6_Yt5zXu19PCF6WOlZDoOBKRf56N6mJA',
                    name: 'Frontier Firing Lines',
                    details: '3.5 mi away - 4.9 stars',
                  ),
                ],
              ),
            ),
            // Upcoming Events Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Upcoming Events',
                      style: TextStyle(
                          color: theme.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  TextButton(
                    onPressed: () {},
                    child: Text('See All',
                        style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            // Upcoming Events Carousel
            SizedBox(
              height: 220,
              child: ListView(
                controller: _scrollControllerEvents,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDnv9mJuTuAZAq8FPDTny8TZAaWyC6akSj70QGK5XlW4WMSsPrQ8kJeOaf7e4Ya6O3VhvuoXvvoo17QFUrA1L5x4RYiYBtLCh5xuvxfjgtGVsFBnRuljBHsu4zs9eEwOdTe-P8hnEHwbRv_qmZILk_0-PlA3GE-TLUFYYkSurlwhTTFPFRb5JppDx4z6Pi6o4lfKGpiSIoW9b3i281nnU-Pn21NGCECul3UDExGz2YPlIf_TFf36aN1Ty8ox1Os4mMcx8SxecY5EHEY',
                    name: 'Pistol Skills Workshop',
                    details: 'Tomorrow, 6 PM - SafeShot Range',
                    buttonText: 'Book Now',
                  ),
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCBFjf3qDur85BanhUWb1J26qmmYxtnW5zMTn-RdWXy3KeM5-RwQscrChhpEjrv6otZzv9Izo8svsIZKTmxQY9Wm0jHdW1qnQo2OKL1kGy_yBMsjd0Y1aEGDT7wATzquZUxh8Qj9X4udPvX70tOSk0ut6C-Va_TXDkPF1Tpz30CY0T1s-S5vZo5LaqoJp8Qe5rfegtrBw-M3LohoQik-xkqK0nSNFHeeGsO_LdfPmgIEX43uNH6HwktPu5HD1I-cAR-R2XYrPi6-FAM',
                    name: 'Long Range Intro Course',
                    details: 'Sat, 10 AM - Frontier Firing Lines',
                    buttonText: 'Book Now',
                  ),
                  EventCardWidget(
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCiEllP11Lsh6fJbJlvGzlXTG_e9ZJie0-gZsar09jEpTLgl7u4wp0OfqvSrhshujAKKQwL5tjMcDf122Bsgsz_6lpAqBBR4J3v8N_j1lXy9W5T4XshxmXwZiiSClnLpwsZsRlUbDN9j9rwXVdpq2ljcUaoDJlXnnFMKiuu_sRj9WsCdadOILEKsWea3WzFrF-MKrL0KJISNDbx-98jSN6g4iJABpA4ffhj69IxXdRZMJMhjZer08IVY-iqsddYC9BeJfKlm3LZw90U',
                    name: 'Trap & Skeet Tournament',
                    details: 'Sun, 9 AM - Clay Target Club',
                    buttonText: 'Book Now',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor.withOpacity(0.8),
          border: Border(
              top: BorderSide(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.5))),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
                icon: Icons.home,
                label: 'Home',
                selected: true,
                color: theme.primaryColor),
            _NavItem(
                icon: Icons.explore,
                label: 'Ranges',
                selected: false,
                color: theme.brightness == Brightness.dark
                    ? Colors.grey[400]!
                    : Colors.grey[600]!),
            _NavItem(
                icon: Icons.calendar_today,
                label: 'Bookings',
                selected: false,
                color: theme.brightness == Brightness.dark
                    ? Colors.grey[400]!
                    : Colors.grey[600]!),
            _NavItem(
                icon: Icons.person,
                label: 'Profile',
                selected: false,
                color: theme.brightness == Brightness.dark
                    ? Colors.grey[400]!
                    : Colors.grey[600]!),
          ],
        ),
      ),
    );
  }
}

class _RangeCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String details;
  const _RangeCard(
      {required this.imageUrl, required this.name, required this.details});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.black.withOpacity(0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(details,
                    style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                        fontSize: 13)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor.withOpacity(0.2),
                      foregroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    onPressed: () {},
                    child: const Text('View'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                color: color,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12)),
      ],
    );
  }
}

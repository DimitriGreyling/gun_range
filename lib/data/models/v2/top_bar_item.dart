class TopBarItem {
  const TopBarItem({
    required this.destination,
    required this.label,
    required this.routeName,
    required this.path,
  });

  final TopBarDestination destination;
  final String label;
  final String routeName;
  final String path;
}

enum TopBarDestination {
  home,
  ranges,
  events,
  profile,
  login,
  unknown,
}

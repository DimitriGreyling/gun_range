import 'dart:ui';

import 'package:flutter/material.dart';

class CategoryItem {
  const CategoryItem({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.tint,
  });

  final String title;
  final String subtitle;
  final String? imageUrl;
  final Color? tint;
}

class EventItem {
  const EventItem({
    required this.tag,
    required this.title,
    required this.date,
    required this.description,
    required this.tagColorSeed,
  });

  final String tag;
  final String title;
  final String date;
  final String description;
  final Color tagColorSeed;
}

class BenefitItem {
  const BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class TierItem {
  const TierItem({
    required this.label,
    required this.name,
    required this.price,
    required this.cta,
    required this.features,
    this.highlighted = false,
    this.badge,
  });

  final String label;
  final String name;
  final String price;
  final String cta;
  final List<String> features;
  final bool highlighted;
  final String? badge;
}

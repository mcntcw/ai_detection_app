import 'package:flutter/material.dart';

BoxDecoration roundedBorderBoxDecoration({
  required BuildContext context,
}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(180),
    border: Border.all(
      width: 0.6,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
}

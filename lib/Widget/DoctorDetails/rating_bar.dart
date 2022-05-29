import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

ratingBar({required double intialRating, double? itemSize ,  void Function(double)? onRatingUpdate}) {
  return RatingBar.builder(
    ignoreGestures: true,
    itemSize: itemSize ?? 17,
    initialRating: intialRating,
    minRating: 1,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemPadding: const EdgeInsets.only(right: 4.0),
    itemBuilder: (context, _) => const Icon(
      Icons.star,
      color: Colors.amber,
    ),
    onRatingUpdate: onRatingUpdate??(rating){},
  );
}

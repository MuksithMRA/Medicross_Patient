import 'package:flutter/cupertino.dart';

class RatingController extends ChangeNotifier {
  double initialRating = 0;

  onratingChanged(double rating) {
    initialRating = initialRating + rating;
    notifyListeners();
  }
}

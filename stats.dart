//  stats.dart
//  Probability_stats_utils
//
//  Copyright © 2020 valdezprojects
//  Manuel Valdez
//

import 'dart:math' as math;

class Stats<T> {
  
  List<T> list;
  List<T> sortedList;
  
  //
  // measured of central tendency
  //
  
  T min;
  T max;
  
  // mean
  T arithmeticMean;
  T geometricMean;
  T ponderedMean;

  T mode;
  T median;

  //
  // dispersion measure
  //
  // ---
  
  // constructor  
  Stats(List<T> this.list) {
    this.sortedList = []..addAll(list)..sort();
    
    this.max = sortedList.last;
    this.min = sortedList.first;
  }
  
  
  List<T> getMean() {
    // calculate mean if null then return value
    return [this.arithmeticMean, this.geometricMean, this.ponderedMean];
  }

  T getMode() {
    // calculate if null
    return this.mode;
  }

  T getMedian() {}
  
}

void main() {
  
  Stats test = Stats([10,5,3,4,5]);

  print(test.sortedList);
  print(test.min);
  print(test.max);
  
}


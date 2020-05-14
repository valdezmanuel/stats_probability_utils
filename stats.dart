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
  double summation;
  int n;

  double arithmeticMean;
  double geometricMean;
  double ponderedMean;

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

    this.n = sortedList.length;
    // sum all elements in list
    this.summation = sortedList.fold(0, (previousValue, element) => previousValue + (element as num));
  }
  
  
  List<double> getMean() {
    // calculate mean if null then return value
    if (this.arithmeticMean == null) 
      this.arithmeticMean = this.summation / n;

    if (this.geometricMean == null)
      this.geometricMean = math.pow(summation, 1/n);
    
    if (this.ponderedMean == null) {
      // PM = p1*X1 + p2*X2 + pn*Xn / n 
      // frecuency assigned as default weight (p)
      this.ponderedMean = this.getFrecuencies().fold(0, (previousValue, element) => 
          previousValue + ( (element[0] as num) * (element[1] as num))) / n;
    }
    return [this.arithmeticMean, this.geometricMean, this.ponderedMean];
  }

  // return [ [el, frecuency], [] ]
  List<List<T>> getFrecuencies() {

    List<List<T>> result = new List<List<T>>();
    T tmpValue = sortedList[0];
    int curFrecuency = 0;

    for(int i = 1 ; i < sortedList.length ; i++) {
      curFrecuency++;

      if (tmpValue != sortedList[i] || i == (sortedList.length - 1)){

        if (i == (sortedList.length-1) && tmpValue == sortedList[i])
            curFrecuency++;

        result.add([tmpValue,(curFrecuency as T)]);

        if (i == (sortedList.length-1) && tmpValue != sortedList[i]) {
            result.add([sortedList[i],(1 as T)]);
        } 
        curFrecuency = 0;
      } 
      
      tmpValue = sortedList[i];
    }

    return result;
  }

  T getMode() {
    // calculate if null
    return this.mode;
  }

  T getMedian() {}
  
}

void main() {
  
  // Stats test = Stats([1,1,4,5,4,3,4,7,7,8,9,0.5,10.2]);

    Stats test = Stats([1,1,2,2]);


  print(test.sortedList);
  print(test.min);
  print(test.max);
  print(test.summation);
  print(test.getMean());

  print(test.getFrecuencies());
  
}


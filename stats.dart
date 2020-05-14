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
  List<List<T>> frecuenciesList;
  
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

    // init lists
    this.sortedList = []..addAll(list)..sort();
    this.frecuenciesList = new List<List<T>>();
    
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

    if (this.geometricMean == null) {
      // GM = (x1*x2...xn)^(1/n)
      var xn = this.sortedList.fold(sortedList[0], (previousValue, element) => previousValue*element);
      this.geometricMean = math.pow(xn, 1/n);
    }
    
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

    if (frecuenciesList.length != 0) 
      return frecuenciesList;

    T tmpValue = sortedList[0];
    int curFrecuency = 0;

    for(int i = 1 ; i < sortedList.length ; i++) {
      curFrecuency++;

      if (tmpValue != sortedList[i] || i == (sortedList.length - 1)){

        if (i == (sortedList.length-1) && tmpValue == sortedList[i])
            curFrecuency++;

        frecuenciesList.add([tmpValue,(curFrecuency as T)]);

        if (i == (sortedList.length-1) && tmpValue != sortedList[i]) {
            frecuenciesList.add([sortedList[i],(1 as T)]);
        } 
        curFrecuency = 0;
      } 
      
      tmpValue = sortedList[i];
    }

    return frecuenciesList;
  }

  T getMode() {
    // calculate if null
    if (this.mode == null) {  
      List<T> tmpMode = new List<T>();
      tmpMode = getFrecuencies()[0];

      for (var i = 1; i < getFrecuencies().length; i++) {
        if ((tmpMode[1] as num) < (getFrecuencies()[i][1] as num)) {
          tmpMode = getFrecuencies()[i];
        }
      }
      this.mode = tmpMode[0];
    }

    return this.mode;
  }

  T getMedian() {
    if (this.median == null) {
      if (n % 2 == 0)
        this.median = this.sortedList[ ((n + 1) ~/ 2)];
      else
        this.median = this.sortedList[n ~/ 2];
    }

    return this.median;
  }
  
}

void main() {
  
  // Stats test = Stats([1,1,4,5,4,3,4,7,7,8,9,0.5,10.2]);

    Stats test = Stats([1,1,2,2,7,8.7,.1,7,9.6,6,7,8]);


  print(test.sortedList);
  print(test.min);
  print(test.max);
  print(test.summation);
  print(test.getMean());
  print(test.getFrecuencies());
  print("----");
  print(test.getMode());
  print(test.getMedian());

  
}


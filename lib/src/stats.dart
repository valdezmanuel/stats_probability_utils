//  stats.dart
//  Probability_stats_utils
//
//  Copyright © 2020 valdezprojects, Yovanny Nogales
//  Manuel Valdez, Yovanny Nogales
//

import 'dart:math' as math;

class Stats<T> {
  
  List<T> list;
  List<T> sortedList;
  List<List<T>> frecuenciesList;
  List<Map<String, dynamic>> _groupedFrecuencyMap;
  //
  // measured of central tendency
  //

  num min;
  num max;
  
  // mean
  double summation;
  int n;
  double arithmeticMean;
  double geometricMean;
  double ponderedMean;

  List<T> mode;
  T median;

  //
  // dispersion measure
  //
  // ---
  List<double> standardDeviation;
  List<double> variance;
  num range;


  // Grouped Data
  int k;
  double ai;
   
  // constructor  
  Stats(List<T> this.list) {

    // init lists
    this.sortedList = []..addAll(list)..sort();
    this.frecuenciesList = new List<List<T>>();
    
    this.max = sortedList.last as num;
    this.min = sortedList.first as num;

    this.range =  this.max - this.min;

    this.n = sortedList.length;
    // sum all elements in list
    this.summation = sortedList.fold(0, (previousValue, element) => previousValue + (element as num));

    // Generates the frecuency table of grouped data
    this._groupedFrecuencyMap = this._calculateGroupedFrecuencyMap();
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

    // O(n)
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
  
  List<T> getMode() {
    // calculate if null
    if (this.mode == null) {  
      List<T> tmpModes = new List<T>();
      List<T> tmpMode = new List<T>();

      tmpMode = getFrecuencies()[0];
      tmpModes.add(tmpMode[0]);

      // O(n)
      for (var i = 1; i < getFrecuencies().length; i++) {
        
        // cur element appears more times than curMode 
        if ((tmpMode[1] as num) < (getFrecuencies()[i][1] as num)) {
          tmpMode = getFrecuencies()[i];
          tmpModes.clear();
          tmpModes.add(tmpMode[0]);
          continue;
        }
        // if cur element has same frecuency than tmpMode then is added to list
        if ((tmpMode[1] as num) == (getFrecuencies()[i][1] as num)) {
          tmpModes.add(getFrecuencies()[i][0]);
        }
      }
      this.mode = tmpModes;
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

  // [sample,population]
  List<double> getVariance() {
    if (this.variance == null) {
      // E (Xi-mean) : i = 1 to n
      double Xn = this.sortedList.fold(0, (previousValue, element) => 
        previousValue + math.pow((element as num) - this.getMean()[0], 2)
      );            

      this.variance = [ (Xn / (this.n - 1)) , Xn / this.n ] ;

    }
    return this.variance;
  }

  // [sample,population]
  List<double> getStandardDeviation() {
    if (this.standardDeviation == null) {
      this.standardDeviation =  [math.sqrt(this.getVariance()[0]), math.sqrt(this.getVariance()[1])];
    }

    return this.standardDeviation;
  }

  num getRange() {
    return this.range;
  }

  //  Agrouped data
  
  int getIntervalsBySturgesRule() {
    //  3.22 * math.log10(this.n);
    if (this.k != null)
      return this.k;
    // ln/ln10 = log10
    double k =  1 + (3.322 * (math.log(this.n)/math.ln10));
    int floorK = k.floor();

    if (floorK % 2 == 0)
       this.k = floorK + 1;
    else
      this.k = floorK;

    return this.k;
  }

  int getIntervalsByNumber(int classes) {
    double k =  classes/this.n;
    int floorK = k.floor();
    if (floorK % 2 == 0)
      return floorK + 1;
    return floorK;
  }

  double getAmplitude() {
    if (this.ai != null)
      return this.ai;

    // sturges rule by default
    this.ai = this.getRange() / this.getIntervalsBySturgesRule();
    return this.ai;
  }

  /// Gets grouped frecuency map
  List<Map<String, dynamic>> getGroupedFrecuencyMap() {
    return _groupedFrecuencyMap;
  }

  /// Generates a grouped frecuency map through a list
  List<Map<String, dynamic>> _calculateGroupedFrecuencyMap() {
    List<Map<String, dynamic>> groupedFrecuencyMap = List<Map<String, dynamic>>();

    int indexOfClass = 0;
    Map<String, dynamic> classLimitElement = Map<String, dynamic>();
    
    // Gets amplitude and intervals of data
    final amplitudeOfInterval = this.getAmplitude();
    final numberOfIntervals = this.getIntervalsBySturgesRule();
    // Defines frecuencies
    int accumulatedFrecuency = 0;
    // Defines the class limits
    double lowerClassLimit = this.min.toDouble();
    double upperClassLimit = 0.0;

    // Calculates the limit class and results
    for (indexOfClass; indexOfClass < numberOfIntervals; indexOfClass++) {
      classLimitElement = Map<String, dynamic>();

      // Initializes the class limits
      classLimitElement['lowerClassLimit'] = lowerClassLimit;
      upperClassLimit = lowerClassLimit + amplitudeOfInterval;
      classLimitElement['upperClassLimit'] = upperClassLimit;

      // Calculates the mid point of the class limit
      classLimitElement['midPoint'] = this._calculateMidPoint(
        lowerClassLimit: classLimitElement['lowerClassLimit'],
        upperClassLimit: classLimitElement['upperClassLimit']
      );

      // Calculates absolute frecuencies for class limit
      classLimitElement['absolueteFrecuency'] = this._calculateAbsoluteFrecuency(
        lowerClassLimit: classLimitElement['lowerClassLimit'],
        upperClassLimit: classLimitElement['upperClassLimit']
      );

      classLimitElement['accumulatedRelativeFrecuency'] = this._calculateAbsoluteRelativeFrecuency(
        absolueteFrecuency: classLimitElement['absolueteFrecuency'].toDouble()
      );

      accumulatedFrecuency += classLimitElement['absolueteFrecuency'];
      classLimitElement['accumulatedFrecuency'] = accumulatedFrecuency;

      groupedFrecuencyMap.add(classLimitElement);

      // Reasigns the lower class limit for the next class limit iteration
      lowerClassLimit = upperClassLimit;
    }

    return groupedFrecuencyMap;
  }

  /// Calculates a mid point for a class limit
  double _calculateMidPoint({
    double lowerClassLimit,
    double upperClassLimit
  }) {
    return (lowerClassLimit + upperClassLimit) / 2;
  }

  /// Calculates absolute frecuency for a class limit
  int _calculateAbsoluteFrecuency({
    double lowerClassLimit,
    double upperClassLimit
  }) {
    int counterOfFrecuncy = 0;
    int indexInSortedList = 0;
    for (indexInSortedList; indexInSortedList < this.sortedList.length; indexInSortedList++) {
      if (
        (this.sortedList[indexInSortedList] as num) >= lowerClassLimit &&
        (this.sortedList[indexInSortedList] as num) < upperClassLimit
      )
        counterOfFrecuncy++;
    }
    // print(this.sortedList.where(item => item >= lowerClassLimit && item < upperClassLimit));
    return counterOfFrecuncy;
  }

  /// Calculates absolute relative frecuency for a class limit
  double _calculateAbsoluteRelativeFrecuency({
    double absolueteFrecuency
  }) {
    return absolueteFrecuency / this.n;
  }
}
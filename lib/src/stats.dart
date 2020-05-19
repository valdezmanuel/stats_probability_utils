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
  num median;
  int _medianPosition;

  //
  // dispersion measure
  //
  // ---
  List<double> standardDeviation;
  List<double> variance;
  num range;

  // grouped data
  List<double> standardDeviationGrouped;
  List<double> varianceGrouped;

  int k;
  double ai;

  // Grouped mean
  double _summationOfXiFi;
  double _groupedMean;

  // Grouped median
  double _groupedMedian;

  // Grouped mode
  List<double> _groupedMode;
  int _maxFrecuencyClass;

  // position measures
  List<num> quartiles;
  List<num> deciles;
  List<num> percentiles;

  // constructor
  Stats(List<T> list) {
    // init lists
    sortedList = [...list]..sort();
    frecuenciesList = <List<T>>[];

    max = sortedList.last as num;
    min = sortedList.first as num;

    range = max - min;

    n = sortedList.length;
    // sum all elements in list
    summation = sortedList.fold(
        0, (previousValue, element) => previousValue + (element as num));
  }

  List<double> getMean() {
    // calculate mean if null then return value
    arithmeticMean ??= summation / n;

    if (geometricMean == null) {
      // GM = (x1*x2...xn)^(1/n)
      final xn = sortedList.fold(sortedList[0],
          (previousValue, element) => previousValue * element) as num;
      geometricMean = math.pow(xn, 1 / n) as double;
    }

    ponderedMean ??= getFrecuencies().fold(
            0,
            (previousValue, element) =>
                previousValue + ((element[0] as num) * (element[1] as num))) /
        n as double;

    return [arithmeticMean, geometricMean, ponderedMean];
  }

  // return [ [el, frecuency], [] ]
  List<List<T>> getFrecuencies() {
    if (frecuenciesList.isNotEmpty) {
      return frecuenciesList;
    }

    var tmpValue = sortedList[0];
    var curFrecuency = 0;

    // O(n)
    for (var i = 1; i < sortedList.length; i++) {
      curFrecuency++;

      if (tmpValue != sortedList[i] || i == (sortedList.length - 1)) {
        if (i == (sortedList.length - 1) && tmpValue == sortedList[i]) {
          curFrecuency++;
        }

        frecuenciesList.add([tmpValue, (curFrecuency as T)]);

        if (i == (sortedList.length - 1) && tmpValue != sortedList[i]) {
          frecuenciesList.add([sortedList[i], (1 as T)]);
        }
        curFrecuency = 0;
      }

      tmpValue = sortedList[i];
    }

    return frecuenciesList;
  }

  List<T> getMode() {
    // calculate if null
    if (mode == null) {
      final tmpModes = <T>[];
      var tmpMode = <T>[];

      tmpMode = getFrecuencies()[0];
      tmpModes.add(tmpMode[0]);

      // O(n)
      for (var i = 1; i < getFrecuencies().length; i++) {
        // cur element appears more times than curMode
        if ((tmpMode[1] as num) < (getFrecuencies()[i][1] as num)) {
          tmpMode = getFrecuencies()[i];
          tmpModes
            ..clear()
            ..add(tmpMode[0]);
          continue;
        }
        // if cur element has same frecuency than tmpMode then is added to list
        if ((tmpMode[1] as num) == (getFrecuencies()[i][1] as num)) {
          tmpModes.add(getFrecuencies()[i][0]);
        }
      }
      mode = tmpModes;
    }

    return mode;
  }

  int _getMedianPosition() {
    if (_medianPosition == null) {
      if (n % 2 == 0) {
        _medianPosition = (n + 1) ~/ 2;
      } else {
        _medianPosition = n ~/ 2;
      }
    }

    return _medianPosition;
  }

  num getMedian() {
    if (median == null) {
      if (n % 2 == 0) {
        median =
            ((sortedList[n ~/ 2 - 1] as num) + (sortedList[n ~/ 2] as num)) / 2;
      } else {
        median = sortedList[n ~/ 2] as num;
      }
    }
    return median;
  }

  num _getMedianOfList(List<T> list) {
    list.sort();
    final _n = list.length;
    var medianOfList = list[_n ~/ 2] as num;

    if (_n % 2 == 0) {
      medianOfList =
          ((list[(_n ~/ 2) - 1] as num) + (list[_n ~/ 2] as num)) / 2;
    }

    return medianOfList;
  }

  // [sample,population]
  List<double> getVariance() {
    if (variance == null) {
      // E (Xi-mean) : i = 1 to n
      final xn = sortedList.fold(
              0,
              (previousValue, element) =>
                  previousValue + math.pow((element as num) - getMean()[0], 2))
          as double;

      variance = [(xn / (n - 1)), xn / n];
    }

    return variance;
  }

  // [sample,population]
  List<double> getStandardDeviation() => standardDeviation ??= [
        math.sqrt(getVariance()[0]),
        math.sqrt(getVariance()[1])
      ];

  @pragma('stats:gruped-frecuency-data-functions')
  num getRange() => range;

  //  Agrouped data

  int getIntervalsBySturgesRule() {
    //  3.22 * math.log10(this.n);
    if (this.k != null) {
      return this.k;
    }
    // ln/ln10 = log10
    final k = 1 + (3.322 * (math.log(n) / math.ln10));
    final floorK = k.floor();

    if (floorK % 2 == 0) {
      this.k = floorK + 1;
    } else {
      this.k = floorK;
    }

    return this.k;
  }

  int getIntervalsByNumber(int classes) {
    final k = classes / n;
    var floorK = k.floor();

    if (floorK % 2 == 0) {
      floorK += 1;
    }

    return floorK;
  }

  double getAmplitude() => ai ??= getRange() / getIntervalsBySturgesRule();

  /// Gets grouped frecuency map
  List<Map<String, dynamic>> getGroupedFrecuencyMap() =>
      _groupedFrecuencyMap ??= _calculateGroupedFrecuencyMap();

  /// Generates a grouped frecuency map through a list
  List<Map<String, dynamic>> _calculateGroupedFrecuencyMap() {
    final groupedFrecuencyMap = <Map<String, dynamic>>[];

    var indexOfClass = 0;
    var classLimitElement = <String, dynamic>{};

    _summationOfXiFi = 0.0;

    // Gets amplitude and intervals of data
    final amplitudeOfInterval = getAmplitude();
    final numberOfIntervals = getIntervalsBySturgesRule();
    // Defines frecuencies
    var accumulatedFrecuency = 0;
    // Defines the class limits
    var lowerClassLimit = min.toDouble();
    var upperClassLimit = 0.0;

    // Calculates the limit class and results
    for (indexOfClass = 0; indexOfClass < numberOfIntervals; indexOfClass++) {
      classLimitElement = <String, dynamic>{};

      // Initializes the class limits
      classLimitElement['lowerClassLimit'] = lowerClassLimit;
      upperClassLimit = lowerClassLimit + amplitudeOfInterval;
      classLimitElement['upperClassLimit'] = upperClassLimit;

      // Calculates the mid point of the class limit
      classLimitElement['midpoint'] = _calculateMidpoint(
          lowerClassLimit: classLimitElement['lowerClassLimit'] as double,
          upperClassLimit: classLimitElement['upperClassLimit'] as double);

      // Calculates absolute frecuencies for class limit
      classLimitElement['absoluteFrecuency'] = _calculateAbsoluteFrecuency(
          lowerClassLimit: classLimitElement['lowerClassLimit'] as double,
          upperClassLimit: classLimitElement['upperClassLimit'] as double);

      classLimitElement['accumulatedRelativeFrecuency'] =
          _calculateAbsoluteRelativeFrecuency(
              absoluteFrecuency: classLimitElement['absoluteFrecuency'] as int);

      accumulatedFrecuency += classLimitElement['absoluteFrecuency'] as int;
      classLimitElement['accumulatedFrecuency'] = accumulatedFrecuency;

      // Accumulates midpoint times absolute frecuency of class limit
      classLimitElement['XiFi'] = classLimitElement['midpoint'] *
          classLimitElement['absoluteFrecuency'];
      _summationOfXiFi += classLimitElement['XiFi'] as double;

      groupedFrecuencyMap.add(classLimitElement);

      // Reasigns the lower class limit for the next class limit iteration
      lowerClassLimit = upperClassLimit;
    }

    return groupedFrecuencyMap;
  }

  /// Calculates a mid point for a class limit
  double _calculateMidpoint({double lowerClassLimit, double upperClassLimit}) =>
      (lowerClassLimit + upperClassLimit) / 2;

  /// Calculates absolute frecuency for a class limit
  int _calculateAbsoluteFrecuency(
      {double lowerClassLimit, double upperClassLimit}) {
    var counterOfFrecuncy = 0;
    var indexInSortedList = 0;
    for (indexInSortedList = 0;
        indexInSortedList < sortedList.length;
        indexInSortedList++) {
      if ((sortedList[indexInSortedList] as num) >= lowerClassLimit &&
          (sortedList[indexInSortedList] as num) < upperClassLimit) {
        counterOfFrecuncy++;
      }
    }
    // print(this.sortedList.where(
    //   item => item >= lowerClassLimit && item < upperClassLimit)
    // );
    return counterOfFrecuncy;
  }

  /// Calculates absolute relative frecuency for a class limit
  double _calculateAbsoluteRelativeFrecuency({int absoluteFrecuency}) =>
      absoluteFrecuency / n;

  @pragma('stats:mean-of-group-data')

  /// Gets the media of grouped frecuency table
  double getMeanOfGroupedData() {
    _groupedFrecuencyMap ??= _calculateGroupedFrecuencyMap();

    return _groupedMean ??= _summationOfXiFi / n;
  }

  @pragma('stats:modian-of-group-data')

  /// Gets the median of grouped frecuency table
  double getMedianOfGroupedData() {
    _groupedFrecuencyMap ??= _calculateGroupedFrecuencyMap();

    if (_groupedMedian == null) {
      var indexOfGroupedFrecuencyMap = 0;
      final medianPosition = _getMedianPosition();
      var previousAccumulatedFrecuency = 0;
      var accumulatedFrecuency = 0;

      for (indexOfGroupedFrecuencyMap = 0;
          indexOfGroupedFrecuencyMap < _groupedFrecuencyMap.length;
          indexOfGroupedFrecuencyMap++) {
        accumulatedFrecuency = _groupedFrecuencyMap[indexOfGroupedFrecuencyMap]
            ['accumulatedFrecuency'] as int;

        if (indexOfGroupedFrecuencyMap > 0) {
          previousAccumulatedFrecuency =
              _groupedFrecuencyMap[indexOfGroupedFrecuencyMap - 1]
                  ['accumulatedFrecuency'] as int;
        }

        // Get median in upper class limit
        if (medianPosition ==
            _groupedFrecuencyMap[indexOfGroupedFrecuencyMap]
                ['accumulatedFrecuency']) {
          _groupedMedian = _groupedFrecuencyMap[indexOfGroupedFrecuencyMap]
              ['upperClassLimit'] as double;
          break;
        }
        // Calculates median
        else if (indexOfGroupedFrecuencyMap > 0 &&
            medianPosition < accumulatedFrecuency) {
          _groupedMedian = _calculateMedianOfGroupedData(
              lowerClassLimit: _groupedFrecuencyMap[indexOfGroupedFrecuencyMap]
                  ['lowerClassLimit'] as double,
              previousAccumulatedFrecuency: previousAccumulatedFrecuency,
              absoluteFrecuency:
                  _groupedFrecuencyMap[indexOfGroupedFrecuencyMap]
                      ['absoluteFrecuency'] as int);
          break;
        }
      }
    }

    return _groupedMedian;
  }

  /// Calculates the median of grouped frecuency data
  double _calculateMedianOfGroupedData(
          {double lowerClassLimit,
          int previousAccumulatedFrecuency,
          int absoluteFrecuency}) =>
      lowerClassLimit +
      ((((n / 2) - previousAccumulatedFrecuency) / absoluteFrecuency) *
          getAmplitude());

  @pragma('stats:mode-of-group-data')
  List<double> getModeOfGroupedData() {
    _groupedFrecuencyMap ??= _calculateGroupedFrecuencyMap();

    if (_groupedMode == null) {
      var indexOfGroupedFrecuencyMap = 0;
      final maxFrecuencyClass = _getMaxFrecuencyClass();
      var previousAbsoluteFrecuency = 0;
      var nextAbsoluteFrecuency = 0;

      _groupedMode = <double>[];

      for (indexOfGroupedFrecuencyMap = 0;
          indexOfGroupedFrecuencyMap < _groupedFrecuencyMap.length;
          indexOfGroupedFrecuencyMap++) {
        if (maxFrecuencyClass == 1) {
          break;
        }

        if (indexOfGroupedFrecuencyMap > 0) {
          previousAbsoluteFrecuency =
              _groupedFrecuencyMap[indexOfGroupedFrecuencyMap - 1]
                  ['absoluteFrecuency'] as int;
        }

        if (indexOfGroupedFrecuencyMap < _groupedFrecuencyMap.length - 1) {
          nextAbsoluteFrecuency =
              _groupedFrecuencyMap[indexOfGroupedFrecuencyMap + 1]
                  ['absoluteFrecuency'] as int;
        } else {
          nextAbsoluteFrecuency = 0;
        }

        // Get mode in max class limit with max absolute frecuency
        if (maxFrecuencyClass ==
            _groupedFrecuencyMap[indexOfGroupedFrecuencyMap]
                ['absoluteFrecuency']) {
          _groupedMode.add(_calculateModeOfGroupedData(
              lowerClassLimit: _groupedFrecuencyMap[indexOfGroupedFrecuencyMap]
                  ['lowerClassLimit'] as double,
              previousAbsoluteFrecuency: previousAbsoluteFrecuency,
              nextAbsoluteFrecuency: nextAbsoluteFrecuency,
              currentAbsoluteFrecuency:
                  _groupedFrecuencyMap[indexOfGroupedFrecuencyMap]
                      ['absoluteFrecuency'] as int));
        }
      }
    }

    return _groupedMode;
  }

  /// Calculates the median of grouped frecuency data
  double _calculateModeOfGroupedData(
      {double lowerClassLimit,
      int previousAbsoluteFrecuency,
      int nextAbsoluteFrecuency,
      int currentAbsoluteFrecuency}) {
    final previousSubstractionOfFi =
        currentAbsoluteFrecuency - previousAbsoluteFrecuency;
    final nextSubstractionOfFi =
        currentAbsoluteFrecuency - nextAbsoluteFrecuency;
    return lowerClassLimit +
        ((previousSubstractionOfFi /
                (previousSubstractionOfFi + nextSubstractionOfFi)) *
            getAmplitude());
  }

  /// Gets maximum absolute frecuency in the class limits
  int _getMaxFrecuencyClass() {
    _groupedFrecuencyMap ??= _calculateGroupedFrecuencyMap();

    if (_maxFrecuencyClass == null) {
      final tmpGroupedFrecuencyMap =
          List<Map<String, dynamic>>.from(_groupedFrecuencyMap)
            ..sort((a, b) => (a['absoluteFrecuency'] as num)
                .compareTo(b['absoluteFrecuency'] as num));
      _maxFrecuencyClass =
          tmpGroupedFrecuencyMap[tmpGroupedFrecuencyMap.length - 1]
              ['absoluteFrecuency'] as int;
    }

    return _maxFrecuencyClass;
  }

  // measures of dispersion for grouped data

  // [sample,population]
  List<double> getVarianceGrouped() {
    if (varianceGrouped == null) {
      final mean = getMeanOfGroupedData();
      // E (interval - mean)^2 * (frecuency)
      var sum = 0.0;
      for (var frecuencyRow in getGroupedFrecuencyMap()) {
        sum += math.pow((frecuencyRow['midpoint'] as double) - mean, 2) *
            (frecuencyRow['absoluteFrecuency'] as num) as double;
      }
      varianceGrouped = [sum / (n - 1), sum / n];
    }
    return varianceGrouped;
  }

  // [sample, population]
  List<double> getStandardDeviationGrouped() => standardDeviationGrouped ??= [
        math.sqrt(getVarianceGrouped()[0]),
        math.sqrt(getVarianceGrouped()[1])
      ];

  // position measures
  List<T> _copyListInRange(List<T> source, int start, int end) {
    final target = <T>[];
    if (source.length < end) {
      return null;
    }

    for (var i = start; i < end; ++i) {
      target.add(source[i]);
    }
    return target;
  }

  // quartiles, deciles, percentiles
  List<num> getQuartiles() {
    if (quartiles == null) {
      final getMedianOfList = _getMedianOfList(
          _copyListInRange(sortedList, 0, _getMedianPosition()));
      final q1 = getMedianOfList;
      final q2 = getMedian();
      final q3 = _getMedianOfList(_copyListInRange(
          sortedList, _getMedianPosition(), sortedList.length));

      quartiles = [q1, q2, q3];
    }

    return quartiles;
  }
}

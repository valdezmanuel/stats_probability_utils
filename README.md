# Stats & Probability Utils
It's a dart library focused on solving statistical problems, includes functions to get Descriptive Stats for grouped and ungrouped data such as the following:
  * Measures of Central Tendency
  -- Mode
  -- Mean (arithmetic, geometric, pondered)
  -- Median
  -- Max,Min
  * Measures of Dispersion
  -- Range
  -- Variance (sample, population)
  -- Standard Deviation (sample, population)
  * Measures of Position
  -- quartiles
  * Frecuency Table

## Install dependencies
1. Run `pub get` to install dependencies.

## Example
```dart
// Instance Object
Stats stats = Stats([1, 1, 1, 2, 3, 4, 2, 5, 3, 6, 5, 4, 6, 5, 4, 6, 7, 3, 6, 7]);

// -------------------------------
// -- UnGrouped Data
// ------------------------------
// Measures of central Tendency
print(stats.min); // 1
print(stats.max); // 7
print(stats.summation); // 81
// [arithmeticMean, geometricMean, ponderedMean]
print(stats.getMean()); // [4.05, 3.44, 4.05]
// [ [element, frecuency], ... ]
print(stats.getFrecuencies()); // [[1, 3], [2, 2], [3, 3], [4, 3], [5, 3], [6, 4], [7, 2]]
print(stats.getMode()); // [6]
print(stats.getMedian()); // 4.0

// Measures of Dispersion
// [sample, population]
print(stats.getVariance()); // [3.94, 3.74]
// [sample, population]
print(stats.getStandardDeviation()); // [1.98,1.93]
print(stats.getRange()); // 6

// -------------------------------
// -- Grouped Data
// ------------------------------
// Measures of central Tendency
print(stats.getMeanOfGroupedData()); // 4.12
print(stats.getMedianOfGroupedData()); // 4.2
print(stats.getModeOfGroupedData()); // 6.2

// Frecuency Table
print(stats.getIntervalsBySturgesRule()); // 5
print(stats.getAmplitude()); // 1.2
Map<String, dynamic> groupedClassLimit;
List<Map<String, dynamic>> groupedTable = stats.getGroupedFrecuencyMap();

for (groupedClassLimit in groupedTable) {
print('Lower class limit: ${ groupedClassLimit['lowerClassLimit'] }');
print('Upper class limit: ${ groupedClassLimit['upperClassLimit'] }');
print('Mid point (Xi): ${ groupedClassLimit['midpoint'] }');
print('Absolute frecuency (Fi): ${ groupedClassLimit['absoluteFrecuency'] }');
print('Accumulated Relative frecuency (Fr): ${ groupedClassLimit['accumulatedRelativeFrecuency'] }');
print('Accumulated frecuency (F): ${ groupedClassLimit['accumulatedFrecuency'] }');
print('XiFi: ${ groupedClassLimit['XiFi'] }');
}

// Measures of Dispersion
// [sample, population]
print(stats.getVarianceGrouped()); [3.77, 3.58]
print(stats.getStandardDeviationGrouped()); // [1.94, 1.89]

// Measures of Position
// [q1,q2,q3]
print(stats.getQuartiles()); [2.5,4.0,6.0]

```

## Run Example
* Run `dart example/example.dart`
## Authors
[Manuel Valdez](mailto:valdezzmanuel88@gmail.com)
[Yovanny Nogales](mailto:nverayovanny@gmail.com)



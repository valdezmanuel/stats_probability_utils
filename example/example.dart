import 'package:stats_probability_utils/stats_probability_utils.dart';
void main() {
  final stats = Stats(
    [2, 1, 4, 3, 2, 2, 6, 8, 10, 9]
  );

  print(stats.sortedList);
  print(stats.min);
  print(stats.max);
  print(stats.summation);
  print(stats.getMean());
  print(stats.getFrecuencies());
  print(stats.getMode());
  print(stats.getMedian());

  print('-- Disperions measure --');
  print(stats.getVariance());
  print(stats.getStandardDeviation());
  print(stats.getRange());

  print('--grouped data--');
  print(stats.getIntervalsBySturgesRule());
  print(stats.getAmplitude());
  print('-- Grouped frecuency table --\n\n');
  Map<String, dynamic> groupedClassLimit;
  final groupedTable = stats.getGroupedFrecuencyMap();
  for (groupedClassLimit in groupedTable) {
    print('------------------');
    print('  Lower class limit: ${ groupedClassLimit['lowerClassLimit'] }');
    print('  Upper class limit: ${ groupedClassLimit['upperClassLimit'] }');
    print('  Mid point (Xi): ${ groupedClassLimit['midpoint'] }');
    print('  Absolute frecuency (Fi): ${ groupedClassLimit
      ['absoluteFrecuency'] }');
    print('  Accumulated Relative frecuency (Fr): ${ groupedClassLimit
      ['accumulatedRelativeFrecuency'] }');
    print('  Accumulated frecuency (F): ${ groupedClassLimit
      ['accumulatedFrecuency'] }');
    print('  XiFi: ${ groupedClassLimit
      ['XiFi'] }');
    print('------------------\n\n');
  }
  
  print('------------------\n\n');

  print(stats.getMeanOfGroupedData());
  print(stats.getMedianOfGroupedData());
  print(stats.getModeOfGroupedData());

  print('-- measures of disp for grouped data ---');
  print(stats.getVarianceGrouped());
  print(stats.getStandardDeviationGrouped());
  print(stats.getQuartiles());
}
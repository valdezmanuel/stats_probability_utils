import '../lib/src/stats.dart';

void main() {
  Stats stats = Stats([1, 1, 1, 2, 3, 4, 2, 5, 3, 6, 5, 4, 6, 5, 4, 6, 7, 3, 6, 7]);

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

  print("--grouped data--");
  print(stats.getIntervalsBySturgesRule());
  print(stats.getAmplitude());
  print('-- Grouped frecuency table --\n\n');
  Map<String, dynamic> groupedClassLimit;
  List<Map<String, dynamic>> groupedTable = stats.getGroupedFrecuencyMap();
  for (groupedClassLimit in groupedTable) {
    print('------------------');
    print('  Lower class limit: ${ groupedClassLimit['lowerClassLimit'] }');
    print('  Upper class limit: ${ groupedClassLimit['upperClassLimit'] }');
    print('  Mid point (Xi): ${ groupedClassLimit['midpoint'] }');
    print('  Absolute frecuency (Fi): ${ groupedClassLimit['absoluteFrecuency'] }');
    print('  Accumulated Relative frecuency (Fr): ${ groupedClassLimit['accumulatedRelativeFrecuency'] }');
    print('  Accumulated frecuency (F): ${ groupedClassLimit['accumulatedFrecuency'] }');
    print('  XiFi: ${ groupedClassLimit['XiFi'] }');
    print('------------------\n\n');
  }

  print(stats.getRange());
  print(stats.getIntervalsBySturgesRule());
  print(stats.getAmplitude());
  
  print('------------------\n\n');

  print(stats.getMeanOfGroupedData());
  print(stats.getMedianOfGroupedData());
  print(stats.getModeOfGroupedData());

  print('-- measures of disp for grouped data ---');
  print(stats.getVarianceGrouped());
  print(stats.getStandardDeviationGrouped());
  print(stats.getQuartiles());
}
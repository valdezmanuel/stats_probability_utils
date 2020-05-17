import '../lib/src/stats.dart';

void main() {
  Stats stats = Stats([22, 19, 16, 13, 18, 15, 20, 14, 15, 16, 15, 16, 20, 13, 15, 18, 15, 13, 18, 16]);

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

  print('-- Grouped frecuency table --\n\n');
  Map<String, dynamic> groupedClassLimit;
  List<Map<String, dynamic>> groupedTable = stats.getGroupedFrecuencyMap();
  for (groupedClassLimit in groupedTable) {
    print('------------------');
    print('  Lower class limit: ${ groupedClassLimit['lowerClassLimit'] }');
    print('  Upper class limit: ${ groupedClassLimit['upperClassLimit'] }');
    print('  Mid point: ${ groupedClassLimit['midPoint'] }');
    print('  Absolute frecuency: ${ groupedClassLimit['absolueteFrecuency'] }');
    print('  Accumulated Relative frecuency: ${ groupedClassLimit['accumulatedRelativeFrecuency'] }');
    print('  Accumulated frecuency: ${ groupedClassLimit['accumulatedFrecuency'] }');
    print('------------------\n\n');
  }
}
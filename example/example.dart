import '../lib/src/stats.dart';

void main() {
  Stats stats = Stats([1,1,1,2,3,4,2,5,3]);

  print(stats.sortedList);
  print(stats.min);
  print(stats.max);
  print(stats.summation);
  print(stats.getMean());
  print(stats.getFrecuencies());
  print(stats.getMode());
  print(stats.getMedian());

  print("-- Disperions measure --");
  print(stats.getVariance());
  print(stats.getStandardDeviation());
  print(stats.getRange());
}
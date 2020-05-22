import 'package:stats_probability_utils/stats_probability_utils.dart';
import 'package:test/test.dart';

Stats _validateStats(List<num> values, Map<String, dynamic> expectedValues) {
  final stats = Stats(values);

  expect(expectedValues['sortedList'], stats.sortedList);
  expect(expectedValues['min'], stats.min);
  expect(expectedValues['max'], stats.max);
  expect(expectedValues['summation'], stats.summation);
  expect(expectedValues['mean'], stats.getMean());
  expect(expectedValues['frequencies'], stats.getFrecuencies());
  expect(expectedValues['mode'], stats.getMode());
  expect(expectedValues['median'], stats.getMedian());
  expect(expectedValues['variance'], stats.getVariance());
  expect(expectedValues['standardDeviation'], stats.getStandardDeviation());
  expect(expectedValues['range'], stats.getRange());
  expect(expectedValues['intervalsBySturgesRule'],
      stats.getIntervalsBySturgesRule());
  expect(expectedValues['amplitude'], stats.getAmplitude());

  int indexInGroupedTable;
  final groupedTableExpected = expectedValues['groupedFrecuencyMap'];
  final groupedTable = stats.getGroupedFrecuencyMap();

  for (indexInGroupedTable = 0;
      indexInGroupedTable < groupedTable.length;
      indexInGroupedTable++) {
    expect(groupedTableExpected[indexInGroupedTable]['lowerClassLimit'],
        groupedTable[indexInGroupedTable]['lowerClassLimit']);
    expect(groupedTableExpected[indexInGroupedTable]['upperClassLimit'],
        groupedTable[indexInGroupedTable]['upperClassLimit']);
    expect(groupedTableExpected[indexInGroupedTable]['midpoint'],
        groupedTable[indexInGroupedTable]['midpoint']);
    expect(groupedTableExpected[indexInGroupedTable]['absoluteFrecuency'],
        groupedTable[indexInGroupedTable]['absoluteFrecuency']);
    expect(
        groupedTableExpected[indexInGroupedTable]
            ['accumulatedRelativeFrecuency'],
        groupedTable[indexInGroupedTable]['accumulatedRelativeFrecuency']);
    expect(groupedTableExpected[indexInGroupedTable]['accumulatedFrecuency'],
        groupedTable[indexInGroupedTable]['accumulatedFrecuency']);
    expect(groupedTableExpected[indexInGroupedTable]['XiFi'],
        groupedTable[indexInGroupedTable]['XiFi']);
  }

  expect(expectedValues['meanOfGroupedData'], stats.getMeanOfGroupedData());
  expect(expectedValues['medianOfGroupedData'], stats.getMedianOfGroupedData());
  expect(expectedValues['modeOfGroupedData'], stats.getModeOfGroupedData());

  expect(expectedValues['varianceGrouped'], stats.getVarianceGrouped());
  expect(expectedValues['standardDeviationGrouped'],
      stats.getStandardDeviationGrouped());
  expect(expectedValues['quartiles'], stats.getQuartiles());

  return stats;
}

void main() {
  test('empty list is not allowed', () {
    final matcher = throwsA(
      isArgumentError.having((e) => e.message, 'message', 'Cannot be empty.'),
    );

    expect(() => Stats([]), matcher);
  });

  test('trivial', () {
    _validateStats([
      0
    ], {
      'sortedList': [0],
      'min': 0,
      'max': 0,
      'summation': 0.0,
      'mean': [0.0, 0.0, 0.0],
      'frequencies': [],
      'mode': [],
      'median': 0,
      'variance': [0.0, 0.0],
      'standardDeviation': [0.0, 0.0],
      'range': 0,
      'intervalsBySturgesRule': 1,
      'amplitude': 0.0,
      'groupedFrecuencyMap': [
        {
          'lowerClassLimit': 0.0,
          'upperClassLimit': 0.0,
          'midpoint': 0.0,
          'absoluteFrecuency': 1,
          'accumulatedRelativeFrecuency': 1.0,
          'accumulatedFrecuency': 1.0,
          'XiFi': 0.0
        }
      ],
      'meanOfGroupedData': 0.0,
      'medianOfGroupedData': 0.0,
      'modeOfGroupedData': [],
      'varianceGrouped': [0.0, 0.0],
      'standardDeviationGrouped': [0.0, 0.0],
      'quartiles': [0, 0, 0]
    });
  });

  test('two values', () {
    _validateStats([
      1,
      2
    ], {
      'sortedList': [1, 2],
      'min': 1,
      'max': 2,
      'summation': 3.0,
      'mean': [1.5, 1.4142135623730951, 1.5],
      'frequencies': [
        [1, 1],
        [2, 1]
      ],
      'mode': [1, 2],
      'median': 1.5,
      'variance': [0.5, 0.25],
      'standardDeviation': [0.7071067811865476, 0.5],
      'range': 1,
      'intervalsBySturgesRule': 3,
      'amplitude': 0.3333333333333333,
      'groupedFrecuencyMap': [
        {
          'lowerClassLimit': 1.0,
          'upperClassLimit': 1.3333333333333333,
          'midpoint': 1.1666666666666665,
          'absoluteFrecuency': 1,
          'accumulatedRelativeFrecuency': 0.5,
          'accumulatedFrecuency': 1,
          'XiFi': 1.1666666666666665
        },
        {
          'lowerClassLimit': 1.3333333333333333,
          'upperClassLimit': 1.6666666666666665,
          'midpoint': 1.5,
          'absoluteFrecuency': 0,
          'accumulatedRelativeFrecuency': 0.0,
          'accumulatedFrecuency': 1,
          'XiFi': 0.0
        },
        {
          'lowerClassLimit': 1.6666666666666665,
          'upperClassLimit': 2.0,
          'midpoint': 1.8333333333333333,
          'absoluteFrecuency': 1,
          'accumulatedRelativeFrecuency': 0.5,
          'accumulatedFrecuency': 2,
          'XiFi': 1.8333333333333333
        }
      ],
      'meanOfGroupedData': 1.5,
      'medianOfGroupedData': 1.3333333333333333,
      'modeOfGroupedData': [],
      'varianceGrouped': [0.22222222222222227, 0.11111111111111113],
      'standardDeviationGrouped': [0.47140452079103173, 0.33333333333333337],
      'quartiles': [1, 1.5, 2]
    });
  });

  test('10 values', () {
    _validateStats([
      2,
      1,
      4,
      3,
      2,
      2,
      6,
      8,
      10,
      9
    ], {
      'sortedList': [1, 2, 2, 2, 3, 4, 6, 8, 9, 10],
      'min': 1,
      'max': 10,
      'summation': 47.0,
      'mean': [4.7, 3.6456544157365602, 4.7],
      'frequencies': [
        [1, 1],
        [2, 3],
        [3, 1],
        [4, 1],
        [6, 1],
        [8, 1],
        [9, 1],
        [10, 1]
      ],
      'mode': [2],
      'median': 3.5,
      'variance': [10.9, 9.81],
      'standardDeviation': [3.3015148038438356, 3.132091952673165],
      'range': 9,
      'intervalsBySturgesRule': 5,
      'amplitude': 1.8,
      'groupedFrecuencyMap': [
        {
          'lowerClassLimit': 1.0,
          'upperClassLimit': 2.8,
          'midpoint': 1.9,
          'absoluteFrecuency': 4,
          'accumulatedRelativeFrecuency': 0.4,
          'accumulatedFrecuency': 4,
          'XiFi': 7.6
        },
        {
          'lowerClassLimit': 2.8,
          'upperClassLimit': 4.6,
          'midpoint': 3.6999999999999997,
          'absoluteFrecuency': 2,
          'accumulatedRelativeFrecuency': 0.2,
          'accumulatedFrecuency': 6,
          'XiFi': 7.3999999999999995
        },
        {
          'lowerClassLimit': 4.6,
          'upperClassLimit': 6.4,
          'midpoint': 5.5,
          'absoluteFrecuency': 1,
          'accumulatedRelativeFrecuency': 0.1,
          'accumulatedFrecuency': 7,
          'XiFi': 5.5
        },
        {
          'lowerClassLimit': 6.4,
          'upperClassLimit': 8.2,
          'midpoint': 7.3,
          'absoluteFrecuency': 1,
          'accumulatedRelativeFrecuency': 0.1,
          'accumulatedFrecuency': 8,
          'XiFi': 7.3
        },
        {
          'lowerClassLimit': 8.2,
          'upperClassLimit': 10.0,
          'midpoint': 9.1,
          'absoluteFrecuency': 2,
          'accumulatedRelativeFrecuency': 0.2,
          'accumulatedFrecuency': 10,
          'XiFi': 18.2
        }
      ],
      'meanOfGroupedData': 4.6,
      'medianOfGroupedData': 3.6999999999999997,
      'modeOfGroupedData': [2.2],
      'varianceGrouped': [8.82, 7.938],
      'standardDeviationGrouped': [2.9698484809834995, 2.817445651649735],
      'quartiles': [2, 3.5, 8]
    });
  });
}

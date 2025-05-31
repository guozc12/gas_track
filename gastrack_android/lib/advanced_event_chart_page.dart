import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AdvancedEventChartPage extends StatefulWidget {
  const AdvancedEventChartPage({super.key});

  @override
  State<AdvancedEventChartPage> createState() => _AdvancedEventChartPageState();
}

class _AdvancedEventChartPageState extends State<AdvancedEventChartPage> {
  String selectedPeriod = 'day';
  Set<String> selectedTypes = {'fart', 'poop', 'pee', 'meal', 'drink'};

  List<String> getDateLabels(DateTime now) {
    final alignedNow = DateTime(now.year, now.month, now.day, now.hour);
    switch (selectedPeriod) {
      case 'minute':
        return List.generate(10, (i) => DateFormat('HH:mm').format(now.subtract(Duration(minutes: 9 - i))));
      case 'hour':
        return List.generate(24, (i) => DateFormat('yyyy-MM-dd HH:00').format(alignedNow.subtract(Duration(hours: 23 - i))));
      case 'day':
        return List.generate(7, (i) => DateFormat('MM-dd').format(now.subtract(Duration(days: 6 - i))));
      case 'week':
        return List.generate(4, (i) {
          final weekStart = now.subtract(Duration(days: now.weekday - 1 + 7 * (3 - i)));
          return 'W${DateFormat('yyyy-MM-dd').format(weekStart)}';
        });
      case 'month':
        return List.generate(6, (i) => DateFormat('yyyy-MM').format(DateTime(now.year, now.month - (5 - i))));
      default:
        return [];
    }
  }

  final typeNames = {
    'fart': '放屁',
    'poop': '拉屎',
    'pee': '尿尿',
    'meal': '吃饭',
    'drink': '喝水'
  };

  final typeColors = {
    'fart': Color(0xFF1B9E77),   // colorblind-friendly
    'poop': Color(0xFFD95F02),   // colorblind-friendly
    'pee': Color(0xFF7570B3),    // colorblind-friendly
    'meal': Color(0xFFE7298A),   // colorblind-friendly
    'drink': Color(0xFF66A61E)   // colorblind-friendly
  };

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("未登录")));
    }

    final fartRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('farts');

    return Scaffold(
      appBar: AppBar(title: const Text('数据统计分析 📊')),
      body: Column(
        children: [
          const SizedBox(height: 12),

          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: typeNames.keys.map((type) {
              return FilterChip(
                label: Text('${typeNames[type]}'),
                selected: selectedTypes.contains(type),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedTypes.add(type);
                    } else {
                      selectedTypes.remove(type);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: selectedPeriod,
            onChanged: (value) => setState(() => selectedPeriod = value ?? 'day'),
            items: const [
              DropdownMenuItem(value: 'minute', child: Text('最近10分钟')),
              DropdownMenuItem(value: 'hour', child: Text('最近24小时')),
              DropdownMenuItem(value: 'day', child: Text('最近7天')),
              DropdownMenuItem(value: 'week', child: Text('最近4周')),
              DropdownMenuItem(value: 'month', child: Text('最近6个月')),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: selectedTypes.map((type) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.square, color: typeColors[type], size: 12),
                  const SizedBox(width: 4),
                  Text(typeNames[type] ?? type),
                ],
              );
            }).toList(),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: fartRef.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("没有数据"));
                }

                final docs = snapshot.data!.docs;
                final now = DateTime.now();
                final dateLabels = getDateLabels(now);

                final Map<String, Map<String, int>> dataMap = {
                  for (var label in dateLabels) label: {for (var type in selectedTypes) type: 0},
                };

                final Map<String, List<DateTime>> typeTimestamps = {
                  for (var type in selectedTypes) type: [],
                };

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
                  if (timestamp == null || !selectedTypes.contains(data['type'])) continue;

                  String label;
                  switch (selectedPeriod) {
                    case 'minute':
                      label = DateFormat('HH:mm').format(timestamp);
                      break;
                    case 'hour':
                      final aligned = DateTime(timestamp.year, timestamp.month, timestamp.day, timestamp.hour);
                      label = DateFormat('yyyy-MM-dd HH:00').format(aligned);
                      break;
                    case 'day':
                      label = DateFormat('MM-dd').format(timestamp);
                      break;
                    case 'week':
                      final weekStart = timestamp.subtract(Duration(days: timestamp.weekday - 1));
                      label = 'W${DateFormat('yyyy-MM-dd').format(weekStart)}';
                      break;
                    case 'month':
                      label = DateFormat('yyyy-MM').format(timestamp);
                      break;
                    default:
                      label = '';
                  }

                  if (!dataMap.containsKey(label)) continue;

                  dataMap[label]![data['type']] = (dataMap[label]![data['type']] ?? 0) + 1;
                  typeTimestamps[data['type']]!.add(timestamp);
                }

                final Map<String, Map<String, dynamic>> summaryStats = {};
                for (var type in selectedTypes) {
                  final times = typeTimestamps[type]!..sort();
                  final count = times.length;
                  double avgIntervalMin = 0;
                  if (count > 1) {
                    final intervals = [
                      for (int i = 1; i < times.length; i++)
                        times[i].difference(times[i - 1]).inMinutes
                    ];
                    avgIntervalMin = intervals.reduce((a, b) => a + b) / intervals.length;
                  }
                  summaryStats[type] = {
                    'count': count,
                    'avgIntervalMin': avgIntervalMin,
                  };
                }

                final barGroups = <BarChartGroupData>[];

                for (int i = 0; i < dateLabels.length; i++) {
                  final label = dateLabels[i];
                  final rods = <BarChartRodData>[];
                  int j = 0;
                  for (var type in selectedTypes) {
                    final count = (dataMap[label]?[type] ?? 0).toDouble();
                    rods.add(BarChartRodData(
                      toY: count,
                      width: 8,
                      borderRadius: BorderRadius.circular(2),
                      color: typeColors[type],
                    ));
                    j++;
                  }
                  barGroups.add(BarChartGroupData(x: i, barRods: rods, barsSpace: 4));
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarChart(
                    BarChartData(
                      barGroups: barGroups,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, _) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              final i = value.toInt();
                              if (i >= 0 && i < dateLabels.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(dateLabels[i], style: const TextStyle(fontSize: 10)),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      groupsSpace: 16,
                      alignment: BarChartAlignment.spaceAround,
                      maxY: barGroups
                              .expand((g) => g.barRods.map((r) => r.toY))
                              .fold(0.0, (a, b) => a > b ? a : b) +
                          1,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

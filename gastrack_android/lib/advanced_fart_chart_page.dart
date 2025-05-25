import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AdvancedFartChartPage extends StatefulWidget {
  const AdvancedFartChartPage({super.key});

  @override
  State<AdvancedFartChartPage> createState() => _AdvancedFartChartPageState();
}

class _AdvancedFartChartPageState extends State<AdvancedFartChartPage> {
  String selectedDimension = 'sound'; // 'sound', 'smell', or 'total'
  String selectedPeriod = 'day'; // 'minute', 'hour', 'day', 'week', 'month'

  List<String> getDateLabels(DateTime now) {
    switch (selectedPeriod) {
      case 'minute':
        return List.generate(10, (i) => DateFormat('HH:mm').format(now.subtract(Duration(minutes: 9 - i))));
      case 'hour':
        return List.generate(12, (i) => DateFormat('HH:00').format(now.subtract(Duration(hours: 11 - i))));
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("未登录")));
    }

    final fartRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('farts');

    return Scaffold(
      appBar: AppBar(title: const Text('放屁统计分析 📊')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          ToggleButtons(
            isSelected: [selectedDimension == 'sound', selectedDimension == 'smell', selectedDimension == 'total'],
            onPressed: (index) {
              setState(() {
                selectedDimension = ['sound', 'smell', 'total'][index];
              });
            },
            children: const [
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('按声音')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('按气味')),
              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('总和')),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: selectedPeriod,
            onChanged: (value) => setState(() => selectedPeriod = value ?? 'day'),
            items: const [
              DropdownMenuItem(value: 'minute', child: Text('最近10分钟')),
              DropdownMenuItem(value: 'hour', child: Text('最近12小时')),
              DropdownMenuItem(value: 'day', child: Text('最近7天')),
              DropdownMenuItem(value: 'week', child: Text('最近4周')),
              DropdownMenuItem(value: 'month', child: Text('最近6个月')),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.square, color: Colors.green, size: 12),
                const SizedBox(width: 4),
                Text(
                  selectedDimension == 'sound'
                      ? '有声'
                      : selectedDimension == 'smell'
                          ? '臭'
                          : '数量',
                ),
                const SizedBox(width: 16),
                if (selectedDimension != 'total') ...[
                  const Icon(Icons.square, color: Colors.orange, size: 12),
                  const SizedBox(width: 4),
                  Text(selectedDimension == 'sound' ? '无声' : '不臭'),
                ],
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: fartRef.get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                final now = DateTime.now();
                final dateLabels = getDateLabels(now);

                final Map<String, Map<String, int>> dataMap = {
                  for (var label in dateLabels) label: {"A": 0, "B": 0},
                };

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
                  if (timestamp == null) continue;

                  String label;
                  switch (selectedPeriod) {
                    case 'minute':
                      label = DateFormat('HH:mm').format(timestamp);
                      break;
                    case 'hour':
                      label = DateFormat('HH:00').format(timestamp);
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

                  if (selectedDimension == 'sound') {
                    final value = data['sound'] ?? '未知';
                    if (value == '有声') {
                      dataMap[label]!['A'] = (dataMap[label]!['A'] ?? 0) + 1;
                    } else {
                      dataMap[label]!['B'] = (dataMap[label]!['B'] ?? 0) + 1;
                    }
                  } else if (selectedDimension == 'smell') {
                    final value = data['smell'] ?? '未知';
                    if (value == '臭') {
                      dataMap[label]!['A'] = (dataMap[label]!['A'] ?? 0) + 1;
                    } else {
                      dataMap[label]!['B'] = (dataMap[label]!['B'] ?? 0) + 1;
                    }
                  } else if (selectedDimension == 'total') {
                    dataMap[label]!['A'] = (dataMap[label]!['A'] ?? 0) + 1;
                  }
                }

                final barGroups = <BarChartGroupData>[];
                final barAColor = Colors.green;
                final barBColor = Colors.orange;

                for (int i = 0; i < dateLabels.length; i++) {
                  final date = dateLabels[i];
                  final a = dataMap[date]!['A']!.toDouble();
                  final b = dataMap[date]!['B']!.toDouble();

                  final rods = [
                    BarChartRodData(toY: a, width: 10, borderRadius: BorderRadius.circular(4), color: barAColor),
                  ];

                  if (selectedDimension != 'total') {
                    rods.add(BarChartRodData(toY: b, width: 10, borderRadius: BorderRadius.circular(4), color: barBColor));
                  }

                  barGroups.add(BarChartGroupData(x: i, barRods: rods, barsSpace: 6));
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
                            getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
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
                      groupsSpace: 12,
                      alignment: BarChartAlignment.spaceAround,
                      maxY: barGroups
                              .map((e) => e.barRods.map((r) => r.toY).reduce((a, b) => a > b ? a : b))
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

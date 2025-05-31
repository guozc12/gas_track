import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:life_tracker/generated/app_localizations.dart';

class AdvancedEventChartPage extends StatefulWidget {
  const AdvancedEventChartPage({super.key});

  @override
  State<AdvancedEventChartPage> createState() => _AdvancedEventChartPageState();
}

class _AdvancedEventChartPageState extends State<AdvancedEventChartPage> {
  String selectedPeriod = 'hour';
  int selectedPeriodIndex = 0;
  Set<String> selectedTypes = {'fart', 'poop', 'pee', 'meal', 'drink'};
  List<String> availablePeriods = [];

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

  // Helper to get all available periods from data
  List<String> getAvailablePeriods(List<QueryDocumentSnapshot> docs) {
    switch (selectedPeriod) {
      case 'hour':
        final days = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          return timestamp != null ? DateFormat('yyyy-MM-dd').format(timestamp) : null;
        }).whereType<String>().toSet().toList();
        days.sort((a, b) => b.compareTo(a));
        return days;
      case 'week':
        final weeks = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          if (timestamp == null) return null;
          final weekStart = timestamp.subtract(Duration(days: timestamp.weekday - 1));
          return '${weekStart.year}-W${getWeekOfYear(weekStart)}';
        }).whereType<String>().toSet().toList();
        weeks.sort((a, b) => b.compareTo(a));
        return weeks;
      case 'month':
        final months = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          return timestamp != null ? DateFormat('yyyy-MM').format(timestamp) : null;
        }).whereType<String>().toSet().toList();
        months.sort((a, b) => b.compareTo(a));
        return months;
      case 'year':
        final years = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          return timestamp != null ? DateFormat('yyyy').format(timestamp) : null;
        }).whereType<String>().toSet().toList();
        years.sort((a, b) => b.compareTo(a));
        return years;
      default:
        return [];
    }
  }

  // Filter docs for the selected period
  List<QueryDocumentSnapshot> filterDocsForSelectedPeriod(List<QueryDocumentSnapshot> docs) {
    if (availablePeriods.isEmpty) return docs;
    final period = availablePeriods[selectedPeriodIndex];
    switch (selectedPeriod) {
      case 'hour':
        // 只保留选中那一天的数据
        return docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          return timestamp != null && DateFormat('yyyy-MM-dd').format(timestamp) == period;
        }).toList();
      case 'day':
        return docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          return timestamp != null && DateFormat('yyyy-MM-dd').format(timestamp) == period;
        }).toList();
      case 'week':
        return docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          if (timestamp == null) return false;
          final weekStart = timestamp.subtract(Duration(days: timestamp.weekday - 1));
          return ('${weekStart.year}-W${getWeekOfYear(weekStart)}') == period;
        }).toList();
      case 'month':
        return docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          return timestamp != null && DateFormat('yyyy-MM').format(timestamp) == period;
        }).toList();
      default:
        return docs;
    }
  }

  Map<String, String> getTypeNames(BuildContext context) => {
    'fart': AppLocalizations.of(context)!.fart,
    'poop': AppLocalizations.of(context)!.poop,
    'pee': AppLocalizations.of(context)!.pee,
    'meal': AppLocalizations.of(context)!.meal,
    'drink': AppLocalizations.of(context)!.drink,
  };

  final typeColors = {
    'fart': Color(0xFF1B9E77),   // colorblind-friendly
    'poop': Color(0xFFD95F02),   // colorblind-friendly
    'pee': Color(0xFF7570B3),    // colorblind-friendly
    'meal': Color(0xFFE7298A),   // colorblind-friendly
    'drink': Color(0xFF66A61E)   // colorblind-friendly
  };

  Future<void> pickDayAndSetIndex(BuildContext context) async {
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 300,
            height: 350,
            child: CalendarDatePicker(
              initialDate: DateTime.tryParse(availablePeriods[selectedPeriodIndex]) ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              selectableDayPredicate: (date) {
                final str = DateFormat('yyyy-MM-dd').format(date);
                return availablePeriods.contains(str);
              },
              onDateChanged: (date) {
                Navigator.of(context).pop(date);
              },
            ),
          ),
        );
      },
    );
    if (picked != null) {
      final pickedStr = DateFormat('yyyy-MM-dd').format(picked);
      final idx = availablePeriods.indexOf(pickedStr);
      if (idx != -1) {
        setState(() => selectedPeriodIndex = idx);
      } else {
        setState(() {
          availablePeriods.insert(0, pickedStr);
          selectedPeriodIndex = 0;
        });
      }
    }
  }

  Future<void> pickPeriodAndSetIndex(BuildContext context) async {
    if (selectedPeriod == 'hour') {
      await pickDayAndSetIndex(context);
      return;
    }
    final List<String> periods = availablePeriods;
    String? picked;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(selectedPeriod == 'week'
              ? AppLocalizations.of(context)!.selectWeek
              : selectedPeriod == 'month'
                  ? AppLocalizations.of(context)!.selectMonth
                  : AppLocalizations.of(context)!.selectYear),
          content: SizedBox(
            width: 300,
            height: 350,
            child: ListView.builder(
              itemCount: periods.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(periods[i]),
                  selected: selectedPeriodIndex == i,
                  onTap: () {
                    picked = periods[i];
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
    if (picked != null) {
      final idx = periods.indexOf(picked!);
      if (idx != -1) setState(() => selectedPeriodIndex = idx);
    }
  }

  int getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    final diff = date.difference(firstMonday).inDays;
    return (diff / 7).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("未登录")));
    }

    final fartRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('farts');

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.statistics)),
      body: FutureBuilder<QuerySnapshot>(
        future: fartRef.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("没有数据"));
          }

          final docs = snapshot.data!.docs;
          availablePeriods = getAvailablePeriods(docs);
          if (selectedPeriodIndex >= availablePeriods.length) selectedPeriodIndex = 0;

          final filteredDocs = filterDocsForSelectedPeriod(docs);

          return Column(
            children: [
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: getTypeNames(context).keys.map((type) {
                  return FilterChip(
                    label: Text('${getTypeNames(context)[type]}'),
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
                onChanged: (value) => setState(() {
                  final v = value as String?;
                  if (v != null && (v == 'hour' || v == 'week' || v == 'month' || v == 'year')) {
                    selectedPeriod = v;
                  } else {
                    selectedPeriod = 'hour';
                  }
                  selectedPeriodIndex = 0;
                }),
                items: [
                  DropdownMenuItem(value: 'hour', child: Text(AppLocalizations.of(context)!.byDay)),
                  DropdownMenuItem(value: 'week', child: Text(AppLocalizations.of(context)!.byWeek)),
                  DropdownMenuItem(value: 'month', child: Text(AppLocalizations.of(context)!.byMonth)),
                  DropdownMenuItem(value: 'year', child: Text(AppLocalizations.of(context)!.byYear)),
                ],
              ),
              if (availablePeriods.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => pickPeriodAndSetIndex(context),
                        child: Text(selectedPeriod == 'hour'
                            ? AppLocalizations.of(context)!.selectDate
                            : selectedPeriod == 'week'
                                ? AppLocalizations.of(context)!.selectWeek
                                : selectedPeriod == 'month'
                                    ? AppLocalizations.of(context)!.selectMonth
                                    : AppLocalizations.of(context)!.selectYear),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        availablePeriods[selectedPeriodIndex],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              Wrap(
                spacing: 8,
                children: selectedTypes.map((type) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.square, color: typeColors[type], size: 12),
                      const SizedBox(width: 4),
                      Text(getTypeNames(context)[type] ?? type),
                    ],
                  );
                }).toList(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Builder(
                    builder: (context) {
                      // 24小时模式下，x轴为0~23小时，y轴为事件数量
                      List<BarChartGroupData> barGroups;
                      if (selectedPeriod == 'hour' && availablePeriods.isNotEmpty) {
                        // 统计每小时数量
                        final hourCounts = List.generate(24, (_) => {for (var type in selectedTypes) type: 0});
                        for (var doc in filteredDocs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
                          if (timestamp == null || !selectedTypes.contains(data['type'])) continue;
                          hourCounts[timestamp.hour][data['type']] = (hourCounts[timestamp.hour][data['type']] ?? 0) + 1;
                        }
                        barGroups = List.generate(24, (i) {
                          final rods = <BarChartRodData>[];
                          for (var type in selectedTypes) {
                            rods.add(BarChartRodData(
                              toY: (hourCounts[i][type] ?? 0).toDouble(),
                              width: 8,
                              borderRadius: BorderRadius.circular(2),
                              color: typeColors[type],
                            ));
                          }
                          return BarChartGroupData(x: i, barRods: rods, barsSpace: 4);
                        });
                      } else {
                        // 其他模式，保持原有逻辑
                        final now = DateTime.now();
                        final dateLabels = getDateLabels(now);
                        final Map<String, Map<String, int>> dataMap = {
                          for (var label in dateLabels) label: {for (var type in selectedTypes) type: 0},
                        };
                        final Map<String, List<DateTime>> typeTimestamps = {
                          for (var type in selectedTypes) type: [],
                        };
                        for (var doc in filteredDocs) {
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
                        barGroups = <BarChartGroupData>[];
                        for (int i = 0; i < dateLabels.length; i++) {
                          final label = dateLabels[i];
                          final rods = <BarChartRodData>[];
                          for (var type in selectedTypes) {
                            final count = (dataMap[label]?[type] ?? 0).toDouble();
                            rods.add(BarChartRodData(
                              toY: count,
                              width: 8,
                              borderRadius: BorderRadius.circular(2),
                              color: typeColors[type],
                            ));
                          }
                          barGroups.add(BarChartGroupData(x: i, barRods: rods, barsSpace: 4));
                        }
                      }
                      // 如果 filteredDocs 为空，显示空图表
                      if (filteredDocs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppLocalizations.of(context)!.noDataForDay, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                              SizedBox(height: 16),
                              SizedBox(
                                height: 200,
                                child: BarChart(
                                  BarChartData(
                                    barGroups: List.generate(24, (i) => BarChartGroupData(x: i, barRods: [])),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, _) => Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text('${value.toInt()}h', style: const TextStyle(fontSize: 10)),
                                          ),
                                        ),
                                      ),
                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    gridData: FlGridData(show: true),
                                    borderData: FlBorderData(show: false),
                                    groupsSpace: 16,
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      // 按周模式下，x轴为1~7（周一到周日），y轴为每天事件数量
                      if (selectedPeriod == 'week' && availablePeriods.isNotEmpty) {
                        // 统计每周每天数量，确保x=0是周一，x=6是周日
                        final weekCounts = List.generate(7, (_) => {for (var type in selectedTypes) type: 0});
                        for (var doc in filteredDocs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
                          if (timestamp == null || !selectedTypes.contains(data['type'])) continue;
                          // weekday: 1=Mon, ..., 7=Sun
                          weekCounts[timestamp.weekday - 1][data['type']] = (weekCounts[timestamp.weekday - 1][data['type']] ?? 0) + 1;
                        }
                        barGroups = List.generate(7, (i) {
                          final rods = <BarChartRodData>[];
                          for (var type in selectedTypes) {
                            rods.add(BarChartRodData(
                              toY: (weekCounts[i][type] ?? 0).toDouble(),
                              width: 8,
                              borderRadius: BorderRadius.circular(2),
                              color: typeColors[type],
                            ));
                          }
                          return BarChartGroupData(x: i, barRods: rods, barsSpace: 4);
                        });
                        final weekDays = [
                          AppLocalizations.of(context)!.monday,
                          AppLocalizations.of(context)!.tuesday,
                          AppLocalizations.of(context)!.wednesday,
                          AppLocalizations.of(context)!.thursday,
                          AppLocalizations.of(context)!.friday,
                          AppLocalizations.of(context)!.saturday,
                          AppLocalizations.of(context)!.sunday,
                        ];
                        return BarChart(
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
                                    if (i >= 0 && i < 7) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(weekDays[i], style: const TextStyle(fontSize: 10)),
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
                        );
                      }
                      // 按月模式下，x轴为1~5周，y轴为每周事件数量
                      if (selectedPeriod == 'month' && availablePeriods.isNotEmpty) {
                        // 统计每月每周数量
                        final weekCounts = List.generate(5, (_) => {for (var type in selectedTypes) type: 0});
                        for (var doc in filteredDocs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
                          if (timestamp == null || !selectedTypes.contains(data['type'])) continue;
                          // 计算该日期是当月第几周
                          final firstDayOfMonth = DateTime(timestamp.year, timestamp.month, 1);
                          final weekOfMonth = ((timestamp.day + firstDayOfMonth.weekday - 2) / 7).floor();
                          if (weekOfMonth >= 0 && weekOfMonth < 5) {
                            weekCounts[weekOfMonth][data['type']] = (weekCounts[weekOfMonth][data['type']] ?? 0) + 1;
                          }
                        }
                        barGroups = List.generate(5, (i) {
                          final rods = <BarChartRodData>[];
                          for (var type in selectedTypes) {
                            rods.add(BarChartRodData(
                              toY: (weekCounts[i][type] ?? 0).toDouble(),
                              width: 8,
                              borderRadius: BorderRadius.circular(2),
                              color: typeColors[type],
                            ));
                          }
                          return BarChartGroupData(x: i, barRods: rods, barsSpace: 4);
                        });
                        return BarChart(
                          BarChartData(
                            barGroups: barGroups,
                            barTouchData: BarTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, _) {
                                    final i = value.toInt();
                                    if (i >= 0 && i < 5) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(AppLocalizations.of(context)!.weekOf(i + 1), style: const TextStyle(fontSize: 10)),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) {
                                    final i = value.toInt();
                                    if (i >= 0 && i < 5) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text('第${i + 1}周', style: const TextStyle(fontSize: 10)),
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
                        );
                      }
                      // 按年模式下，x轴为1~12月，y轴为每月事件数量
                      if (selectedPeriod == 'year' && availablePeriods.isNotEmpty) {
                        final monthCounts = List.generate(12, (_) => {for (var type in selectedTypes) type: 0});
                        for (var doc in filteredDocs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
                          if (timestamp == null || !selectedTypes.contains(data['type'])) continue;
                          monthCounts[timestamp.month - 1][data['type']] = (monthCounts[timestamp.month - 1][data['type']] ?? 0) + 1;
                        }
                        barGroups = List.generate(12, (i) {
                          final rods = <BarChartRodData>[];
                          for (var type in selectedTypes) {
                            rods.add(BarChartRodData(
                              toY: (monthCounts[i][type] ?? 0).toDouble(),
                              width: 8,
                              borderRadius: BorderRadius.circular(2),
                              color: typeColors[type],
                            ));
                          }
                          return BarChartGroupData(x: i, barRods: rods, barsSpace: 4);
                        });
                        return BarChart(
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
                                    if (i >= 0 && i < 12) {
                                      final monthLabels = [
                                        AppLocalizations.of(context)!.month1,
                                        AppLocalizations.of(context)!.month2,
                                        AppLocalizations.of(context)!.month3,
                                        AppLocalizations.of(context)!.month4,
                                        AppLocalizations.of(context)!.month5,
                                        AppLocalizations.of(context)!.month6,
                                        AppLocalizations.of(context)!.month7,
                                        AppLocalizations.of(context)!.month8,
                                        AppLocalizations.of(context)!.month9,
                                        AppLocalizations.of(context)!.month10,
                                        AppLocalizations.of(context)!.month11,
                                        AppLocalizations.of(context)!.month12,
                                      ];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(monthLabels[i], style: const TextStyle(fontSize: 10)),
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
                        );
                      }
                      return BarChart(
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
                                  if (selectedPeriod == 'hour') {
                                    // 0~23小时
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text('${value.toInt()}h', style: const TextStyle(fontSize: 10)),
                                    );
                                  } else {
                                    final i = value.toInt();
                                    final dateLabels = getDateLabels(DateTime.now());
                                    if (i >= 0 && i < dateLabels.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(dateLabels[i], style: const TextStyle(fontSize: 10)),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }
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
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:life_tracker/generated/app_localizations.dart';

class EventHistoryPage extends StatefulWidget {
  const EventHistoryPage({super.key});

  @override
  State<EventHistoryPage> createState() => _EventHistoryPageState();
}

class _EventHistoryPageState extends State<EventHistoryPage> {
  final Set<String> selectedIds = {};
  bool selectionMode = false;
  Set<String> currentFilters = {'fart', 'poop', 'pee', 'meal', 'drink'};
  List<QueryDocumentSnapshot> filteredDocsCache = [];

  void toggleSelection(String docId) {
    setState(() {
      if (selectedIds.contains(docId)) {
        selectedIds.remove(docId);
      } else {
        selectedIds.add(docId);
      }
    });
  }

  void deleteSelected() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final batch = FirebaseFirestore.instance.batch();
    for (var docId in selectedIds) {
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('farts')
          .doc(docId);
      batch.delete(ref);
    }
    await batch.commit();
    setState(() {
      selectedIds.clear();
      selectionMode = false;
    });
  }

  void selectAllFiltered(List<QueryDocumentSnapshot> filteredDocs) {
    setState(() {
      if (selectedIds.length == filteredDocs.length) {
        selectedIds.clear();
      } else {
        selectedIds.clear();
        selectedIds.addAll(filteredDocs.map((doc) => doc.id));
      }
    });
  }

  Future<void> showEventDialog({Map<String, dynamic>? initialData, String? docId}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final messenger = ScaffoldMessenger.of(context);
    final localizations = AppLocalizations.of(context)!;

    String type = initialData?['type'] ?? 'fart';
    DateTime timestamp = initialData != null && initialData['timestamp'] != null
        ? DateTime.tryParse(initialData['timestamp']) ?? DateTime.now()
        : DateTime.now();
    String sound = initialData?['sound'] ?? 'loud';
    if (sound == '有声') sound = 'loud';
    if (sound == '无声') sound = 'silent';
    String smell = initialData?['smell'] ?? 'stinky';
    if (smell == '臭') smell = 'stinky';
    if (smell == '不臭') smell = 'notStinky';
    String consistency = initialData?['consistency'] ?? 'normal';
    if (consistency == '正常') consistency = 'normal';
    if (consistency == '干') consistency = 'dry';
    if (consistency == '拉稀') consistency = 'loose';
    String color = initialData?['color'] ?? 'normal';
    if (color == '正常') color = 'normal';
    if (color == '深色') color = 'dark';
    if (color == '透明') color = 'transparent';
    String mealType = initialData?['mealType'] ?? 'earlyMeal';
    if (mealType == '早饭') mealType = 'earlyMeal';
    if (mealType == '午饭') mealType = 'lunch';
    if (mealType == '晚饭') mealType = 'dinner';
    if (mealType == '零食') mealType = 'snack';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(docId == null ? localizations.addEvent : localizations.editEvent),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: type,
                      onChanged: (v) => setState(() => type = v ?? 'fart'),
                      items: [
                        DropdownMenuItem(value: 'fart', child: Text('💨 ' + AppLocalizations.of(context)!.fart)),
                        DropdownMenuItem(value: 'poop', child: Text('💩 ' + AppLocalizations.of(context)!.poop)),
                        DropdownMenuItem(value: 'pee', child: Text('💧 ' + AppLocalizations.of(context)!.pee)),
                        DropdownMenuItem(value: 'meal', child: Text('🍽️ ' + AppLocalizations.of(context)!.meal)),
                        DropdownMenuItem(value: 'drink', child: Text('🥤 ' + AppLocalizations.of(context)!.drink)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: Text(localizations.time + ': ${timestamp.toString().substring(0, 16)}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: timestamp,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(timestamp),
                          );
                          if (time != null) {
                            setState(() {
                              timestamp = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
                            });
                          }
                        }
                      },
                    ),
                    if (type == 'fart') ...[
                      DropdownButton<String>(
                        value: sound,
                        onChanged: (v) => setState(() => sound = v ?? 'loud'),
                        items: [
                          DropdownMenuItem(value: 'loud', child: Text(AppLocalizations.of(context)!.loud)),
                          DropdownMenuItem(value: 'silent', child: Text(AppLocalizations.of(context)!.silent)),
                        ],
                      ),
                      DropdownButton<String>(
                        value: smell,
                        onChanged: (v) => setState(() => smell = v ?? 'stinky'),
                        items: [
                          DropdownMenuItem(value: 'stinky', child: Text(AppLocalizations.of(context)!.stinky)),
                          DropdownMenuItem(value: 'notStinky', child: Text(AppLocalizations.of(context)!.notStinky)),
                        ],
                      ),
                    ] else if (type == 'poop') ...[
                      DropdownButton<String>(
                        value: consistency,
                        onChanged: (v) => setState(() => consistency = v ?? 'normal'),
                        items: [
                          DropdownMenuItem(value: 'dry', child: Text(AppLocalizations.of(context)!.dry)),
                          DropdownMenuItem(value: 'normal', child: Text(AppLocalizations.of(context)!.normal)),
                          DropdownMenuItem(value: 'loose', child: Text(AppLocalizations.of(context)!.loose)),
                        ],
                      ),
                    ] else if (type == 'pee') ...[
                      DropdownButton<String>(
                        value: color,
                        onChanged: (v) => setState(() => color = v ?? 'normal'),
                        items: [
                          DropdownMenuItem(value: 'dark', child: Text(AppLocalizations.of(context)!.dark)),
                          DropdownMenuItem(value: 'normal', child: Text(AppLocalizations.of(context)!.normal)),
                          DropdownMenuItem(value: 'transparent', child: Text(AppLocalizations.of(context)!.transparent)),
                        ],
                      ),
                    ] else if (type == 'meal') ...[
                      DropdownButton<String>(
                        value: mealType,
                        onChanged: (v) => setState(() => mealType = v ?? 'earlyMeal'),
                        items: [
                          DropdownMenuItem(value: 'earlyMeal', child: Text(AppLocalizations.of(context)!.earlyMeal)),
                          DropdownMenuItem(value: 'lunch', child: Text(AppLocalizations.of(context)!.lunch)),
                          DropdownMenuItem(value: 'dinner', child: Text(AppLocalizations.of(context)!.dinner)),
                          DropdownMenuItem(value: 'snack', child: Text(AppLocalizations.of(context)!.snack)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localizations.cancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final data = <String, dynamic>{
                      'timestamp': timestamp.toIso8601String(),
                      'type': type,
                    };
                    if (type == 'fart') {
                      data['sound'] = sound;
                      data['smell'] = smell;
                    } else if (type == 'poop') {
                      data['consistency'] = consistency;
                    } else if (type == 'pee') {
                      data['color'] = color;
                    } else if (type == 'meal') {
                      data['mealType'] = mealType;
                    }
                    if (docId == null) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('farts')
                          .add(data);
                    } else {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('farts')
                          .doc(docId)
                          .update(data);
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: Text(docId == null ? localizations.add : localizations.save),
                ),
              ],
            );
          },
        );
      },
    );
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("未登录")));
    }

    final fartsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('farts')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.history),
        actions: [
          if (selectionMode)
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.select_all),
                  tooltip: selectedIds.isNotEmpty ? AppLocalizations.of(context)!.cancelSelectAll : AppLocalizations.of(context)!.selectAll,
                  onPressed: () {
                    final state = context.findAncestorStateOfType<_EventHistoryPageState>();
                    if (state != null) {
                      final filteredDocs = state.filteredDocsCache;
                      selectAllFiltered(filteredDocs);
                    }
                  },
                );
              },
            ),
          if (selectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: selectedIds.isEmpty ? null : deleteSelected,
              tooltip: AppLocalizations.of(context)!.deleteSelected,
            )
          else
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                setState(() {
                  selectionMode = true;
                });
              },
              tooltip: AppLocalizations.of(context)!.enterSelectionMode,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ToggleButtons(
                isSelected: [
                  currentFilters.contains('fart'),
                  currentFilters.contains('poop'),
                  currentFilters.contains('pee'),
                  currentFilters.contains('meal'),
                  currentFilters.contains('drink'),
                ],
                onPressed: (index) {
                  setState(() {
                    final type = ['fart', 'poop', 'pee', 'meal', 'drink'][index];
                    if (currentFilters.contains(type)) {
                      currentFilters.remove(type);
                    } else {
                      currentFilters.add(type);
                    }
                  });
                },
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("💨 " + AppLocalizations.of(context)!.fart)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("💩 " + AppLocalizations.of(context)!.poop)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("💧 " + AppLocalizations.of(context)!.pee)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("🍽️ " + AppLocalizations.of(context)!.meal)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("🥤 " + AppLocalizations.of(context)!.drink)),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fartsRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("加载失败"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredDocs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return currentFilters.contains(data['type']);
                }).toList();
                filteredDocsCache = filteredDocs;

                if (filteredDocs.isEmpty) {
                  return const Center(child: Text("暂无记录"));
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final time = data['timestamp'] ?? '';
                    final id = doc.id;
                    final isSelected = selectedIds.contains(id);

                    String subtitle = '';
                    String emoji = '📝';

                    switch (data['type']) {
                      case 'fart':
                        String soundLabel = '';
                        switch (data['sound']) {
                          case 'loud':
                          case '有声':
                            soundLabel = AppLocalizations.of(context)!.loud;
                            break;
                          case 'silent':
                          case '无声':
                            soundLabel = AppLocalizations.of(context)!.silent;
                            break;
                          default:
                            soundLabel = data['sound'] ?? AppLocalizations.of(context)!.unknownValue;
                        }
                        String smellLabel = '';
                        switch (data['smell']) {
                          case 'stinky':
                          case '臭':
                            smellLabel = AppLocalizations.of(context)!.stinky;
                            break;
                          case 'notStinky':
                          case '不臭':
                            smellLabel = AppLocalizations.of(context)!.notStinky;
                            break;
                          default:
                            smellLabel = data['smell'] ?? AppLocalizations.of(context)!.unknownValue;
                        }
                        subtitle = AppLocalizations.of(context)!.sound + ': ' + soundLabel + '，' + AppLocalizations.of(context)!.smell + ': ' + smellLabel;
                        emoji = "💨";
                        break;
                      case 'poop':
                        String consistencyLabel = '';
                        switch (data['consistency']) {
                          case 'normal':
                          case '正常':
                            consistencyLabel = AppLocalizations.of(context)!.normal;
                            break;
                          case 'dry':
                          case '干':
                            consistencyLabel = AppLocalizations.of(context)!.dry;
                            break;
                          case 'loose':
                          case '拉稀':
                            consistencyLabel = AppLocalizations.of(context)!.loose;
                            break;
                          default:
                            consistencyLabel = data['consistency'] ?? AppLocalizations.of(context)!.unknownValue;
                        }
                        subtitle = AppLocalizations.of(context)!.consistency + ': ' + consistencyLabel;
                        emoji = "💩";
                        break;
                      case 'pee':
                        String colorLabel = '';
                        switch (data['color']) {
                          case 'normal':
                          case '正常':
                            colorLabel = AppLocalizations.of(context)!.normal;
                            break;
                          case 'dark':
                          case '深色':
                            colorLabel = AppLocalizations.of(context)!.dark;
                            break;
                          case 'transparent':
                          case '透明':
                            colorLabel = AppLocalizations.of(context)!.transparent;
                            break;
                          default:
                            colorLabel = data['color'] ?? AppLocalizations.of(context)!.unknownValue;
                        }
                        subtitle = AppLocalizations.of(context)!.color + ': ' + colorLabel;
                        emoji = "💧";
                        break;
                      case 'meal':
                        String mealTypeLabel = '';
                        switch (data['mealType']) {
                          case 'earlyMeal':
                          case '早饭':
                            mealTypeLabel = AppLocalizations.of(context)!.earlyMeal;
                            break;
                          case 'lunch':
                          case '午饭':
                            mealTypeLabel = AppLocalizations.of(context)!.lunch;
                            break;
                          case 'dinner':
                          case '晚饭':
                            mealTypeLabel = AppLocalizations.of(context)!.dinner;
                            break;
                          case 'snack':
                          case '零食':
                            mealTypeLabel = AppLocalizations.of(context)!.snack;
                            break;
                          default:
                            mealTypeLabel = data['mealType'] ?? AppLocalizations.of(context)!.unknownValue;
                        }
                        subtitle = AppLocalizations.of(context)!.mealType + ': ' + mealTypeLabel;
                        emoji = "🍽️";
                        break;
                      case 'drink':
                        subtitle = AppLocalizations.of(context)!.drinkedWater;
                        emoji = "🥤";
                        break;
                    }

                    return ListTile(
                      leading: selectionMode
                          ? Checkbox(
                              value: isSelected,
                              onChanged: (_) => toggleSelection(id),
                            )
                          : Text(emoji, style: const TextStyle(fontSize: 24)),
                      title: Text(AppLocalizations.of(context)!.time + ': $time'),
                      subtitle: Text(subtitle),
                      onLongPress: () {
                        setState(() {
                          selectionMode = true;
                          toggleSelection(id);
                        });
                      },
                      onTap: () {
                        if (selectionMode) {
                          toggleSelection(id);
                        } else {
                          showEventDialog(initialData: data, docId: id);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showEventDialog(),
        child: const Icon(Icons.add),
        tooltip: AppLocalizations.of(context)!.addNewEvent,
      ),
    );
  }
}

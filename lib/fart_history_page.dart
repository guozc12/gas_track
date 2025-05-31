import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FartHistoryPage extends StatefulWidget {
  const FartHistoryPage({super.key});

  @override
  State<FartHistoryPage> createState() => _FartHistoryPageState();
}

class _FartHistoryPageState extends State<FartHistoryPage> {
  final Set<String> selectedIds = {};
  bool selectionMode = false;
  Set<String> currentFilters = {'fart'};

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

  Future<void> showEventDialog({Map<String, dynamic>? initialData, String? docId}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String type = initialData?['type'] ?? 'fart';
    DateTime timestamp = initialData != null && initialData['timestamp'] != null
        ? DateTime.tryParse(initialData['timestamp']) ?? DateTime.now()
        : DateTime.now();
    String sound = initialData?['sound'] ?? '有声';
    String smell = initialData?['smell'] ?? '臭';
    String consistency = initialData?['consistency'] ?? '正常';
    String color = initialData?['color'] ?? '正常';
    String mealType = initialData?['mealType'] ?? '早饭';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(docId == null ? '添加事件' : '编辑事件'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: type,
                      onChanged: (v) => setState(() => type = v ?? 'fart'),
                      items: const [
                        DropdownMenuItem(value: 'fart', child: Text('💨 放屁')),
                        DropdownMenuItem(value: 'poop', child: Text('💩 拉屎')),
                        DropdownMenuItem(value: 'pee', child: Text('💧 尿尿')),
                        DropdownMenuItem(value: 'meal', child: Text('🍽️ 吃饭')),
                        DropdownMenuItem(value: 'drink', child: Text('🥤 喝水')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: Text('时间: ${timestamp.toString().substring(0, 16)}'),
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
                        onChanged: (v) => setState(() => sound = v ?? '有声'),
                        items: const [
                          DropdownMenuItem(value: '有声', child: Text('有声')),
                          DropdownMenuItem(value: '无声', child: Text('无声')),
                        ],
                      ),
                      DropdownButton<String>(
                        value: smell,
                        onChanged: (v) => setState(() => smell = v ?? '臭'),
                        items: const [
                          DropdownMenuItem(value: '臭', child: Text('臭')),
                          DropdownMenuItem(value: '不臭', child: Text('不臭')),
                        ],
                      ),
                    ] else if (type == 'poop') ...[
                      DropdownButton<String>(
                        value: consistency,
                        onChanged: (v) => setState(() => consistency = v ?? '正常'),
                        items: const [
                          DropdownMenuItem(value: '干', child: Text('干')),
                          DropdownMenuItem(value: '正常', child: Text('正常')),
                          DropdownMenuItem(value: '拉稀', child: Text('拉稀')),
                        ],
                      ),
                    ] else if (type == 'pee') ...[
                      DropdownButton<String>(
                        value: color,
                        onChanged: (v) => setState(() => color = v ?? '正常'),
                        items: const [
                          DropdownMenuItem(value: '深色', child: Text('深色')),
                          DropdownMenuItem(value: '正常', child: Text('正常')),
                          DropdownMenuItem(value: '透明', child: Text('透明')),
                        ],
                      ),
                    ] else if (type == 'meal') ...[
                      DropdownButton<String>(
                        value: mealType,
                        onChanged: (v) => setState(() => mealType = v ?? '早饭'),
                        items: const [
                          DropdownMenuItem(value: '早饭', child: Text('早饭')),
                          DropdownMenuItem(value: '午饭', child: Text('午饭')),
                          DropdownMenuItem(value: '晚饭', child: Text('晚饭')),
                          DropdownMenuItem(value: '零食', child: Text('零食')),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
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
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(docId == null ? '添加' : '保存'),
                ),
              ],
            );
          },
        );
      },
    );
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
        title: const Text("历史记录"),
        actions: [
          if (selectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: selectedIds.isEmpty ? null : deleteSelected,
              tooltip: '删除选中记录',
            )
          else
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {
                setState(() {
                  selectionMode = true;
                });
              },
              tooltip: '进入选择模式',
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
                children: const [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("💨 放屁")),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("💩 拉屎")),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("💧 尿尿")),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("🍽️ 吃饭")),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("🥤 喝水")),
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
                        subtitle = "声音: ${data['sound'] ?? '未知'}，气味: ${data['smell'] ?? '未知'}";
                        emoji = "💨";
                        break;
                      case 'poop':
                        subtitle = "类型: ${data['consistency'] ?? '未知'}";
                        emoji = "💩";
                        break;
                      case 'pee':
                        subtitle = "颜色: ${data['color'] ?? '未知'}";
                        emoji = "💧";
                        break;
                      case 'meal':
                        subtitle = "餐别: ${data['mealType'] ?? '未知'}";
                        emoji = "🍽️";
                        break;
                      case 'drink':
                        subtitle = "喝了一杯水";
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
                      title: Text("时间: $time"),
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
        tooltip: '添加新事件',
      ),
    );
  }
}

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
                        if (selectionMode) toggleSelection(id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
        title: const Text("放屁历史记录"),
        actions: [
          if (selectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: selectedIds.isEmpty
                  ? null
                  : () {
                      deleteSelected();
                    },
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
      body: StreamBuilder<QuerySnapshot>(
        stream: fartsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("加载失败"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final fartDocs = snapshot.data!.docs;
          if (fartDocs.isEmpty) {
            return const Center(child: Text("暂无记录"));
          }

          return ListView.builder(
            itemCount: fartDocs.length,
            itemBuilder: (context, index) {
              final doc = fartDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              final time = data['timestamp'] ?? '';
              final sound = data['sound'] ?? '未知';
              final smell = data['smell'] ?? '未知';
              final id = doc.id;
              final isSelected = selectedIds.contains(id);

              return ListTile(
                leading: selectionMode
                    ? Checkbox(
                        value: isSelected,
                        onChanged: (_) => toggleSelection(id),
                      )
                    : const Text("💨", style: TextStyle(fontSize: 24)),
                title: Text("时间: $time"),
                subtitle: Text("声音: $sound，气味: $smell"),
                onLongPress: () {
                  setState(() {
                    selectionMode = true;
                    toggleSelection(id);
                  });
                },
                onTap: () {
                  if (selectionMode) {
                    toggleSelection(id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
} 

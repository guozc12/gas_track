import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EventInsightPage extends StatefulWidget {
  const EventInsightPage({super.key});

  @override
  State<EventInsightPage> createState() => _EventInsightPageState();
}

class _EventInsightPageState extends State<EventInsightPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> conversation = [];
  bool _loading = true;
  bool _showFullConversation = false;

  final typeNames = {
    'fart': '放屁',
    'poop': '拉屎',
    'pee': '尿尿',
    'meal': '吃饭',
    'drink': '喝水'
  };

  Future<void> getAiAdvice(List<Map<String, String>> messages) async {
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final apiKey = dotenv.env['OPENAI_API_KEY'];

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-4o",
        "messages": [
          {"role": "system", "content": "你是一个健康生活方式专家，专门根据生理数据提出建议。"},
          ...messages
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'].toString();
      setState(() {
        conversation.add({"role": "assistant", "content": reply});
        _loading = false;
      });
    } else {
      setState(() {
        conversation.add({"role": "assistant", "content": '无法获取 AI 建议（${response.statusCode}）'});
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('farts');
      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));

      ref.where('timestamp', isGreaterThanOrEqualTo: oneWeekAgo.toIso8601String()).get().then((snapshot) {
        final docs = snapshot.docs;
        final Map<String, List<DateTime>> timestampsPerType = {};
        final List<String> fullLogs = [];
        final Set<String> coveredDays = {};

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          if (timestamp == null || !data.containsKey('type')) continue;
          final type = data['type'];
          timestampsPerType.putIfAbsent(type, () => []).add(timestamp);
          coveredDays.add(DateFormat('yyyy-MM-dd').format(timestamp));
          final fieldDetails = data.entries
              .where((e) => e.key != 'timestamp' && e.key != 'type')
              .map((e) => '${e.key}: ${e.value}')
              .join(', ');
          fullLogs.add('${DateFormat('yyyy-MM-dd HH:mm').format(timestamp)} - 类型: ${typeNames[type] ?? type}${fieldDetails.isNotEmpty ? '，' + fieldDetails : ''}');
        }

        final List<String> summaryLines = [];
        summaryLines.add('📊 过去一周的记录摘要如下：');

        timestampsPerType.forEach((type, times) {
          times.sort();
          final count = times.length;
          double avgIntervalMin = 0;
          if (count > 1) {
            final intervals = [
              for (int i = 1; i < times.length; i++)
                times[i].difference(times[i - 1]).inMinutes
            ];
            avgIntervalMin = intervals.reduce((a, b) => a + b) / intervals.length;
          }
          final name = typeNames[type] ?? type;
          summaryLines.add('▶️ $name 共计 $count 次，平均间隔 ${avgIntervalMin.toStringAsFixed(1)} 分钟');
        });

        summaryLines.add('\n📅 每日记录覆盖情况：');
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final label = DateFormat('MM/dd').format(date);
          final key = DateFormat('yyyy-MM-dd').format(date);
          final covered = coveredDays.contains(key);
          summaryLines.add(' - $label: ${covered ? "✅" : "❌"}');
        }

        summaryLines.add('\n⚠️ 注意：以上统计可能因用户遗漏记录而不完全，GPT 请结合这一点审慎分析。');

        summaryLines.add('\n详细记录如下：');
        summaryLines.addAll(fullLogs);
        summaryLines.add('\n请基于上述不同类型的记录频率与间隔，为用户提供健康与生活方式建议。');

        final summary = summaryLines.join('\n');
        conversation.add({"role": "user", "content": summary});
        getAiAdvice(conversation);
        _controller.clear();
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("未登录")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('数据统计与 AI 分析 🤖')),
      body: _loading && conversation.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => setState(() => _showFullConversation = !_showFullConversation),
                    child: Text(_showFullConversation ? '隐藏完整对话' : '查看 GPT 完整对话'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _showFullConversation ? conversation.length : (conversation.isNotEmpty ? 2 : 0),
                    itemBuilder: (context, index) {
                      final msg = _showFullConversation ? conversation[index] : conversation[conversation.length - 2 + index];
                      final prefix = msg['role'] == 'user' ? '🧑 用户:' : '🤖 GPT:';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('$prefix\n${msg['content']}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '继续与 GPT 对话...'
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        setState(() {
                          _loading = true;
                          conversation.add({"role": "user", "content": text.trim()});
                          _controller.clear();
                        });
                        getAiAdvice(conversation);
                      }
                    },
                  ),
                )
              ],
            ),
    );
  }
} 

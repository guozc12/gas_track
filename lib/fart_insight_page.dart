import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FartInsightPage extends StatefulWidget {
  const FartInsightPage({super.key});

  @override
  State<FartInsightPage> createState() => _FartInsightPageState();
}

class _FartInsightPageState extends State<FartInsightPage> {
  String _summary = '';
  String _aiResponse = '';
  bool _loading = true;
  bool _showFullConversation = false;

  Future<void> getAiAdvice(String summary) async {
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final apiKey = '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';

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
          {"role": "user", "content": summary}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _aiResponse = data['choices'][0]['message']['content'].toString();
        _loading = false;
      });
    } else {
      setState(() {
        _aiResponse = '无法获取 AI 建议（${response.statusCode}）';
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final fartRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('farts');
      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));

      fartRef.where('timestamp', isGreaterThanOrEqualTo: oneWeekAgo.toIso8601String()).get().then((snapshot) {
        final docs = snapshot.docs;
        int total = docs.length;
        int voiced = 0;
        int smelly = 0;
        Map<String, int> countPerDay = {};
        Map<int, int> countPerHour = {}; // hour of day

        List<String> detailedLog = [];

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = DateTime.tryParse(data['timestamp'] ?? '');
          if (timestamp == null) continue;

          if (data['sound'] == '有声') voiced++;
          if (data['smell'] == '臭') smelly++;

          final dateKey = DateFormat('yyyy-MM-dd').format(timestamp);
          countPerDay[dateKey] = (countPerDay[dateKey] ?? 0) + 1;
          countPerHour[timestamp.hour] = (countPerHour[timestamp.hour] ?? 0) + 1;

          detailedLog.add('${DateFormat('yyyy-MM-dd HH:mm').format(timestamp)} - 声音: ${data['sound']}，气味: ${data['smell']}');
        }

        final sortedDays = countPerDay.keys.toList()..sort();
        String trend = '总体趋于稳定';
        if (sortedDays.length >= 2) {
          final recent = countPerDay[sortedDays.last]!;
          final previous = countPerDay[sortedDays[sortedDays.length - 2]]!;
          if (recent > previous) {
            trend = '放屁频率有上升趋势 📈';
          } else if (recent < previous) {
            trend = '放屁频率有下降趋势 📉';
          }
        }

        final mostActiveHour = countPerHour.entries.fold(0, (a, b) => b.value > (countPerHour[a] ?? 0) ? b.key : a);

        final avgPerDay = total / countPerDay.length;
        final maxPerDay = countPerDay.values.isNotEmpty ? countPerDay.values.reduce(max) : 0;
        String anomaly = '无明显异常';
        if (maxPerDay > avgPerDay * 2) {
          anomaly = '⚠️ 某日频率异常升高，建议回顾饮食或健康状况';
        }

        _summary = '''
过去一周共记录了 $total 次放屁事件。
有声比例为 ${(voiced / total * 100).toStringAsFixed(1)}%，臭味比例为 ${(smelly / total * 100).toStringAsFixed(1)}%。
趋势分析：$trend。
最活跃时段为 ${mostActiveHour.toString().padLeft(2, '0')}:00。
异常情况：$anomaly。

以下是详细记录：
${detailedLog.join('\n')}

请基于上述记录，为用户提供健康或饮食建议。
''';

        getAiAdvice(_summary);
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('🤖 AI 建议:'),
                Text(_aiResponse),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() => _showFullConversation = !_showFullConversation),
                  child: Text(_showFullConversation ? '隐藏详细对话' : '查看 GPT 完整对话'),
                ),
                if (_showFullConversation) ...[
                  const SizedBox(height: 8),
                  const Text('📝 用户输入：'),
                  Text(_summary),
                ]
              ],
            ),
    );
  }
}

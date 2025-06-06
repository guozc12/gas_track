import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:life_tracker/generated/app_localizations.dart';

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

  Map<String, String> getTypeNames(BuildContext context) => {
    'fart': AppLocalizations.of(context)!.fart,
    'poop': AppLocalizations.of(context)!.poop,
    'pee': AppLocalizations.of(context)!.pee,
    'meal': AppLocalizations.of(context)!.meal,
    'drink': AppLocalizations.of(context)!.drink,
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
          fullLogs.add('${DateFormat('yyyy-MM-dd HH:mm').format(timestamp)} - 类型: ${getTypeNames(context)[type] ?? type}${fieldDetails.isNotEmpty ? '，' + fieldDetails : ''}');
        }

        final List<String> summaryLines = [];
        summaryLines.add(AppLocalizations.of(context)!.dataSummary);

        final typeNames = getTypeNames(context);
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
          summaryLines.add(AppLocalizations.of(context)!.typeSummary(count, avgIntervalMin.toStringAsFixed(1), name));
        });

        summaryLines.add('\n' + AppLocalizations.of(context)!.dailyCoverage);
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final label = DateFormat('MM/dd').format(date);
          final key = DateFormat('yyyy-MM-dd').format(date);
          final covered = coveredDays.contains(key);
          summaryLines.add(' - $label: ${covered ? AppLocalizations.of(context)!.covered : AppLocalizations.of(context)!.notCovered}');
        }

        summaryLines.add('\n' + AppLocalizations.of(context)!.aiNotice);
        summaryLines.add('\n' + AppLocalizations.of(context)!.detailRecords);
        summaryLines.addAll(fullLogs);
        summaryLines.add('\n' + AppLocalizations.of(context)!.aiRequest);

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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.statistics)),
      body: _loading && conversation.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => setState(() => _showFullConversation = !_showFullConversation),
                    child: Text(_showFullConversation ? AppLocalizations.of(context)!.hideFullConversation : AppLocalizations.of(context)!.viewGPTFullConversation),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _showFullConversation ? conversation.length : (conversation.isNotEmpty ? 2 : 0),
                    itemBuilder: (context, index) {
                      final msg = _showFullConversation ? conversation[index] : conversation[conversation.length - 2 + index];
                      final prefix = msg['role'] == 'user' ? '🧑 ' + AppLocalizations.of(context)!.user + ':' : '🤖 ' + AppLocalizations.of(context)!.assistant + ':';
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.continueGPTConversation
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

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'advanced_event_chart_page.dart';
import 'event_history_page.dart';
import 'event_insight_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

void main() async {
  print('Current directory: [32m[1m[4m[7m${Directory.current.path}[0m');
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
    options: firebaseWebOptions,
  );
  runApp(const LifeTrackerApp());
}

class LifeTrackerApp extends StatelessWidget {
  const LifeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeTracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;

  void submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("用户取消了 Google 登录");
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, stack) {
      print("Google 登录失败: $e");
      print("详细信息: $stack");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: submit, child: Text(isLogin ? 'Login' : 'Register')),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? 'Need an account? Register' : 'Already have an account? Login'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text("使用 Google 登录"),
              onPressed: signInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> recordMeal(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("选择餐食类型"),
        children: ['早饭', '午饭', '晚饭', '零食']
            .map((s) => SimpleDialogOption(child: Text(s), onPressed: () => Navigator.pop(context, s)))
            .toList(),
      ),
    );

    if (result != null) {
      final now = DateTime.now();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('farts')
          .add({
        'timestamp': now.toIso8601String(),
        'type': 'meal',
        'mealType': result,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🍽️ 吃饭已记录！')),
      );
    }
  }

  Future<void> recordDrink(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('farts')
        .add({
      'timestamp': now.toIso8601String(),
      'type': 'drink',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🥤 喝水已记录！')),
    );
  }
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> recordFart(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final sound = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("选择声音类型"),
        children: ['有声', '无声']
            .map((s) => SimpleDialogOption(child: Text(s), onPressed: () => Navigator.pop(context, s)))
            .toList(),
      ),
    );
    if (sound == null) return;

    final smell = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("选择气味类型"),
        children: ['臭', '不臭']
            .map((s) => SimpleDialogOption(child: Text(s), onPressed: () => Navigator.pop(context, s)))
            .toList(),
      ),
    );
    if (smell == null) return;

    final now = DateTime.now();
    final fart = {
      'timestamp': now.toIso8601String(),
      'type': 'fart',
      'sound': sound,
      'smell': smell,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('farts')
          .add(fart);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('💾 放屁已记录！')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('记录失败: $e')),
      );
    }
  }

  Future<void> recordPoop(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("选择大便类型"),
        children: ['干', '正常', '拉稀']
            .map((s) => SimpleDialogOption(child: Text(s), onPressed: () => Navigator.pop(context, s)))
            .toList(),
      ),
    );

    if (result != null) {
      final now = DateTime.now();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('farts')
          .add({
        'timestamp': now.toIso8601String(),
        'type': 'poop',
        'consistency': result,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('💩 拉屎已记录！')),
      );
    }
  }

  Future<void> recordPee(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("选择尿液颜色"),
        children: ['深色', '正常', '透明']
            .map((s) => SimpleDialogOption(child: Text(s), onPressed: () => Navigator.pop(context, s)))
            .toList(),
      ),
    );

    if (result != null) {
      final now = DateTime.now();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('farts')
          .add({
        'timestamp': now.toIso8601String(),
        'type': 'pee',
        'color': result,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('💧 尿尿已记录！')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeTracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'AI分析',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EventInsightPage()),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdvancedEventChartPage()),
              );
            },
            icon: const Icon(Icons.stacked_bar_chart),
            tooltip: '双柱图分析',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventHistoryPage()),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: '查看历史记录',
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: '登出',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('👋 Hello $email'),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => recordFart(context),
                  child: const Text('我刚放了一个屁 💨'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recordPoop(context),
                  child: const Text('我刚拉了一坨屎 💩'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recordMeal(context),
                  child: const Text('我刚吃了一顿饭 🍽️'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recordDrink(context),
                  child: const Text('我刚喝了一杯水 🥤'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recordPee(context),
                  child: const Text('我刚尿了一泡尿 💧'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

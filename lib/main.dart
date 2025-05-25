import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'advanced_fart_chart_page.dart';
import 'fart_history_page.dart';
import 'fart_insight_page.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseWebOptions,
  );
  runApp(const GasTrackApp());
}

class GasTrackApp extends StatelessWidget {
  const GasTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GasTrack',
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
  String soundType = '有声';
  String smellType = '臭';

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> recordFart(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final fart = {
      'timestamp': now.toIso8601String(),
      'sound': soundType,
      'smell': smellType,
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

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('GasTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'AI分析',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FartInsightPage()),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdvancedFartChartPage()),
              );
            },
            icon: const Icon(Icons.stacked_bar_chart),
            tooltip: '双柱图分析',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FartHistoryPage()),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('👋 Hello $email'),
            const SizedBox(height: 24),

            // 声音选择
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('声音: '),
                ToggleButtons(
                  isSelected: [soundType == '有声', soundType == '无声'],
                  onPressed: (index) {
                    setState(() {
                      soundType = (index == 0) ? '有声' : '无声';
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('有声'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('无声'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 气味选择
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('气味: '),
                ToggleButtons(
                  isSelected: [smellType == '臭', smellType == '不臭'],
                  onPressed: (index) {
                    setState(() {
                      smellType = (index == 0) ? '臭' : '不臭';
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('臭'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('不臭'),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => recordFart(context),
              child: const Text('我刚放了一个屁 💨'),
            ),
          ],
        ),
      ),
    );
  }
}
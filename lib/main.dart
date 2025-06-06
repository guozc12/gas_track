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
import 'generated/app_localizations.dart';
import 'generated/app_localizations_zh.dart';
import 'generated/app_localizations_en.dart';
import 'generated/app_localizations_ja.dart';
import 'generated/app_localizations_es.dart';
import 'generated/app_localizations_de.dart';
import 'generated/app_localizations_fr.dart';
import 'generated/app_localizations_nl.dart';
import 'generated/app_localizations_ko.dart';
// 仅在web端有效
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: firebaseWebOptions,
  );
  runApp(const LifeTrackerApp());
}

class LifeTrackerApp extends StatefulWidget {
  const LifeTrackerApp({super.key});
  @override
  State<LifeTrackerApp> createState() => _LifeTrackerAppState();
}

class _LifeTrackerAppState extends State<LifeTrackerApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    // 读取本地存储的语言
    final savedLocale = html.window.localStorage['app_locale'];
    if (savedLocale != null && savedLocale.isNotEmpty) {
      _locale = Locale(savedLocale);
    }
  }

  void setLocale(Locale locale) {
    final supported = AppLocalizations.supportedLocales.map((l) => l.languageCode).toList();
    final code = locale.languageCode;
    if (supported.contains(code)) {
      setState(() {
        _locale = Locale(code);
      });
    } else {
      setState(() {
        _locale = const Locale('en');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeTracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      home: AuthGate(onLocaleChange: setLocale),
    );
  }
}

class AuthGate extends StatelessWidget {
  final void Function(Locale)? onLocaleChange;
  const AuthGate({super.key, this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return HomePage(onLocaleChange: onLocaleChange);
        }
        return LoginPage(onLocaleChange: onLocaleChange);
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  final void Function(Locale)? onLocaleChange;
  const LoginPage({super.key, this.onLocaleChange});

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
  final void Function(Locale)? onLocaleChange;
  const HomePage({super.key, this.onLocaleChange});

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
            tooltip: AppLocalizations.of(context)!.aiAnalysis,
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
            tooltip: AppLocalizations.of(context)!.statistics,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventHistoryPage()),
              );
            },
            icon: const Icon(Icons.history),
            tooltip: AppLocalizations.of(context)!.history,
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: AppLocalizations.of(context)!.logout,
          ),
          PopupMenuButton<Locale>(
            icon: Icon(Icons.language),
            onSelected: (locale) {
              // 根据用户选择的语言，创建对应的本地化对象
              AppLocalizations localizations;
              switch (locale.languageCode) {
                case 'zh':
                  localizations = AppLocalizationsZh();
                  break;
                case 'en':
                  localizations = AppLocalizationsEn();
                  break;
                case 'ja':
                  localizations = AppLocalizationsJa();
                  break;
                case 'es':
                  localizations = AppLocalizationsEs();
                  break;
                case 'de':
                  localizations = AppLocalizationsDe();
                  break;
                case 'fr':
                  localizations = AppLocalizationsFr();
                  break;
                case 'nl':
                  localizations = AppLocalizationsNl();
                  break;
                case 'ko':
                  localizations = AppLocalizationsKo();
                  break;
                default:
                  localizations = AppLocalizationsEn();
              }
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localizations.appTitle),
                  content: Text(localizations.languageRestartNotice),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(localizations.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        html.window.localStorage['app_locale'] = locale.languageCode;
                        html.window.location.reload();
                      },
                      child: Text(localizations.restart),
                    ),
                  ],
                ),
              );
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: Locale('zh'),
                child: Text('中文'),
              ),
              PopupMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              PopupMenuItem(
                value: Locale('ja'),
                child: Text('日本語'),
              ),
              PopupMenuItem(
                value: Locale('es'),
                child: Text('Español'),
              ),
              PopupMenuItem(
                value: Locale('de'),
                child: Text('Deutsch'),
              ),
              PopupMenuItem(
                value: Locale('fr'),
                child: Text('Français'),
              ),
              PopupMenuItem(
                value: Locale('nl'),
                child: Text('Nederlands'),
              ),
              PopupMenuItem(
                value: Locale('ko'),
                child: Text('한국어'),
              ),
            ],
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
                  child: Text(AppLocalizations.of(context)!.iJustHadAFart),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recordPoop(context),
                  child: Text(AppLocalizations.of(context)!.iJustHadAPoop),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recordMeal(context),
                  child: Text(AppLocalizations.of(context)!.iJustHadAMeal),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recordDrink(context),
                  child: Text(AppLocalizations.of(context)!.iJustHadADrink),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recordPee(context),
                  child: Text(AppLocalizations.of(context)!.iJustHadAPee),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

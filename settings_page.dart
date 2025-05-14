import 'package:flutter/material.dart';
import '../main.dart';
import 'notifications_page.dart';
import '../l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  bool notificationsEnabled = true;

  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimations = List.generate(5, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.1 * index, 0.1 * index + 0.4, curve: Curves.easeOut),
      ));
    });

    _fadeAnimations = List.generate(5, (index) {
      return Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.1 * index, 0.1 * index + 0.4, curve: Curves.easeIn),
      ));
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget animatedItem({required int index, required Widget child}) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: child,
      ),
    );
  }

  Route _createSlideRouteToNotifications() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const NotificationsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppTheme currentTheme = themeNotifier.value;
    var loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          animatedItem(
            index: 0,
            child: Text(
              loc.preferences,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          animatedItem(
            index: 1,
            child: ListTile(
              title: Text(loc.language),
              trailing: DropdownButton<String>(
                value: localeNotifier.value.languageCode,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ru', child: Text('Русский')),
                  DropdownMenuItem(value: 'kk', child: Text('Қазақша')),
                ],
                onChanged: (langCode) {
                  setState(() {
                    localeNotifier.value = Locale(langCode!);
                  });
                },
              ),
            ),
          ),
          animatedItem(
            index: 2,
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(loc.notifications),
              onTap: () {
                Navigator.of(context).push(_createSlideRouteToNotifications());
              },
            ),
          ),
          animatedItem(
            index: 3,
            child: ListTile(
              title: Text(loc.theme),
              trailing: DropdownButton<AppTheme>(
                value: currentTheme,
                items: const [
                  DropdownMenuItem(value: AppTheme.light, child: Text('Light')),
                  DropdownMenuItem(value: AppTheme.dark, child: Text('Dark')),
                  DropdownMenuItem(value: AppTheme.blue, child: Text('Blue')),
                  DropdownMenuItem(value: AppTheme.green, child: Text('Green')),
                ],
                onChanged: (value) {
                  setState(() {
                    themeNotifier.value = value!;
                  });
                },
              ),
            ),
          ),
          const Divider(height: 32),
          animatedItem(
            index: 4,
            child: ListTile(
              title: Text(loc.aboutApp),
              subtitle: const Text("Hotel Booking v1.0\n created by AITU ❤️"),
            ),
          ),
        ],
      ),
    );
  }
}

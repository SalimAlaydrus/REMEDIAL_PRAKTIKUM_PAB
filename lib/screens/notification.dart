import 'package:flutter/material.dart';

class _NotificationItem {
  final String title;
  final String subtitle;
  final DateTime time;
  final IconData icon;

  _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Dummy data notifikasi, diurutkan dari yang terbaru
    final notifications = <_NotificationItem>[
      _NotificationItem(
        title: 'Berita baru tersedia',
        subtitle: 'Cek headline terbaru di halaman Home',
        time: now.subtract(const Duration(minutes: 10)),
        icon: Icons.newspaper,
      ),
      _NotificationItem(
        title: 'Artikel favorit diperbarui',
        subtitle: 'Salah satu artikel favoritmu mendapat update',
        time: now.subtract(const Duration(hours: 2)),
        icon: Icons.favorite,
      ),
      _NotificationItem(
        title: 'Selamat datang!',
        subtitle: 'Terima kasih telah bergabung di SpaceNews Core',
        time: now.subtract(const Duration(days: 1)),
        icon: Icons.celebration,
      ),
    ]..sort((a, b) => b.time.compareTo(a.time));

    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: notifications.isEmpty
          ? const Center(child: Text('Belum ada notifikasi'))
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListTile(
                  leading: CircleAvatar(child: Icon(item.icon)),
                  title: Text(item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(item.subtitle),
                  trailing: Text(
                    _formatTimeAgo(item.time),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
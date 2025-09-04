import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../constants/app_constants.dart';
import '../authentication/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final userProfile = ref.watch(userProfileProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      _getInitials(user?.userMetadata?['full_name'] ?? 'User'),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.userMetadata?['full_name'] ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // User Profile Info
            userProfile.when(
              data: (profile) => _buildProfileInfo(context, profile),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error loading profile: $error'),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Menu Items
            _buildMenuSection(context, ref),
            
            const SizedBox(height: 24),
            
            // Sign Out Button
            Center(
              child: ElevatedButton(
                onPressed: () => _signOut(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 48),
                ),
                child: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, Map<String, dynamic>? profile) {
    if (profile == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Setup',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Complete your profile to get personalized meal recommendations.',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to profile setup
                },
                child: const Text('Complete Profile'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Profile Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to edit profile
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (profile['age'] != null)
              _ProfileInfoRow(
                icon: Icons.cake,
                label: 'Age',
                value: '${profile['age']} years old',
              ),
            
            _ProfileInfoRow(
              icon: Icons.restaurant_menu,
              label: 'Diet Type',
              value: _formatDietType(profile['diet_type']),
            ),
            
            if (profile['allergies'] != null && (profile['allergies'] as List).isNotEmpty)
              _ProfileInfoRow(
                icon: Icons.warning_amber,
                label: 'Allergies',
                value: (profile['allergies'] as List).join(', '),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        
        Card(
          child: Column(
            children: [
              _MenuTile(
                icon: Icons.favorite,
                title: 'Favorite Recipes',
                subtitle: 'View your saved recipes',
                onTap: () {
                  // TODO: Navigate to favorites
                },
              ),
              const Divider(height: 1),
              _MenuTile(
                icon: Icons.history,
                title: 'Meal History',
                subtitle: 'See your past meal plans',
                onTap: () {
                  // TODO: Navigate to history
                },
              ),
              const Divider(height: 1),
              _MenuTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Manage your alerts',
                onTap: () {
                  // TODO: Navigate to notifications
                },
              ),
              const Divider(height: 1),
              _MenuTile(
                icon: Icons.help,
                title: 'Help & Support',
                subtitle: 'Get help and contact us',
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
              const Divider(height: 1),
              _MenuTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  // TODO: Navigate to privacy policy
                },
              ),
              const Divider(height: 1),
              _MenuTile(
                icon: Icons.info,
                title: 'About',
                subtitle: 'App version ${AppConstants.appVersion}',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true && context.mounted) {
      try {
        final authService = ref.read(authServiceProvider);
        await authService.signOut();
        
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sign out failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationLegalese: '© 2024 NutriPlan. All rights reserved.',
      children: [
        const SizedBox(height: 16),
        const Text(
          'NutriPlan helps you manage therapeutic diets and plan healthy meals. '
          'Our mission is to make healthy eating accessible and enjoyable for everyone.',
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return 'U';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  String _formatDietType(String? dietType) {
    if (dietType == null) return 'Not specified';
    
    switch (dietType) {
      case 'diabetic':
        return 'Diabetic';
      case 'renal':
        return 'Renal';
      case 'heart_healthy':
        return 'Heart Healthy';
      case 'low_fodmap':
        return 'Low FODMAP';
      case 'none':
        return 'No restrictions';
      default:
        return dietType;
    }
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
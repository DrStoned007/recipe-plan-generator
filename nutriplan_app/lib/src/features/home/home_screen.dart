import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../constants/app_constants.dart';
import '../../models/models.dart';
import '../recipes/recipes_screen.dart';
import '../meal_planning/meal_plans_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  
  static const List<Widget> _screens = [
    HomeTab(),
    RecipesScreen(),
    MealPlansScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Meal Plans',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final today = DateTime.now();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to ${AppConstants.appName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${user?.userMetadata?['full_name'] ?? 'User'}!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ready to plan your healthy meals?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Today's Meal Plan
            Text(
              "Today's Meals",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            
            Consumer(
              builder: (context, ref, child) {
                final dailyMealPlan = ref.watch(dailyMealPlanProvider(today));
                
                return dailyMealPlan.when(
                  data: (mealPlan) => _buildTodaysMeals(context, mealPlan),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stackTrace) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Error loading today's meals: $error"),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.add,
                    title: 'Plan Meal',
                    subtitle: 'Add to today',
                    onTap: () {
                      // TODO: Navigate to meal planning
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.search,
                    title: 'Find Recipe',
                    subtitle: 'Browse recipes',
                    onTap: () {
                      // TODO: Navigate to recipe search
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTodaysMeals(BuildContext context, DailyMealPlan mealPlan) {
    if (mealPlan.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.restaurant_menu_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'No meals planned for today',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to meal planning
                },
                child: const Text('Plan your meals'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: [
        _MealCard(
          mealType: 'Breakfast',
          mealPlan: mealPlan.breakfast,
        ),
        const SizedBox(height: 8),
        _MealCard(
          mealType: 'Lunch',
          mealPlan: mealPlan.lunch,
        ),
        const SizedBox(height: 8),
        _MealCard(
          mealType: 'Dinner',
          mealPlan: mealPlan.dinner,
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final String mealType;
  final MealPlan? mealPlan;

  const _MealCard({
    required this.mealType,
    this.mealPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            _getMealIcon(),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(mealType),
        subtitle: Text(
          mealPlan?.recipe?.title ?? 'No meal planned',
          style: TextStyle(
            color: mealPlan != null ? null : Colors.grey[600],
          ),
        ),
        trailing: mealPlan != null
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.add_circle_outline),
        onTap: () {
          // TODO: Navigate to meal details or planning
        },
      ),
    );
  }
  
  IconData _getMealIcon() {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }
}
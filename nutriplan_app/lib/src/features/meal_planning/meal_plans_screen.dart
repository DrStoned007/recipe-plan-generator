import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../models/models.dart';
import '../../constants/app_constants.dart';

class MealPlansScreen extends ConsumerStatefulWidget {
  const MealPlansScreen({super.key});

  @override
  ConsumerState<MealPlansScreen> createState() => _MealPlansScreenState();
}

class _MealPlansScreenState extends ConsumerState<MealPlansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plans'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Daily'),
            Tab(text: 'Weekly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyView(),
          _buildWeeklyView(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMealDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDailyView() {
    return Column(
      children: [
        // Date Selector
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                  });
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _formatDate(_selectedDate),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.add(const Duration(days: 1));
                  });
                },
              ),
            ],
          ),
        ),
        
        // Daily Meal Plan
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final dailyMealPlan = ref.watch(dailyMealPlanProvider(_selectedDate));
              
              return dailyMealPlan.when(
                data: (mealPlan) => _buildDailyMealPlan(mealPlan),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load meal plan',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.invalidate(dailyMealPlanProvider(_selectedDate));
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyView() {
    final weekStart = ref.watch(currentWeekStartProvider);
    final weeklyMealPlan = ref.watch(weeklyMealPlanProvider(weekStart));
    
    return weeklyMealPlan.when(
      data: (weeklyPlans) {
        if (weeklyPlans.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No meal plans for this week',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: weeklyPlans.length,
          itemBuilder: (context, index) {
            final dailyPlan = weeklyPlans[index];
            return _WeeklyDayCard(dailyPlan: dailyPlan);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load weekly plan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(weeklyMealPlanProvider(weekStart));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyMealPlan(DailyMealPlan mealPlan) {
    if (mealPlan.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No meals planned for this day',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add a meal',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _MealTypeCard(
          mealType: MealType.breakfast,
          mealPlan: mealPlan.breakfast,
          date: mealPlan.date,
        ),
        const SizedBox(height: 16),
        _MealTypeCard(
          mealType: MealType.lunch,
          mealPlan: mealPlan.lunch,
          date: mealPlan.date,
        ),
        const SizedBox(height: 16),
        _MealTypeCard(
          mealType: MealType.dinner,
          mealPlan: mealPlan.dinner,
          date: mealPlan.date,
        ),
      ],
    );
  }

  void _showAddMealDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Meal'),
        content: const Text(
          'This feature will allow you to add meals to your plan. '
          'Implementation coming soon!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _MealTypeCard extends ConsumerWidget {
  final MealType mealType;
  final MealPlan? mealPlan;
  final DateTime date;

  const _MealTypeCard({
    required this.mealType,
    required this.mealPlan,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getMealIcon(),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  mealType.displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (mealPlan != null)
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showMealOptions(context, ref);
                    },
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            if (mealPlan != null && mealPlan!.recipe != null) ...[
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: mealPlan!.recipe!.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              mealPlan!.recipe!.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.restaurant);
                              },
                            ),
                          )
                        : const Icon(Icons.restaurant),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealPlan!.recipe!.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (mealPlan!.recipe!.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            mealPlan!.recipe!.description!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${mealPlan!.recipe!.totalTime} min',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.people,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${mealPlan!.recipe!.servings}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to recipe selection
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add ${mealType.displayName.toLowerCase()}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            
            if (mealPlan?.notes != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.note,
                      size: 16,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        mealPlan!.notes!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.blue[600],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getMealIcon() {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
    }
  }

  void _showMealOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Meal'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Edit meal
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Meal'),
              onTap: () {
                Navigator.pop(context);
                if (mealPlan != null) {
                  ref.read(mealPlanManagerProvider.notifier)
                      .removeMealFromPlan(mealPlan!.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyDayCard extends StatelessWidget {
  final DailyMealPlan dailyPlan;

  const _WeeklyDayCard({required this.dailyPlan});

  @override
  Widget build(BuildContext context) {
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final dayName = weekdays[dailyPlan.date.weekday - 1];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  dayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${dailyPlan.date.month}/${dailyPlan.date.day}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const Spacer(),
                if (dailyPlan.isComplete)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            if (dailyPlan.isEmpty) ...[
              Text(
                'No meals planned',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ] else ...[
              ...dailyPlan.meals.map((meal) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          _getMealIcon(meal.mealType),
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          meal.mealType.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            meal.recipe?.title ?? 'Unknown recipe',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getMealIcon(MealType mealType) {
    switch (mealType) {
      case MealType.breakfast:
        return Icons.free_breakfast;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
    }
  }
}
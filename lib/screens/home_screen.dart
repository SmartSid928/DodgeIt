import 'package:material_ui/material_ui.dart';

import '../core/theme/app_theme.dart';
import '../widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.route, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DodgeIt',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.dark,
                      ),
                    ),
                    Text(
                      'Smarter roads. Safer journeys.',
                      style: TextStyle(color: AppTheme.secondary, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                const CircleAvatar(
                  backgroundColor: Color(0xFFE5F4EC),
                  child: Icon(Icons.person, color: AppTheme.primary),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Hello there! 👋',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppTheme.dark,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Make every journey a smarter one.',
              style: TextStyle(color: AppTheme.secondary),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.navigation, color: Colors.white, size: 32),
                  const SizedBox(height: 15),
                  const Text(
                    'Plan your journey',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Explore road conditions and identify reported road issues.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: () {
                      // Map navigation will be connected next.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Open the Map tab to explore roads.'),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primary,
                    ),
                    child: const Text('Explore Map'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Explore Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.dark,
              ),
            ),

            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: const [
                FeatureCard(
                  icon: Icons.map,
                  title: 'Road Map',
                  subtitle: 'Explore road conditions',
                ),
                FeatureCard(
                  icon: Icons.report_problem,
                  title: 'Report Issue',
                  subtitle: 'Report potholes and damage',
                ),
                FeatureCard(
                  icon: Icons.traffic,
                  title: 'Traffic Updates',
                  subtitle: 'View road disruptions',
                ),
                FeatureCard(
                  icon: Icons.camera_alt,
                  title: 'AI Detection',
                  subtitle: 'Detect road damage',
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Help improve road awareness by reporting road conditions.',
                      style: TextStyle(color: AppTheme.secondary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

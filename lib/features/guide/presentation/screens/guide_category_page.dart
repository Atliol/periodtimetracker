import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class GuideCategoryPage extends StatelessWidget {
  final String categoryKey;
  final String categoryTitle;
  final Color headerColor;

  const GuideCategoryPage({
    super.key,
    required this.categoryKey,
    required this.categoryTitle,
    required this.headerColor,
  });

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case 'hot_tub':
        return Icons.hot_tub_rounded;
      case 'local_cafe':
        return Icons.local_cafe_rounded;
      case 'ac_unit':
        return Icons.ac_unit_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Box guideBox = Hive.box('guideBox');

    return Container(
      color: const Color(0xFFD47A83),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFD47A83),
          // 🌟 ဤနေရာတွင် showBackButton: true ကို ထည့်သွင်းပေးပါ
          appBar: CustomAppBar(
            title: categoryTitle,
            showBackButton: true,
          ),
          body: ValueListenableBuilder(
            valueListenable: guideBox.listenable(),
            builder: (context, Box box, _) {
              final filteredGuides = box.values.where((item) => item['category'] == categoryKey).toList();

              if (filteredGuides.isEmpty) {
                return const Center(
                  child: Text(
                    'အချက်အလက်များ မရှိသေးပါ',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredGuides.length,
                itemBuilder: (context, index) {
                  final guide = filteredGuides[index];
                  final IconData itemIcon = _getIconData(guide['icon']);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: headerColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(itemIcon, color: headerColor, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                guide['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                guide['content'] ?? '',
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
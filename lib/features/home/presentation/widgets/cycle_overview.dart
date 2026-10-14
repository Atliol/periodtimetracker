import 'package:flutter/material.dart';

class CycleOverview extends StatelessWidget {
  const CycleOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Cycle Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text('Show all', style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Ongoing Cycle', style: TextStyle(color: Colors.black54, fontSize: 13)),
              Text('25 March - 26 March', style: TextStyle(color: Colors.black54, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.4,
            backgroundColor: Colors.grey.shade200,
            color: const Color(0xFFFF416C),
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.water_drop, color: Colors.pink, size: 18),
              Icon(Icons.water_drop, color: Colors.blue, size: 18),
              Icon(Icons.water_drop, color: Colors.green, size: 18),
              Icon(Icons.water_drop, color: Colors.amber, size: 18),
              Icon(Icons.water_drop, color: Colors.blue, size: 18),
              Icon(Icons.water_drop, color: Colors.grey, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
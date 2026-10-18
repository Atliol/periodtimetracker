import 'package:flutter/material.dart';
import 'dart:ui';

class CycleOverview extends StatelessWidget {
  const CycleOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3), // 🌟 ဖောက်ထွင်းမြင်ရသော အဖြူရောင် Glass Card
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Cycle Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Show all', style: TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Ongoing Cycle', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text('25 March - 26 March', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: 0.4,
                backgroundColor: Colors.white.withOpacity(0.3),
                color: const Color(0xFFFF416C),
                minHeight: 6,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Icon(Icons.water_drop, color: Colors.pinkAccent, size: 18),
                  Icon(Icons.water_drop, color: Colors.blueAccent, size: 18),
                  Icon(Icons.water_drop, color: Colors.greenAccent, size: 18),
                  Icon(Icons.water_drop, color: Colors.amberAccent, size: 18),
                  Icon(Icons.water_drop, color: Colors.blueAccent, size: 18),
                  Icon(Icons.water_drop, color: Colors.white54, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
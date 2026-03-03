import 'package:flutter/material.dart';

class ScheduleResultCard extends StatelessWidget {
  final String schedule;

  const ScheduleResultCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    if (schedule.isEmpty) return SizedBox.shrink();
    final lines = schedule // ini adalah wadah untuk menyimpan schedule
        .split('\n') // inni biar rapi enternya
        .map((line) => line.trim()) // .trim() akan memootong konten yang diberikan oleh AI, dan membuatnya jadi ga terlalu banyak
        .where((line) => line.isNotEmpty) //menyeleksi data apakah kosong atau tidak, nanti ambil yang kosong. line ini adalahvariable/wadah untuk menampung schedule 
        .toList(); // biar ga berpotensi menghasilkan mismatch
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8),
                Text(
                  'Generated Schedule',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lines.map((line) {
                  final isHeading = line.endsWith(':');
                  final isBullet = line.startsWith('- ');

                  if (isBullet) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.circle, size: 6),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: SelectableText(
                              line.substring(2),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  
                  return Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: SelectableText(
                      line,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isHeading ? FontWeight.w700 : FontWeight.w400,
                        height: 1.4 //biar ga dempet 1 sama lain
                      ),
                    ),
                  );
                }).toList()
              ),
            )
          ],
        ),
      ),
    );
  }
}
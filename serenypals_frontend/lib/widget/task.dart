import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serenypals_frontend/utils/color.dart';

class Task {
  final String title;
  final int xp;
  bool isDone;
  bool isClaimed;

  Task({
    required this.title,
    required this.xp,
    this.isDone = false,
    this.isClaimed = false,
  });
}

class TaskSection extends StatefulWidget {
  const TaskSection({super.key});

  @override
  State<TaskSection> createState() => _TaskSectionState();
}

class _TaskSectionState extends State<TaskSection> {
  final List<Task> _tasks = [
    Task(title: 'Beri Makan Pet', xp: 10, isDone: true),
    Task(title: 'Curhat di Diary', xp: 20, isDone: false),
    Task(title: 'Terhubung dengan AI', xp: 30, isDone: false),
  ];

  void _claimReward(int index) {
    setState(() {
      _tasks[index].isClaimed = true;
    });

    // Tampilkan dialog atau animasi koin
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('🎉 Koin Diterima!'),
            content: Text('Kamu mendapatkan +${_tasks[index].xp} XP!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );

    // Delay sebelum menghapus tugas
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _tasks.removeAt(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.yellow[100]?.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 Tugas Harian',
              style: GoogleFonts.overlock(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: List.generate(_tasks.length, (index) {
                final task = _tasks[index];
                return AnimatedOpacity(
                  key: ValueKey(task.title),
                  opacity: task.isClaimed ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${task.title} +${task.xp}',
                            style: GoogleFonts.overlock(fontSize: 14),
                          ),
                          task.isDone && !task.isClaimed
                              ? ElevatedButton(
                                onPressed: () => _claimReward(index),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Klaim',
                                  style: GoogleFonts.overlock(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      task.isDone
                                          ? Colors.lightBlue[100]
                                          : Colors.orange[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  task.isDone ? 'Selesai' : 'Belum',
                                  style: GoogleFonts.overlock(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

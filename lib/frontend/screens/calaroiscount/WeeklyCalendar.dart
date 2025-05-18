import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:flutter/material.dart';

class WeeklyCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected; // Callback for date selection
  final DateTime selectedDay; // اليوم المحدد يتم تمريره من الويدجت الأب

  const WeeklyCalendar({
    Key? key,
    required this.onDateSelected,
    required this.selectedDay, // إضافة selectedDay كمعامل
  }) : super(key: key);

  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  late DateTime startOfWeek;

  @override
  void initState() {
    super.initState();
    startOfWeek =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final DateTime today = DateTime.now();

    final List<String> daysOfWeek = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
    ];

    // التنقل بين الأسابيع مع تأثير حركة
    void changeWeek(bool isNext) {
      setState(() {
        startOfWeek = isNext
            ? startOfWeek.add(Duration(days: 7))
            : startOfWeek.subtract(Duration(days: 7));
      });
    }

    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر الأسبوع السابق
              IconButton(
                icon: Icon(Icons.arrow_back, size: 28),
                onPressed: () => changeWeek(false),
              ),

              // عرض الأسبوع الحالي
              Text(
                "${startOfWeek.day} - ${startOfWeek.add(Duration(days: 6)).day} ${_getMonthName(startOfWeek)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // زر الأسبوع التالي
              IconButton(
                icon: Icon(Icons.arrow_forward, size: 28),
                onPressed: () => changeWeek(true),
              ),
            ],
          ),
          SizedBox(height: 10),

          // قائمة الأيام
          SizedBox(
            height: screenHeight * 0.12,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: daysOfWeek.length,
              itemBuilder: (context, index) {
                final DateTime dayOfWeek =
                    startOfWeek.add(Duration(days: index));
                final bool isSelected =
                    _isSameDay(widget.selectedDay, dayOfWeek);

                return GestureDetector(
                  onTap: () {
                    widget.onDateSelected(dayOfWeek); // Call the callback
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: screenWidth * 0.12,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: Colors.orange.shade300, blurRadius: 8)
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          daysOfWeek[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${dayOfWeek.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // دالة للحصول على اسم الشهر الحالي
  String _getMonthName(DateTime date) {
    List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[date.month - 1];
  }

  // دالة لفحص إذا كان يومين متطابقين
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

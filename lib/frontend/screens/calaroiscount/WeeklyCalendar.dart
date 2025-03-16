import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:flutter/material.dart';

class WeeklyCalendar extends StatefulWidget {
  const WeeklyCalendar({super.key});

  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  // لتحديد بداية الأسبوع الحالي (يبدأ من يوم الاثنين)
  DateTime startOfWeek =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

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
                final bool isToday = _isSameDay(today, dayOfWeek);

                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: screenWidth * 0.12,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: isToday ? kapp : Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isToday
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
                          color: isToday ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${dayOfWeek.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isToday ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
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

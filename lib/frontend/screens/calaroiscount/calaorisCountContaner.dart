import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories Chart'),
      ),
      body: Center(
        child: CaloriesChart(
          protein: 100, // القيمة الكلية للبروتين
          fats: 50, // القيمة الكلية للدهون
          carbs: 200, // القيمة الكلية للكربوهيدرات
          use_protein: 70, // النسبة المستخدمة من البروتين
          use_fats: 30, // النسبة المستخدمة من الدهون
          use_carbs: 150, // النسبة المستخدمة من الكربوهيدرات
        ),
      ),
    );
  }
}

class CaloriesChart extends StatefulWidget {
  final double protein;
  final double fats;
  final double carbs;
  final double use_protein;
  final double use_fats;
  final double use_carbs;

  const CaloriesChart({
    Key? key,
    required this.protein,
    required this.fats,
    required this.carbs,
    required this.use_protein,
    required this.use_fats,
    required this.use_carbs,
  }) : super(key: key);

  @override
  _CaloriesChartState createState() => _CaloriesChartState();
}

class _CaloriesChartState extends State<CaloriesChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _proteinAnimation;
  late Animation<double> _fatsAnimation;
  late Animation<double> _carbsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // الرسوم المتحركة تعتمد على النسب المستخدمة
    _proteinAnimation =
        Tween<double>(begin: 0, end: widget.use_protein).animate(_controller);
    _fatsAnimation =
        Tween<double>(begin: 0, end: widget.use_fats).animate(_controller);
    _carbsAnimation =
        Tween<double>(begin: 0, end: widget.use_carbs).animate(_controller);

    _controller.forward(); // تشغيل الرسوم المتحركة
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(200, 200),
              painter: RingPainter(
                widget.protein, // القيمة الكلية للبروتين
                widget.fats, // القيمة الكلية للدهون
                widget.carbs, // القيمة الكلية للكربوهيدرات
                _proteinAnimation.value, // النسبة المستخدمة من البروتين
                _fatsAnimation.value, // النسبة المستخدمة من الدهون
                _carbsAnimation.value, // النسبة المستخدمة من الكربوهيدرات
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildIndicator(Colors.pink, "Protein", widget.use_protein),
            const SizedBox(width: 10),
            _buildIndicator(Colors.blue, "Fats", widget.use_fats),
            const SizedBox(width: 10),
            _buildIndicator(Colors.green, "Carbs", widget.use_carbs),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicator(Color color, String label, double value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: color,
          ),
          const SizedBox(width: 5),
          Text(
            "$label ${value.toInt()}g",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class RingPainter extends CustomPainter {
  final double protein;
  final double fats;
  final double carbs;
  final double use_protein; // النسبة المستخدمة من البروتين
  final double use_fats; // النسبة المستخدمة من الدهون
  final double use_carbs; // النسبة المستخدمة من الكربوهيدرات

  RingPainter(
    this.protein,
    this.fats,
    this.carbs,
    this.use_protein,
    this.use_fats,
    this.use_carbs,
  );

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 16;
    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    // ألوان الخلفية (القيم الكلية)
    Paint proteinBackgroundPaint = Paint()
      ..color = Colors.pink.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint fatsBackgroundPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint carbsBackgroundPaint = Paint()
      ..color = Colors.green.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // ألوان الأقواس (النسب المستخدمة)
    Paint proteinPaint = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 4);

    Paint fatsPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 4);

    Paint carbsPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 4);

    double startAngle = -90; // البدء من أعلى الدائرة

    // حساب الزوايا للنسب المستخدمة
    double proteinSweep =
        360 * (use_protein / protein); // نسبة البروتين المستخدم
    double fatsSweep = 360 * (use_fats / fats); // نسبة الدهون المستخدمة
    double carbsSweep =
        360 * (use_carbs / carbs); // نسبة الكربوهيدرات المستخدمة

    // رسم الخلفية (القيم الكلية)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      degToRad(startAngle),
      degToRad(360),
      false,
      proteinBackgroundPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth * 2.3),
      degToRad(startAngle),
      degToRad(360),
      false,
      fatsBackgroundPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth * 3.7),
      degToRad(startAngle),
      degToRad(360),
      false,
      carbsBackgroundPaint,
    );

    // رسم الأجزاء (النسب المستخدمة)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      degToRad(startAngle),
      degToRad(proteinSweep),
      false,
      proteinPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth * 2.3),
      degToRad(startAngle),
      degToRad(fatsSweep),
      false,
      fatsPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth * 3.7),
      degToRad(startAngle),
      degToRad(carbsSweep),
      false,
      carbsPaint,
    );
  }

  double degToRad(double deg) {
    return deg * (3.14159265359 / 180);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(TooltipOverlayApp());
}

class TooltipOverlayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tooltip Overlay Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TooltipOverlayPage(),
    );
  }
}

class TooltipOverlayPage extends StatefulWidget {
  @override
  _TooltipOverlayPageState createState() => _TooltipOverlayPageState();
}

class _TooltipOverlayPageState extends State<TooltipOverlayPage> {
  List<String> _logMessages = [];
  late TooltipBehavior _tooltipBehavior;

  final List<ChartData> _chartData = [
    ChartData('Q1 2023', 35, 25),
    ChartData('Q2 2023', 42, 30),
    ChartData('Q3 2023', 38, 28),
    ChartData('Q4 2023', 45, 35),
    ChartData('Q1 2024', 52, 40),
    ChartData('Q2 2024', 48, 38),
    ChartData('Q3 2024', 55, 42),
    ChartData('Q4 2024', 60, 45),
    ChartData('Q1 2025', 58, 44),
    ChartData('Q2 2025', 65, 50),
  ];

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      // Custom builder for fixed height tooltip
      builder: (
        dynamic data,
        dynamic point,
        dynamic series,
        int pointIndex,
        int seriesIndex,
      ) {
        final chartData = _chartData[pointIndex];
        final growth =
            ((chartData.sales - chartData.profit) / chartData.profit * 100);
        final margin = (chartData.profit / chartData.sales * 100);

        return Container(
          height: 500,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade700, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.analytics, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '📊 Analytics Dashboard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12),

              // Main data
              Text(
                '${chartData.quarter} Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 10),

              // Key metrics
              _buildTooltipRow('Sales:', '\$${chartData.sales}M', Colors.blue),
              _buildTooltipRow(
                'Profit:',
                '\$${chartData.profit}M',
                Colors.orange,
              ),
              _buildTooltipRow(
                'Growth:',
                '${growth.toStringAsFixed(1)}%',
                Colors.green,
              ),
              _buildTooltipRow(
                'Margin:',
                '${margin.toStringAsFixed(1)}%',
                Colors.purple,
              ),

              SizedBox(height: 10),
              Divider(color: Colors.grey.shade300, height: 12),
              SizedBox(height: 8),

              // Extended analytics
              Text(
                'Extended Analytics:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 8),

              Container(
                height: 120, // Fixed height for scrollable content
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTooltipDetailRow('📈 Revenue Trend:', 'Up 12.5%'),
                      _buildTooltipDetailRow(
                        '🎯 Market Share:',
                        '15.2% (+2.1% YoY)',
                      ),
                      _buildTooltipDetailRow(
                        '🔮 Forecast:',
                        'Optimistic outlook',
                      ),
                      _buildTooltipDetailRow(
                        '⚔️ Competition:',
                        'Strong position',
                      ),
                      _buildTooltipDetailRow(
                        '💰 ROI:',
                        '${(chartData.profit * 2.5).toStringAsFixed(1)}% annual',
                      ),
                      _buildTooltipDetailRow(
                        '📊 EBITDA:',
                        '\$${(chartData.profit * 1.3).toStringAsFixed(1)}M',
                      ),
                      _buildTooltipDetailRow(
                        '💸 Cash Flow:',
                        '\$${(chartData.profit * 0.8).toStringAsFixed(1)}M',
                      ),
                      _buildTooltipDetailRow(
                        '👥 Employees:',
                        '${(chartData.sales * 10).toInt()} headcount',
                      ),
                      _buildTooltipDetailRow(
                        '🤝 Customers:',
                        '${(chartData.sales * 150).toInt()} active',
                      ),
                      _buildTooltipDetailRow(
                        '🌍 Regions:',
                        '${(chartData.sales / 10).toInt()} markets',
                      ),
                      _buildTooltipDetailRow(
                        '📱 Digital:',
                        '${(chartData.sales * 0.65).toStringAsFixed(1)}% online',
                      ),
                      _buildTooltipDetailRow(
                        '🏪 Retail:',
                        '${(chartData.sales * 0.35).toStringAsFixed(1)}% stores',
                      ),
                      _buildTooltipDetailRow(
                        '📈 Growth Rate:',
                        '${(growth / 4).toStringAsFixed(1)}% quarterly',
                      ),
                      _buildTooltipDetailRow(
                        '💼 Enterprise:',
                        '${(chartData.sales * 0.4).toStringAsFixed(1)}M B2B',
                      ),
                      _buildTooltipDetailRow(
                        '👤 Consumer:',
                        '${(chartData.sales * 0.6).toStringAsFixed(1)}M B2C',
                      ),
                      _buildTooltipDetailRow(
                        '🔄 Recurring:',
                        '${(chartData.profit * 0.7).toStringAsFixed(1)}M ARR',
                      ),
                      _buildTooltipDetailRow(
                        '📊 Analytics:',
                        'AI-powered insights enabled',
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Footer
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    'Tooltip in enlarged container (750px height) - more space for display!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      canShowMarker: true,
      duration: 4000,
      animationDuration: 250,
    );
    super.initState();
  }

  Widget _buildTooltipRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTooltipDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateLog(String message) {
    setState(() {
      _logMessages.insert(
        0,
        '${DateTime.now().toLocal().toString().split(' ')[1].split('.')[0]}: $message',
      );
      if (_logMessages.length > 10) {
        _logMessages.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tooltip Overlay Test'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Chart with increased size for tooltip space
          Container(
            height: 750, // Increased height to accommodate large tooltip
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SfCartesianChart(
              title: ChartTitle(
                text: 'Sales Performance',
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              primaryXAxis: CategoryAxis(
                title: AxisTitle(text: 'Quarter'),
                majorGridLines: MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Values (M)'),
                majorGridLines: MajorGridLines(
                  width: 0.5,
                  color: Colors.grey.shade300,
                ),
              ),
              tooltipBehavior: _tooltipBehavior,
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              series: <CartesianSeries>[
                // Line series with markers
                LineSeries<ChartData, String>(
                  dataSource: _chartData,
                  xValueMapper: (ChartData data, _) => data.quarter,
                  yValueMapper: (ChartData data, _) => data.sales,
                  name: 'Sales',
                  color: Colors.blue,
                  width: 3,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    height: 10,
                    width: 10,
                    shape: DataMarkerType.circle,
                    borderWidth: 2,
                    borderColor: Colors.white,
                  ),
                  onPointTap: (ChartPointDetails details) {
                    _updateLog(
                      'Tap on point: ${_chartData[details.pointIndex!.toInt()].quarter}',
                    );
                    _updateLog(
                      'Tooltip shown in enlarged container (750px) - more space!',
                    );
                  },
                ),
                // Column series
                ColumnSeries<ChartData, String>(
                  dataSource: _chartData,
                  xValueMapper: (ChartData data, _) => data.quarter,
                  yValueMapper: (ChartData data, _) => data.profit,
                  name: 'Profit',
                  color: Colors.orange.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(4),
                  onPointTap: (ChartPointDetails details) {
                    _updateLog(
                      'Tap on column: ${_chartData[details.pointIndex!.toInt()].quarter}',
                    );
                    _updateLog(
                      'Tooltip shown in enlarged container (750px) - more space!',
                    );
                  },
                ),
              ],
            ),
          ),

          // Large colored container below chart
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(148, 0, 48, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.purple.shade400,
                    Colors.blue.shade600,
                    Colors.teal.shade500,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: CustomPaint(painter: PatternPainter()),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Large container below chart',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'This container takes up a lot of space below the chart.\n'
                          'When the tooltip appears, it should be displayed on top of this container.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 24),

                        // Some interactive elements
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildInfoCard(
                              'Data',
                              '${_chartData.length} points',
                              Icons.data_usage,
                            ),
                            _buildInfoCard(
                              'Status',
                              'Active',
                              Icons.check_circle,
                            ),
                            _buildInfoCard('Update', 'Live', Icons.refresh),
                          ],
                        ),

                        Spacer(),

                        // Log section at bottom
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Event Log',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed:
                                          () => setState(
                                            () => _logMessages.clear(),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  itemCount: _logMessages.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      child: Text(
                                        _logMessages[index],
                                        style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 12,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.quarter, this.sales, this.profit);
  final String quarter;
  final double sales;
  final double profit;
}

// Custom painter for background pattern
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.1)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    // Draw diagonal lines pattern
    for (double i = -size.height; i < size.width + size.height; i += 30) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Draw dots pattern
    final dotPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.05)
          ..style = PaintingStyle.fill;

    for (double x = 20; x < size.width; x += 40) {
      for (double y = 20; y < size.height; y += 40) {
        canvas.drawCircle(Offset(x, y), 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

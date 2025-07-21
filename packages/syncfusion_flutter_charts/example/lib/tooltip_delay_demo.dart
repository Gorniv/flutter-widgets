import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/src/charts/common/core_tooltip.dart';

void main() {
  runApp(TooltipDelayDemo());
}

class TooltipDelayDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tooltip Delay & Animation Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TooltipDelayPage(),
    );
  }
}

class TooltipDelayPage extends StatefulWidget {
  @override
  _TooltipDelayPageState createState() => _TooltipDelayPageState();
}

class _TooltipDelayPageState extends State<TooltipDelayPage> {
  late TooltipBehavior _tooltipBehavior;
  int _delayValue = 500;
  int _animationDuration = 500;
  Curve _animationCurve = Curves.easeOutBack;
  TooltipAnimationFunction _animationFunction = TooltipAnimations.scale;

  final List<int> _delayOptions = [0, 300, 500, 1000];
  final List<int> _durationOptions = [200, 350, 500, 800, 1200];

  final List<Curve> _availableCurves = [
    Curves.easeOutBack,
    Curves.bounceOut,
    Curves.elasticOut,
    Curves.easeIn,
    Curves.easeOut,
    Curves.easeInOut,
    Curves.linear,
    Curves.fastOutSlowIn,
  ];

  final Map<Curve, String> _curveNames = {
    Curves.easeOutBack: 'EaseOutBack',
    Curves.bounceOut: 'BounceOut',
    Curves.elasticOut: 'ElasticOut',
    Curves.easeIn: 'EaseIn',
    Curves.easeOut: 'EaseOut',
    Curves.easeInOut: 'EaseInOut',
    Curves.linear: 'Linear',
    Curves.fastOutSlowIn: 'FastOutSlowIn',
  };

  final List<TooltipAnimationFunction> _availableAnimations = [
    TooltipAnimations.scale,
    TooltipAnimations.slideFromTop,
    TooltipAnimations.slideFromBottom,
  ];

  final Map<TooltipAnimationFunction, String> _animationNames = {
    TooltipAnimations.scale: 'Scale',
    TooltipAnimations.slideFromTop: 'Slide from Top',
    TooltipAnimations.slideFromBottom: 'Slide from Bottom',
  };

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      showDelay: _delayValue,
      animationDuration: _animationDuration,
      animationCurve: _animationCurve,
      animationFunction: _animationFunction,
      format: 'point.x : point.y',
    );
    super.initState();
  }

  List<ChartData> get chartData => [
    ChartData('Jan', 35),
    ChartData('Feb', 28),
    ChartData('Mar', 34),
    ChartData('Apr', 32),
    ChartData('May', 40),
    ChartData('Jun', 38),
    ChartData('Jul', 42),
    ChartData('Aug', 45),
  ];

  void _updateDelay(int newDelay) {
    setState(() {
      _delayValue = newDelay;
      _updateTooltipBehavior();
    });
  }

  void _updateAnimationDuration(int newDuration) {
    setState(() {
      _animationDuration = newDuration;
      _updateTooltipBehavior();
    });
  }

  void _updateAnimationCurve(Curve newCurve) {
    setState(() {
      _animationCurve = newCurve;
      _updateTooltipBehavior();
    });
  }

  void _updateAnimationFunction(TooltipAnimationFunction newFunction) {
    setState(() {
      _animationFunction = newFunction;
      print('Animation function changed to: ${_animationNames[newFunction]}');
      _updateTooltipBehavior();
    });
  }

  void _updateTooltipBehavior() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      showDelay: _delayValue,
      animationDuration: _animationDuration,
      animationCurve: _animationCurve,
      animationFunction: _animationFunction,
      format: 'point.x : point.y',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tooltip Delay & Animation Demo'),
      ),
      body: Column(
        children: [
          // Control panel for delay and animation adjustment
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Tooltip Show Delay: ${_delayValue}ms',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Delay buttons with highlighting
                Wrap(
                  spacing: 8,
                  children: _delayOptions.map((delay) {
                    final bool isSelected = _delayValue == delay;
                    return ElevatedButton(
                      onPressed: () => _updateDelay(delay),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.blue : null,
                        foregroundColor: isSelected ? Colors.white : null,
                      ),
                      child: Text(delay == 0 ? 'No Delay' : '${delay}ms'),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                // Animation duration selector
                Text(
                  'Animation Duration: ${_animationDuration}ms',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: _durationOptions.map((duration) {
                    final bool isSelected = _animationDuration == duration;
                    return ElevatedButton(
                      onPressed: () => _updateAnimationDuration(duration),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.green : null,
                        foregroundColor: isSelected ? Colors.white : null,
                      ),
                      child: Text('${duration}ms'),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                // Animation curve selector
                Text(
                  'Animation Curve: ${_curveNames[_animationCurve]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                DropdownButton<Curve>(
                  value: _animationCurve,
                  isExpanded: true,
                  items: _availableCurves.map((Curve curve) {
                    return DropdownMenuItem<Curve>(
                      value: curve,
                      child: Text(_curveNames[curve]!),
                    );
                  }).toList(),
                  onChanged: (Curve? newCurve) {
                    if (newCurve != null) {
                      _updateAnimationCurve(newCurve);
                    }
                  },
                ),
                SizedBox(height: 20),
                // Animation type selector
                Text(
                  'Animation Type: ${_animationNames[_animationFunction]}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                DropdownButton<TooltipAnimationFunction>(
                  value: _animationFunction,
                  isExpanded: true,
                  items: _availableAnimations.map((TooltipAnimationFunction animation) {
                    return DropdownMenuItem<TooltipAnimationFunction>(
                      value: animation,
                      child: Text(_animationNames[animation]!),
                    );
                  }).toList(),
                  onChanged: (TooltipAnimationFunction? newAnimation) {
                    if (newAnimation != null) {
                      _updateAnimationFunction(newAnimation);
                    }
                  },
                ),
                SizedBox(height: 10),
                Text(
                  'Try different animations: Scale (default) or Slide animations',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Chart with tooltip delay and animation
          Expanded(
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'Sales Data with Tooltip Delay & Animation'),
              tooltipBehavior: _tooltipBehavior,
              series: <CartesianSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Sales',
                  dataLabelSettings: DataLabelSettings(isVisible: false),
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    height: 8,
                    width: 8,
                    shape: DataMarkerType.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

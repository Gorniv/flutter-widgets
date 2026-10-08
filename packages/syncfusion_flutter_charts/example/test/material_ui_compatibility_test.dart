import 'dart:ui' show PointerDeviceKind;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/src/charts/axis/numeric_axis.dart';
import 'package:syncfusion_flutter_charts/src/charts/common/core_tooltip.dart';
import 'package:syncfusion_flutter_charts/src/charts/utils/helper.dart';

const points = <Offset>[Offset(0, 2), Offset(1, 3), Offset(2, 1)];
const info = TooltipInfo(
  primaryPosition: Offset(150, 100),
  secondaryPosition: Offset(150, 120),
  surfaceBounds: Rect.fromLTWH(0, 0, 800, 600),
  text: 'delayed tooltip',
);

Widget app(Widget child, {TextDirection direction = TextDirection.ltr}) {
  return MaterialApp(
    theme: ThemeData(
      platform: TargetPlatform.macOS,
      textTheme: const TextTheme(bodySmall: TextStyle(fontSize: 19)),
    ),
    home: Directionality(
      textDirection: direction,
      child: Scaffold(body: SizedBox(width: 600, height: 400, child: child)),
    ),
  );
}

CoreTooltip core(GlobalKey<CoreTooltipState> key, {int showDelay = 200}) {
  return CoreTooltip(
    key: key,
    showDelay: showDelay,
    animationDuration: 100,
    animationCurve: Curves.linear,
    builder: (context, data, size) => data == null ? null : Text(data.text!),
  );
}

Widget chart(String kind, TooltipBehavior tooltip) {
  switch (kind) {
    case 'cartesian':
      return SfCartesianChart(
        tooltipBehavior: tooltip,
        series: <CartesianSeries<Offset, double>>[
          LineSeries<Offset, double>(
            dataSource: points,
            xValueMapper: (point, _) => point.dx,
            yValueMapper: (point, _) => point.dy,
            animationDuration: 0,
          ),
        ],
      );
    case 'circular':
      return SfCircularChart(
        tooltipBehavior: tooltip,
        series: <CircularSeries<Offset, double>>[
          PieSeries<Offset, double>(
            dataSource: points,
            xValueMapper: (point, _) => point.dx,
            yValueMapper: (point, _) => point.dy,
            animationDuration: 0,
          ),
        ],
      );
    case 'funnel':
      return SfFunnelChart(
        tooltipBehavior: tooltip,
        series: FunnelSeries<Offset, double>(
          dataSource: points,
          xValueMapper: (point, _) => point.dx,
          yValueMapper: (point, _) => point.dy,
          animationDuration: 0,
        ),
      );
    default:
      return SfPyramidChart(
        tooltipBehavior: tooltip,
        series: PyramidSeries<Offset, double>(
          dataSource: points,
          xValueMapper: (point, _) => point.dx,
          yValueMapper: (point, _) => point.dy,
          animationDuration: 0,
        ),
      );
  }
}

void main() {
  testWidgets(
    'material_ui theme reaches dense numeric axis with bounded labels',
    (tester) async {
      await tester.pumpWidget(
        app(
          SfCartesianChart(
            primaryXAxis: const NumericAxis(
              name: 'bounded-axis',
              minimum: 0,
              maximum: 10000,
              interval: 1,
            ),
            series: <CartesianSeries<Offset, double>>[
              LineSeries<Offset, double>(
                dataSource: const [Offset(0, 1), Offset(10000, 2)],
                xValueMapper: (point, _) => point.dx,
                yValueMapper: (point, _) => point.dy,
                animationDuration: 0,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final axis = tester.allRenderObjects
          .whereType<RenderNumericAxis>()
          .singleWhere((axis) => axis.name == 'bounded-axis');
      expect(axis.visibleLabels.length, inInclusiveRange(2, 102));
      expect(axis.visibleLabels.first.value, 0);
      expect(axis.visibleLabels.last.value, 10000);
      expect(axis.chartThemeData!.axisLabelTextStyle!.fontSize, 19);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('desktop tooltip waits for the configured delay', (tester) async {
    final key = GlobalKey<CoreTooltipState>();
    await tester.pumpWidget(app(core(key)));
    await tester.pump();
    key.currentState!.show(info, PointerDeviceKind.mouse);
    await tester.pump(const Duration(milliseconds: 199));
    expect(find.text(info.text!), findsNothing);
    await tester.pump(const Duration(milliseconds: 2));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text(info.text!), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(find.text(info.text!), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final device in [PointerDeviceKind.mouse, PointerDeviceKind.touch]) {
    testWidgets('cancelling pending $device tooltip prevents showing it', (
      tester,
    ) async {
      final key = GlobalKey<CoreTooltipState>();
      await tester.pumpWidget(app(core(key)));
      await tester.pump();
      key.currentState!.show(info, device);
      key.currentState!.cancelShow();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(info.text!), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }

  testWidgets('disposing with a pending tooltip leaves no overlay or timer', (
    tester,
  ) async {
    final key = GlobalKey<CoreTooltipState>();
    await tester.pumpWidget(app(core(key)));
    await tester.pump();
    key.currentState!.show(info, PointerDeviceKind.mouse);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text(info.text!), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final kind in ['cartesian', 'circular', 'funnel', 'pyramid']) {
    testWidgets('$kind custom tooltip shows in overlay and disposes cleanly', (
      tester,
    ) async {
      final tooltip = TooltipBehavior(
        enable: true,
        showDelay: 100,
        animationDuration: 50,
        animationCurve: Curves.linear,
        animationFunction: TooltipAnimations.slideFromTop,
        builder: (data, point, series, pointIndex, seriesIndex) =>
            const Text('fork tooltip'),
      );
      await tester.pumpWidget(app(chart(kind, tooltip)));
      await tester.pumpAndSettle();
      expect(find.text('fork tooltip'), findsNothing);
      tooltip.showByIndex(0, 1);
      await tester.pump(const Duration(milliseconds: 110));
      await tester.pump(const Duration(milliseconds: 60));
      expect(find.text('fork tooltip'), findsOneWidget);
      expect(tester.takeException(), isNull);
      tooltip.hide();
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(find.text('fork tooltip'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  for (final direction in TextDirection.values) {
    testWidgets('shared tooltip markers align with labels in $direction', (
      tester,
    ) async {
      final tooltip = TooltipBehavior(
        enable: true,
        shared: true,
        showDelay: 0,
        animationDuration: 0,
        textStyle: const TextStyle(fontSize: 24),
      );
      await tester.pumpWidget(
        app(
          SfCartesianChart(
            tooltipBehavior: tooltip,
            series: [
              for (final name in ['Alpha', 'Beta'])
                LineSeries<Offset, double>(
                  name: name,
                  dataSource: points,
                  xValueMapper: (point, _) => point.dx,
                  yValueMapper: (point, _) => point.dy,
                  animationDuration: 0,
                ),
            ],
          ),
          direction: direction,
        ),
      );
      await tester.pumpAndSettle();
      tooltip.showByIndex(0, 1);
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump();
      final markers = find.byType(TooltipMarkerShapeRenderObject);
      expect(markers, findsNWidgets(2));
      for (var i = 0; i < 2; i++) {
        final label = find.textContaining(i == 0 ? 'Alpha' : 'Beta');
        expect(label, findsOneWidget);
        expect(
          (tester.getCenter(markers.at(i)).dy - tester.getCenter(label).dy)
              .abs(),
          lessThan(2),
        );
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
}

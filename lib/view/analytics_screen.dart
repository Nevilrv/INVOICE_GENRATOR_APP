import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:invoice_generator/constant/constant.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: kPrimarycolor,
                      ),
                    ),
                    SizedBox(
                      width: 65,
                    ),
                    Text(
                      "Product Selling Report",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                height: 400,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 25, left: 0, right: 5),
                width: double.infinity,
                child: LineChart(
                  LineChartData(
                      borderData: FlBorderData(show: false),
                      backgroundColor: Colors.grey.shade200,
                      titlesData: FlTitlesData(
                        rightTitles: SideTitles(showTitles: false),
                        topTitles: SideTitles(showTitles: false),
                      ),
                      lineBarsData: [
                        LineChartBarData(spots: [
                          FlSpot(0, 1),
                          FlSpot(1, 3),
                          FlSpot(2, 10),
                          FlSpot(3, 7),
                          FlSpot(4, 12),
                          FlSpot(5, 13),
                          FlSpot(6, 17),
                          FlSpot(7, 15),
                          FlSpot(8, 20)
                        ])
                      ]),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 200,
                child: PieChart(
                  PieChartData(
                      centerSpaceRadius: 10,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(
                            value: 10, color: Colors.purple, radius: 120),
                        PieChartSectionData(
                            value: 20, color: Colors.amber, radius: 120),
                        PieChartSectionData(
                            value: 30, color: Colors.green, radius: 120)
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

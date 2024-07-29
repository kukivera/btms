import 'package:flutter/material.dart';



class BarGraph extends StatelessWidget {
  final List<Map<String, dynamic>> data = [
    {'group': 'Teacher 1', 'value': 50},
    {'group': 'Teacher 2', 'value': 75},
    {'group': 'Teacher 3', 'value': 100},
    {'group': 'Teacher 4', 'value': 25},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var item in data) _buildBar(item['group'], item['value']),
            ],
          ),
          SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var item in data) _buildGroupText(item['group']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String group, int value) {
    return Tooltip(
      message: ' $value %',
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: value * 2.50, // Adjust the height of the bars
              width: 30.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0), // Adjust the corner radius as needed
              ),
            ),
          ),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }

  Widget _buildGroupText(String group) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        group,
        style: const TextStyle(fontSize: 5.0,
        color: Colors.black,
        ),
      ),
    );
  }
}

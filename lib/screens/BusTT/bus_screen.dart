import 'package:flutter/material.dart';

class DropDownItem {
  final String value;
  final String label;

  DropDownItem({
    required this.value,
    required this.label,
  });
}

class Bus {
  final DropDownItem source;
  final DropDownItem destination;
  final String distance;
  final String busType;
  final String departureTime;
  final String duration;

  Bus({
    required this.source,
    required this.destination,
    required this.distance,
    required this.busType,
    required this.departureTime,
    required this.duration,
  });
}

class BusScreen extends StatelessWidget {
  const BusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<DropDownItem> cities = [
      DropDownItem(value: 'Town A', label: 'Town A'),
      DropDownItem(value: 'Town B', label: 'Town B'),
      DropDownItem(value: 'Town C', label: 'Town C'),
    ];

    final List<Bus> buses = [
      Bus(
        source: cities[0],
        destination: cities[1],
        distance: '20 KM',
        busType: 'Mercedes Electric, 40 seater, AC',
        departureTime: '05:00 AM',
        duration: '35m',
      ),
      Bus(
        source: cities[1],
        destination: cities[2],
        distance: '30 KM',
        busType: 'Volvo Deluxe, 50 seater, Non-AC',
        departureTime: '06:30 AM',
        duration: '1h 15m',
      ),
      // További buszok...
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 100,
          ),
          const Text(
            'Mennél valahova Legény? ',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ), // Új szöveg hozzáadva
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SOURCE',),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      value: cities[0].value,
                      items: cities.map((item) {
                        return DropdownMenuItem(
                          value: item.value,
                          child: Text(item.label),
                        );
                      }).toList(),
                      onChanged: (String? value) {},
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DESTINATION'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton(
                      value: cities[1].value,
                      items: cities.map((item) {
                        return DropdownMenuItem(
                          value: item.value,
                          child: Text(item.label),
                        );
                      }).toList(),
                      onChanged: (String? value) {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton.icon(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
            label: const Text(
              'Search',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: buses.length,
              itemBuilder: (context, index) => BusCard(bus: buses[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class BusCard extends StatelessWidget {
  final Bus bus;

  const BusCard({Key? key, required this.bus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[700],
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bus.source.label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
                Expanded(
                  child: Text(
                    bus.destination.label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Icon(
                  Icons.directions,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    '${bus.distance}, via Town C',
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(
                  Icons.directions_bus,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    bus.busType,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  bus.departureTime,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 16,
                ),
                const Icon(
                  Icons.timelapse_rounded,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  bus.duration,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


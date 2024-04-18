import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_travel/database/travel_database.dart';
import 'package:app_travel/models/travel.dart';
import 'package:app_travel/pages/add_edit_page.dart';

class TravelDetailPage extends StatefulWidget {
  const TravelDetailPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _TravelDetailPageState createState() => _TravelDetailPageState();
}

class _TravelDetailPageState extends State<TravelDetailPage> {
  late Travel _travel;
  var _isLoading = false;

  Future<void> _refreshTravel() async {
    setState(() {
      _isLoading = true;
    });
    _travel = await TravelDatabase.instance.getTravelById(widget.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTravel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Detail'),
        actions: [
          _editButton(),
          _deleteButton(),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  _travel.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'City: ${_travel.city}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Number of People: ${_travel.numberOfPersons}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Travel Date: ${DateFormat.yMMMd().format(_travel.travelDate)}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cost: \$${_travel.cost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _editButton() {
    return IconButton(
      onPressed: () async {
        if (_isLoading) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditTravelPage(travel: _travel),
          ),
        );
        _refreshTravel();
      },
      icon: const Icon(Icons.edit_outlined),
    );
  }

  Widget _deleteButton() {
    return IconButton(
      onPressed: () async {
        if (_isLoading) return;
        await TravelDatabase.instance.deleteTravelById(_travel.id!);
        Navigator.pop(context);
      },
      icon: const Icon(Icons.delete),
    );
  }
}

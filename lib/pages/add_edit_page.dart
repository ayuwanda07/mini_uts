import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_travel/database/travel_database.dart';
import 'package:app_travel/models/travel.dart';

class AddEditTravelPage extends StatefulWidget {
  final Travel? travel;

  const AddEditTravelPage({Key? key, this.travel}) : super(key: key);

  @override
  _AddEditTravelPageState createState() => _AddEditTravelPageState();
}

class _AddEditTravelPageState extends State<AddEditTravelPage> {
  late TextEditingController _nameController;
  late TextEditingController _cityController;
  late TextEditingController _numberOfPersonsController;
  late TextEditingController _travelDateController;
  late TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.travel?.name ?? '');
    _cityController = TextEditingController(text: widget.travel?.city ?? '');
    _numberOfPersonsController = TextEditingController(
        text: widget.travel?.numberOfPersons.toString() ?? '');
    _travelDateController = TextEditingController(
        text: widget.travel?.travelDate.toString() ?? '');
    _costController = TextEditingController(
        text: widget.travel?.cost.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _numberOfPersonsController.dispose();
    _travelDateController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.travel != null ? 'Edit Travel Plan' : 'Add Travel Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _numberOfPersonsController,
              decoration: InputDecoration(labelText: 'Number of Persons'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _travelDateController,
              readOnly: true,
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 5),
                  lastDate: DateTime(DateTime.now().year + 5),
                );

                if (pickedDate != null) {
                  setState(() {
                    _travelDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
              decoration: InputDecoration(labelText: 'Travel Date'),
            ),
            TextField(
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildButtonSave(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        onPressed: () async {
          if (_isValid()) {
            await _saveTravel();
            Navigator.pop(context);
          }
        },
        child: Text(widget.travel != null ? 'Update' : 'Save'),
      ),
    );
  }

  bool _isValid() {
    return _nameController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _numberOfPersonsController.text.isNotEmpty &&
        _travelDateController.text.isNotEmpty &&
        _costController.text.isNotEmpty;
  }

  Future<void> _saveTravel() async {
    final newTravel = Travel(
      name: _nameController.text,
      city: _cityController.text,
      numberOfPersons: int.parse(_numberOfPersonsController.text),
      travelDate: DateTime.parse(_travelDateController.text),
      image: '', // Tidak menyertakan input image
      cost: double.parse(_costController.text),
    );

    if (widget.travel != null) {
      newTravel.id = widget.travel!.id;
      await TravelDatabase.instance.updateTravel(newTravel);
    } else {
      await TravelDatabase.instance.create(newTravel);
    }
  }
}

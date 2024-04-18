import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:app_travel/database/travel_database.dart'; // Sesuaikan dengan struktur database app_travel
import 'package:app_travel/models/travel.dart'; // Sesuaikan dengan struktur model app_travel
import 'package:app_travel/pages/add_edit_page.dart'; // Sesuaikan dengan struktur halaman add_edit_travel_page.dart
import 'package:app_travel/widgets/travel_card_widget.dart'; // Sesuaikan dengan struktur widget travel_card_widget.dart
import 'package:app_travel/pages/detail_page.dart'; // Sesuaikan dengan struktur halaman travel_detail_page.dart
import 'package:app_travel/widgets/custom_search_widget.dart';

String profilPic = "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D";
class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Travel> _travels;
  var _isLoading = false;

  Future<void> _refreshTravels() async {
    setState(() {
      _isLoading = true;
    });
    _travels = await TravelDatabase.instance.getAllTravels();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshTravels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,toolbarHeight: 100,
        backgroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Hi Travelers 👋',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'Travelling Today ?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network(
                profilPic,
                fit: BoxFit.cover,
                height: 60,
                width: 60,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0), // Sesuaikan dengan tinggi CustomSearchBar
          child: CustomSearchBar(), // Tambahkan CustomSearchBar di sini
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddEditTravelPage())); // Sesuaikan dengan halaman AddEditTravelPage
          _refreshTravels();
        },
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _travels.isEmpty
              ? const Text('Travels Kosong') // Ubah pesan menjadi 'Travels Kosong'
              : MasonryGridView.count(
                  crossAxisCount: 1,
                  itemCount: _travels.length,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  itemBuilder: (context, index) {
                    final travel = _travels[index];
                    return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TravelDetailPage(id: travel.id!))); // Sesuaikan dengan halaman TravelDetailPage
                          _refreshTravels();
                        },
                        child: TravelCardWidget(travel: travel, index: index)); // Sesuaikan dengan widget TravelCardWidget
                  }),
    );
  }
}

// ignore_for_file: library_private_types_in_public_api, missing_required_param

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../api/api.dart';
import '../../constant.dart';
import '../../data/data.dart';
import '../../login/login_page.dart';
import '../../model/country_model.dart';
import '../../model/popular_tours_model.dart';
import '../berita/all_berita.dart';
import '../berita/berita.dart';
import '../profil/profil.dart';
import 'all_wisata.dart';
import 'dashboard/dashboard_item.dart';
import 'list_wista.dart';
import 'populer_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> _fetchTampilWisata() async {
    var result = await http.get(Uri.parse(BaseURL.tampilwisata));
    var data = json.decode(result.body)['data'];
    print(data);
    return data;
  }

  Future<List<dynamic>> _fetchNoRand() async {
    var result = await http.get(Uri.parse(BaseURL.tampilNoRand));
    var data = json.decode(result.body)['data'];
    print(data);
    return data;
  }

  Future<List<dynamic>> _fetchTampilBerita() async {
    var result = await http.get(Uri.parse(BaseURL.berita));
    var data = json.decode(result.body)['data'];
    print(data);
    return data;
  }

  List<PopularTourModel> popularTourModels = [];
  List<CountryModel> country = [];
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    country = getCountrys();
    popularTourModels = getPopularTours();
    getPref();
    super.initState();
  }

  String? username, idUser, email;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      idUser = preferences.getString("idUser");
      email = preferences.getString("email");
    });
    print(idUser);
  }

  void _onMenuItemTapped(String title) {
    // Handle menu item tap
    print('$title tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kgreen,
        centerTitle: true,
        automaticallyImplyLeading: false, // This line removes the back button
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Image(
                          image: AssetImage('assets/user.png'), width: 50),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Profile(),
                            ));
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Icon(
                          Icons.edit,
                          color: kgreen,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      username != null
                          ? Text(
                              "$username, ",
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Traveller",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                      Text(
                        '$email',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 19.sp, vertical: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Popular Tours",
                style: TextStyle(
                    fontSize: 18.sp,
                    color: kblack,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Icon(Icons.location_on_rounded,
                      color: Colors.red, size: 16.sp),
                  Text(
                    "  Sesaot, Indonesia",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: kblack,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 240,
                width:
                    800, // Increase the width of SizedBox to accommodate wider cards
                child: FutureBuilder<List<dynamic>?>(
                  future: _fetchTampilWisata(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              width: 400, // Increase the width of the Container
                              child: CountryListTile(
                                idWisata: snapshot.data![index]['id_wisata'],
                                jenisWisata: snapshot.data![index]
                                    ['jenis_wisata'],
                                label: snapshot.data![index]['ket'],
                                countryName: snapshot.data![index]['nm_wisata'],
                                noOfTours: int.parse(
                                    snapshot.data![index]['harga_tiket']),
                                rating: double.parse(
                                    snapshot.data![index]['rating']),
                                jambuka: snapshot.data![index]['jam_buka'],
                                jamtutup: snapshot.data![index]['jam_tutup'],
                                alamat: snapshot.data![index]['alamat'],
                                video: snapshot.data![index]['link_video'],
                                imgUrl:
                                    "https://aksestryout.com/gis/img/${snapshot.data![index]['foto']}",
                                desc: snapshot.data![index]['deskripsi'],
                                lat: snapshot.data![index]['latitude_loc'],
                                lang: snapshot.data![index]['longitude_loc'],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              // Use a fixed height or Expanded for GridView
              SizedBox(
                height: 240,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 2 items per row
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    List<Map<String, dynamic>> menuItems = [
                      {'icon': Icons.home, 'title': 'Home'},
                      {'icon': Icons.search, 'title': 'Search'},
                      {'icon': Icons.notifications, 'title': 'Notif'},
                      {'icon': Icons.settings, 'title': 'Settings'},
                      {'icon': Icons.person, 'title': 'Profile'},
                      {'icon': Icons.help, 'title': 'Help'},
                    ];

                    return DashboardMenuItem(
                      icon: menuItems[index]['icon'],
                      title: menuItems[index]['title'],
                      onTap: () => _onMenuItemTapped(menuItems[index]['title']),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tempat terbaik",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: kblack,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailWisata(),
                            ));
                      },
                      child: Text(
                        "Lihat semua",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: kblue,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              FutureBuilder<List<dynamic>?>(
                future: _fetchNoRand(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return PopularTours(
                          jenisWisata: snapshot.data![index]['jenis_wisata'],
                          idWisata: snapshot.data![index]['id_wisata'],
                          label: snapshot.data![index]['ket'],
                          countryName: snapshot.data![index]['nm_wisata'],
                          noOfTours:
                              int.parse(snapshot.data![index]['harga_tiket']),
                          rating: double.parse(snapshot.data![index]['rating']),
                          jambuka: snapshot.data![index]['jam_buka'],
                          jamtutup: snapshot.data![index]['jam_tutup'],
                          alamat: snapshot.data![index]['alamat'],
                          video: snapshot.data![index]['link_video'],
                          lat: snapshot.data![index]['latitude_loc'],
                          lang: snapshot.data![index]['longitude_loc'],
                          imgUrl:
                              "https://aksestryout.com/gis/img/${snapshot.data![index]['foto']}",
                          desc: snapshot.data![index]['deskripsi'],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Berita Terkini",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: kblack,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllBerita(),
                            ));
                      },
                      child: Text(
                        "Lihat semua",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: kblue,
                        ),
                      ),
                    )
                  ],
                ),
              ),

              FutureBuilder<List<dynamic>?>(
                future: _fetchTampilBerita(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Berita(
                              id: snapshot.data![index]['id_berita'],
                              judul: snapshot.data![index]['judul'],
                              desc: snapshot.data![index]['isi_berita'],
                              view: snapshot.data![index]['view'],
                              imgUrl:
                                  "https://aksestryout.com/gis/berita_img/${snapshot.data![index]['gambar']}",
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

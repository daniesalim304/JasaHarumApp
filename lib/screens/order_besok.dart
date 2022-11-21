import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'lapor_order.dart';

class OrderBesok extends StatefulWidget {
  @override
  _OrderBesokState createState() => _OrderBesokState();
}

class _OrderBesokState extends State<OrderBesok> {
  var lat;
  var lng;
  String IDData;
  String status;
  String status_muatan;
  String barang;
  String alamatgudang;
  String gudang;
  String status_pengiriman;
  String uid;
  String error;
  String kotaasal;
  final databaseReference = Firestore.instance;
  var lokasiindex;

  getUid() {}

  @override
  void initState() {
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      print(val);
      setState(() {
        this.uid = val.uid;
      });
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  Widget _bodyku() {
    DateTime tanggal_hari_ini = new DateTime.now();
                String tanggalsaja = (int.parse(tanggal_hari_ini.day.toString().padLeft(2, '0')) + 1).toString();
                String tanggal =
                    "${tanggal_hari_ini.year.toString()}-${tanggal_hari_ini.month.toString().padLeft(2, '0')}-${tanggalsaja}";
                    print( "tanggal : " + tanggal);
                    print( "id_driver : " + uid.toString());

    return new StreamBuilder(
        stream: Firestore.instance
            .collection("order")
            .where("id_driver", isEqualTo: uid.toString())
            .where("tanggal_pengambilan_awal", isEqualTo: tanggal)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Padding(
              padding: EdgeInsets.all(50),
              child: Center(
                child: new CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
            var banyakdata = snapshot.data.documents.length;
            print("UID YANG LOGIN " + uid);
            for (var i = 0; i < banyakdata; i++) {
              if (snapshot.data.documents[i]["status"].toString() ==
                  "menunggu konfirmasi") {
                kotaasal = snapshot.data.documents[i]["asal_tujuan"];
                status = "Sedang Mengambil";
                IDData = snapshot.data.documents[i].documentID;
                status_muatan = snapshot.data.documents[i]["status"].toString();
                barang = snapshot.data.documents[i]["barang"];
                gudang = snapshot.data.documents[i]["asal_tujuan"];

                var datalokasi = Firestore.instance
                    .collection('gudang')
                    .document(snapshot.data.documents[i]["asal_tujuan"])
                    .get()
                    .then((DocumentSnapshot ds) {
                  lat = ds.data["lat"];
                  lng = ds.data["lng"];
                  alamatgudang = ds.data["alamatgudang"];
                });

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 15),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Untuk Tanggal : ",
                                      style: TextStyle(
                                          fontFamily: 'GoogleFont',
                                          fontSize: 14),
                                    ),
                                    Text(
                                      tanggal,
                                      style: TextStyle(
                                          fontFamily: 'GoogleFont',
                                          fontSize: 14,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Status : ",
                                      style: TextStyle(
                                          fontFamily: 'GoogleFont',
                                          fontSize: 16),
                                    ),
                                    Text(
                                      snapshot.data.documents[i]['status']
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: 'GoogleFont',
                                          fontSize: 17,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Barang : ",
                                      style: TextStyle(
                                          fontFamily: 'GoogleFont',
                                          fontSize: 22),
                                    ),
                                    Text(
                                      snapshot.data.documents[i]['barang']
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'GoogleFont',
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Asal : ",
                                      style: TextStyle(
                                          fontFamily: 'GoogleFont',
                                          fontSize: 30),
                                    ),
                                    Text(
                                      "Gudang " +
                                          snapshot
                                              .data.documents[i]['asal_tujuan']
                                              .toString(),
                                      style: TextStyle(
                                        fontFamily: 'GoogleFont',
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Batas Ambil : ",
                                    style: TextStyle(
                                        fontFamily: 'GoogleFont', fontSize: 18),
                                  ),
                                  Text(
                                    "20:00 WIB",
                                    style: TextStyle(
                                        fontFamily: 'GoogleFont',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  )
                                ],
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    
                    
                    Padding(
                      padding: EdgeInsets.only(left: 15, top: 30, right: 15),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Tidak Bisa Mengambil? Lapor ke Operator",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'OpenSansRegular'),
                          ),
                          new MaterialButton(
                            minWidth: MediaQuery.of(context).size.width - 30,
                            child: new Text("Lapor Operator",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'GoogleFont',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                            color: Colors.red,
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new LaporOrder(
                                          id_order: IDData, status_terakhir: snapshot
                                      .data.documents[i]["status"]
                                      .toString()
                                        )),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return new Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Tidak ada Order \nbaru untuk anda",
                            style: TextStyle(
                                fontFamily: 'GoogleFont', fontSize: 25),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
            }
          } else {
            return new Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Tidak ada Order \nbaru untuk anda",
                            style: TextStyle(
                                fontFamily: 'GoogleFont', fontSize: 25),
                          ),
                        ],
                      )
                    ],
                  ),
                );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _bodyku(),
    );
  }
}
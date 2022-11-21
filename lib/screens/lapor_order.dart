import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jasaharum/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LaporOrder extends StatefulWidget {
  @override
  _LaporOrderState createState() => _LaporOrderState();

  final String id_order;
  final String status_terakhir;
  LaporOrder({this.id_order, this.status_terakhir});
}

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}

class _LaporOrderState extends State<LaporOrder> {
  String uid;
  String dropdownvalue = '';
  Item selectedUser;
  String alasan;

  List<Item> users = <Item>[
    const Item(
        'Sakit',
        Icon(
          Icons.sentiment_very_dissatisfied,
          color: const Color.fromRGBO(21, 25, 101, 1),
        )),
    const Item(
        'Kendaraan Bermasalah',
        Icon(
          Icons.local_shipping,
          color: const Color.fromRGBO(21, 25, 101, 1),
        )),
    const Item(
        'Urusan Pribadi',
        Icon(
          Icons.directions_run,
          color: const Color.fromRGBO(21, 25, 101, 1),
        )),
    const Item(
        'Lainnya',
        Icon(
          Icons.warning,
          color: const Color.fromRGBO(21, 25, 101, 1),
        )),
  ];

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pehatian!"),
            content: new Text(
                "Anda akan melaporan tidak bisa mengambil order dan merubah status Order. Hubungi juga Operator setelah melaporkan via Aplikasi. Laporkan?"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("Tidak")),
              new FlatButton(
                  onPressed: () {
                    print("UID YANG LOGIN di halaman lapor" + uid);
                    final databaseReference = Firestore.instance;
                    databaseReference.collection("laporan").add({
                      'kategori_laporan': selectedUser.name,
                      'status_terakhir': widget.status_terakhir,
                      'id_order': widget.id_order,
                      'alasan_laporan': alasan.toString()
                    });
                    databaseReference
                        .collection('order')
                        .document(widget.id_order)
                        .updateData({'status': 'Driver Tidak bisa mengambil'});
                    databaseReference
                        .collection("driver")
                        .document(uid)
                        .updateData({'statusaktif': '1'});
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => new HomeApp()),
                    );
                  },
                  child: new Text("Ya"))
            ],
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
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

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(21, 25, 101, 1),
          title: Text(
            'Driver Jasa Harum',
            style: TextStyle(
              fontFamily: 'GoogleFont',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
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
                                "Kategori Laporan : ",
                                style: TextStyle(
                                    fontFamily: 'GoogleFont', fontSize: 22),
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
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 30,
                                child: DropdownButtonFormField<Item>(
                                  hint: Text(
                                    "Alasan Laporan",
                                  ),
                                  value: selectedUser,
                                  validator: (value) => value == null
                                      ? 'Pilih kategori Laporan'
                                      : null,
                                  onChanged: (Item Value) {
                                    setState(() {
                                      selectedUser = Value;
                                    });
                                    print(selectedUser.name);
                                  },
                                  items: users.map((Item user) {
                                    return DropdownMenuItem<Item>(
                                      value: user,
                                      child: Row(
                                        children: <Widget>[
                                          user.icon,
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            user.name,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
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
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Penjelasan Laporan : ",
                                style: TextStyle(
                                    fontFamily: 'GoogleFont', fontSize: 22),
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
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 30,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Jelasakan penyebab tidak bisa mengambil';
                                    }
                                    return null;
                                  },
                                  maxLength: 150,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                      hintText: "Alasan Tidak Bisa Mengambil"),
                                  onChanged: (dataalasan) {
                                    setState(() {
                                      alasan = dataalasan.toString();
                                    });
                                    print(alasan);
                                  },
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
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                  width: MediaQuery.of(context).size.width - 30,
                                  child: RaisedButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _showDialog();
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(6)),
                                    child: Text(
                                      "Kirim Laporan",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'GoogleFont',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                  )),
                              //BUAT MANGGIL PARSINGAN DATA
                              // widget.id_order
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

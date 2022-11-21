import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:jasaharum/home.dart';

class UpdateTujuan extends StatefulWidget {
  @override
  _UpdateTujuanState createState() => _UpdateTujuanState();

  final String id_order;
  final String asal;
  UpdateTujuan({this.id_order, this.asal});
}

class _UpdateTujuanState extends State<UpdateTujuan> {
  String banyak_muatan;

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pehatian!"),
            content: new Text(
                "Apakah tujuan pengiriman dan jumlah muatan sudah benar?"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: new Text("Tidak")),
              new FlatButton(
                  onPressed: () {
                    final databaseReference = Firestore.instance;
                    databaseReference
                        .collection('order')
                        .document(widget.id_order)
                        .updateData({
                      'status': 'Mengirim Ke Tujuan',
                      'id_harga': selectedtujuan.toString(),
                      'total_muatan': banyak_muatan
                    });
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

  var selectedtujuan, selectedType;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(21, 25, 101, 1),
          title: Text(
            'Kirim ke Tempat Tujuan',
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
                                "Tujuan Pengiriman : ",
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
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection("harga")
                                      .where("asal", isEqualTo: widget.asal)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return new Padding(
                                        padding: EdgeInsets.all(50),
                                        child: Center(
                                          child:
                                              new CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    if (!snapshot.hasData)
                                      const Text("Loading.....");
                                    else {
                                      List<DropdownMenuItem> currencyItems = [];
                                      for (int i = 0;
                                          i < snapshot.data.documents.length;
                                          i++) {
                                        DocumentSnapshot snap =
                                            snapshot.data.documents[i];
                                        currencyItems.add(
                                          DropdownMenuItem(
                                            child: Text(
                                              snap.data["tujuan"],
                                              style: TextStyle(
                                                  fontFamily: 'GoogleFont',
                                                  fontSize: 14,
                                                  color: Colors.red),
                                            ),
                                            value: '${snap.documentID}',
                                          ),
                                        );
                                      }
                                      currencyItems.add(DropdownMenuItem(
                                        child: Text(
                                          "tujuan lainnya ...",
                                          style: TextStyle(
                                              fontFamily: 'GoogleFont',
                                              fontSize: 14,
                                              color: Colors.red),
                                        ),
                                        value: 'tujuan-lainnya',
                                      ));
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                30,
                                            child: DropdownButtonFormField(
                                              items: currencyItems,
                                              validator: (value) => value ==
                                                      null
                                                  ? 'Pilih Tujuan Pengiriman'
                                                  : null,
                                              onChanged: (currencyValue) {
                                                // final snackBar = SnackBar(
                                                //   content: Text(
                                                //     'Tujuannya adalah $valuenya',
                                                //     style: TextStyle(color: Color(0xff11b719)),
                                                //   ),
                                                // );
                                                setState(() {
                                                  selectedtujuan =
                                                      currencyValue;
                                                  print(selectedtujuan);
                                                });
                                              },
                                              value: selectedtujuan,
                                              hint: new Text(
                                                "Pilih Tujuan Pengiriman",
                                                style: TextStyle(
                                                    fontFamily: 'GoogleFont',
                                                    fontSize: 16,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }
                                  }),
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
                                "Total Kubik Pengiriman : ",
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
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Masukkan M\u00B3 Muatan yang diangkut';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Berapa M\u00B3",
                                  ),
                                  onChanged: (banyakmuat) {
                                    setState(() {
                                      banyak_muatan = banyakmuat.toString();
                                    });
                                    print(banyak_muatan);
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
                                      "Perbaharui Order",
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

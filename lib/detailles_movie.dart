import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Movie_detailes extends StatefulWidget {
   Movie_detailes({Key? key, required this.name}) : super(key: key);
   final String name;
  @override
  State<Movie_detailes> createState() => _Movie_detailesState();


}

class _Movie_detailesState extends State<Movie_detailes> {

  late String poster = '';
  late String synopsis = '';

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Movies').get();
    querySnapshot.docs.forEach((doc) {
      if (doc["name"].toString() == widget.name) {
        setState(() {
          poster = doc["poster"].toString();
          synopsis = doc["synopsis"].toString();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title:  Text("detailles"),
      ),
      body: SingleChildScrollView(
        child: Wrap(
            children:[ Column(
              children: [
                Center(
                  child:
                    SizedBox(height: 100,width: 250,child:
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(widget.name,
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 56, shadows:<Shadow>[
                          Shadow(
                            offset: Offset(10.0, 10.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          Shadow(
                            offset: Offset(10.0, 10.0),
                            blurRadius: 8.0,
                            color: Color.fromARGB(125, 0, 0, 255),
                          ),
                        ],),
                        maxLines: 3,
                      ),),),


                ),
                SafeArea(child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Image( fit: BoxFit.cover,image: NetworkImage(poster),),
                )),
        Gap(20),
        Text("Synopsis:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
        Container(

          padding: EdgeInsets.all(16.0),
          child: Text(synopsis,
            style: TextStyle(fontSize: 16.0),
          ),
        )

              ],
            )]),
      ),
    );
  }
}

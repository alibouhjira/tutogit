import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'detailles_movie.dart';

class SearchMovie extends StatefulWidget {
  const SearchMovie({Key? key}) : super(key: key);

  @override
  State<SearchMovie> createState() => _SearchMovieState();
}

class _SearchMovieState extends State<SearchMovie> {

  String name = "";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search,color: Colors.white,),
              hintText: 'Rechercher'),
          onChanged: (val){
            print("debug: ${val}");
          setState(() {
            name=val;
          });
        },),
      ),


      body: StreamBuilder <QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection('Movies').snapshots() ,
        builder: (context,snapshots){
          return (snapshots.connectionState== ConnectionState.waiting)?
          Center(child: CircularProgressIndicator(),):
          ListView.builder(itemCount:snapshots.data!.docs.length,
              itemBuilder: (context,index){
            var data = snapshots.data!.docs[index].data() as Map<String,dynamic>;
            print(name);
            if (name.isEmpty){

              return ListBody(
                children: [
                  InkWell(
                    child:
                      Padding(padding:EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Image(width: MediaQuery.of(context).size.width/3,
                              height: MediaQuery.of(context).size.height/4,
                              fit: BoxFit.cover,image: NetworkImage(data['poster']),),
                              Gap(20),
                            SizedBox(height: 50,width: 150,child:
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                data['name'],
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),
                                maxLines: 3,
                              ),),),


                          ],
                        ),

                      ),
                    onTap: (){
                      var collectionReference = FirebaseFirestore.instance.collection('Movies');
                      var query = collectionReference.where('name', isEqualTo: data['name']);
                      late Movie_detailes m;
                      query.get().then((querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          m = Movie_detailes(name: doc['name']);

                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              // Construire le widget de destination ici
                              return m;
                            },
                          ),
                        );
                      });
                    }
                  )],


              );
            }
            if (data['name'].toString().toLowerCase().contains(name.toLowerCase())){
              return ListBody(
              children: [
              InkWell(
              child:
              Padding(padding:EdgeInsets.all(10),
              child: Row(
              children: [
              Image(width: MediaQuery.of(context).size.width/3,
              height: MediaQuery.of(context).size.height/4,
              fit: BoxFit.cover,image: NetworkImage(data['poster']),),
              Gap(20),
              SizedBox(height: 50,width: 150,child:
              FittedBox(
              fit: BoxFit.contain,
    child: Text(
    data['name'],
    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),
    maxLines: 3,
    ),),),


    ],
    ),

    ),
    onTap: (){
    var collectionReference = FirebaseFirestore.instance.collection('Movies');
    var query = collectionReference.where('name', isEqualTo: data['name']);
    late Movie_detailes m;
    query.get().then((querySnapshot) {
    querySnapshot.docs.forEach((doc) {

      m = Movie_detailes(name: doc['name']);
    });
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (BuildContext context) {
    // Construire le widget de destination ici
    return m;
    },
    ),
    );
    });
    }
    )],


    );

            }
    else return Container();

          });
        },
      ),
    );
  }
}
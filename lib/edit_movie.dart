

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiselect/multiselect.dart';

class EditMovie extends StatefulWidget {
  const EditMovie({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<EditMovie> createState() => _EditMovie();
}

class _EditMovie extends State<EditMovie> {


  List<String> categories=[];
  @override
  Widget build(BuildContext context) {
    var  nameController=TextEditingController(text: '') ;
    var yearController=TextEditingController(text: '') ;
    var posterController=TextEditingController(text: '') ;
    var descriptionController=TextEditingController(text: '') ;


  FirebaseFirestore.instance
      .collection('Movies')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      if(doc["name"].toString()==widget.name){
        print(doc['name']);
         nameController.text = widget.name as String;
         yearController.text = doc['year'];
         posterController.text = doc['poster'];
         descriptionController.text =doc['synopsis'];
      }
    });
  });


    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Center(child: Text("modifier un film"),),
      ),
      body: SafeArea(child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
            children: [
              ListTile(
                shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.indigo),),

                title: Row(
                  children: [
                    Text('nom:  '),
                    Expanded(child: TextField(decoration: InputDecoration(border: InputBorder.none),controller: nameController,)),
                  ],
                ),
              ),

              const SizedBox(height: 20,),
              ListTile(
                shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.indigo),),

                title: Row(
                    children: [
                      Text('année:  '),
                      Expanded(child: TextField(decoration: InputDecoration(border: InputBorder.none),controller: yearController,)),
                    ]
                ),

              ),
              const SizedBox(height: 20,),
              ListTile(
                shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.indigo),),

                title: Row(
                    children: [
                      Text('affiche:  '),
                      Expanded(child: TextField(decoration: InputDecoration(border: InputBorder.none),controller: posterController,)),
                    ]
                ),

              ),
              const SizedBox(height: 20,),
              ListTile(
                shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.indigo),),

                title: Row(
                    children: [
                      Text('synopsis:  '),
                      Expanded(child: TextField(decoration: InputDecoration(border: InputBorder.none),controller: descriptionController,)),
                    ]
                ),

              ),

              const SizedBox(height: 20,),
              DropDownMultiSelect(
                onChanged: (List<String> x) {
                  setState(() {
                    categories =x;
                  });
                },

                options: ['action' , 'aventure' , 'drame' , 'anime'],
                selectedValues: categories,
                whenEmpty: 'catégories',


              ),
              const SizedBox(height: 20,),
              ElevatedButton(style:ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)) ,
                  onPressed: ()=>{
    FirebaseFirestore.instance
        .collection('Movies')
        .get()
        .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
    if(doc["name"].toString()==widget.name){

                  doc.reference.update({
                  'name':nameController.text,
                  'year':yearController.text,
                  'poster':posterController.text,
                  'categories': categories,
                  'like':0,
                  'synopsis':descriptionController.text,
                  });
                  Navigator.pop(context);



    }

    });}
                  )},



                  child: Text("modifier"))


            ]
        ),



      )),




    ));
  }

}



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiselect/multiselect.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);


  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController =TextEditingController();
  final yearController =TextEditingController();
  final posterController =TextEditingController();
  final descriptionController =TextEditingController();
  List<String> categories=[];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Ajouter un film"),),
      ),
      body: Padding(
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
              for(int i =0 ;i<1000;i++){
                  FirebaseFirestore.instance.collection('Movies').add({
                    'name':nameController.text,
                    'year':yearController.text,
                    'poster':posterController.text,
                    'categories': categories,
                    'like':0,
                    'synopsis':descriptionController.text,
                    'liked':"true",
                  })}
                  ,Navigator.pop(context)},
                child: Text("ajouter"))


    ]
      ),



    ),




    );
  }
}

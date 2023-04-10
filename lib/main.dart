

import 'package:apptestbd/add_movie_page.dart';
import 'package:apptestbd/detailles_movie.dart';
import 'package:apptestbd/edit_movie.dart';
import 'package:apptestbd/set_like.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apptestbd/search_movie.dart';
import 'package:gap/gap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'filmes',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Flutter Demo Home Page',),

      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {




  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return  Scaffold(

      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.add),color: Colors.white,onPressed: ()=>{
          Navigator.of(context).push(
              MaterialPageRoute(
                builder:  (BuildContext context){
                  return const AddPage();
                },

                fullscreenDialog: true,

              )
          )

        }),
        actions: [
          IconButton( icon: Icon(Icons.search),color: Colors.white,onPressed: ()=>{
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder:  (BuildContext context){
                      return const SearchMovie();
                    }))})
        ],

        title: Center(child: Text("Accueil"),

        ),
      ),
      body:  _MoviesInformationState(),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}








class _MoviesInformationState extends StatefulWidget {
  const _MoviesInformationState({Key? key}) : super(key: key);

  @override
  State<_MoviesInformationState> createState() => _MoviesInformationStateState();

}

class _MoviesInformationStateState extends State<_MoviesInformationState> {

  IconData like_icon=Icons.add ;
  Future<void> addlike(id ,nblikes) async {
    String likeValue='';

    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('Movies').doc(id).get();


      if (docSnapshot.exists) {
        // Vérifiez si le champ "like" est présent dans le document
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('liked')) {
           likeValue = data['liked'];
           print(likeValue);
          print('Valeur du champ "like" : $likeValue');
        } else {
          print('Le champ "like" n\'est pas présent dans le document.');
        }
      } else {
        print('Le document n\'existe pas.');
      }
    } catch (e) {
      print('Erreur lors de la récupération du document : $e');
    }
    if (likeValue=="false"){
    nblikes++;
    FirebaseFirestore.instance.collection('Movies').doc(id).update({'like':nblikes,'liked':"true"});
   }
    else if(nblikes>0){nblikes--;FirebaseFirestore.instance.collection('Movies').doc(id).update({'like':nblikes,'liked':"false"});}
  }




  @override
  Widget build(BuildContext context) {
    final _moviesStream =FirebaseFirestore.instance.collection('Movies').snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _moviesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
             return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.error),
                Text('Something went wrong',),
              ],)

            ],);
        }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(

              child : Column(
                children:[
                  Text(""),

                ],),

            );
          }

          return  ListView(
              scrollDirection: Axis.vertical,

              children: snapshot.data!.docs.map((DocumentSnapshot document){
                Map<String, dynamic> movie = document.data()! as Map<String, dynamic>;
                return InkWell(child:SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25), // Couleur de l'ombre
                          blurRadius: 4, // Flou de l'ombre
                          spreadRadius: 2, // Étalement de l'ombre
                          offset: Offset(0, 2), // Décalage horizontal et vertical de l'ombre
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 230,


                    child: Row(//image et titre
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Column(
                            children: [
                              SizedBox(

                                width: MediaQuery.of(context).size.width / 3,
                                height: 210,

                                child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(movie['poster']),
                                ),
                              ),
                            ],
                          ),

                        ),
                        Expanded(
                          flex: 6,
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Wrap(
                                  direction: Axis.horizontal, // Direction de disposition des enfants
                                  alignment: WrapAlignment.start, // Alignement horizontal des enfants
                                  spacing: 8.0, // Espacement horizontal entre les enfants
                                  runSpacing: 8.0, // Espacement vertical entre les lignes
                                  children: [
                                    Text(
                                      movie['name'],
                                      style: TextStyle(fontSize: 26.0,fontWeight: FontWeight.bold),
                                      maxLines: 2, // Limite le texte à une seule ligne
                                      overflow: TextOverflow.ellipsis,// Style du texte
                                    ),

                                  ],

                                ),

                              ),
                              Text(
                                movie['year'],
                                style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.normal),
                                maxLines: 1, // Limite le texte à une seule ligne
                                overflow: TextOverflow.ellipsis,// Style du texte
                              ),
                              Expanded(
                                flex: 1,
                                child: Wrap(
                                  children: [
                                    for(final categories in movie['categories'])
                                      Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Chip(
                                          backgroundColor: Colors.black,
                                          label: Text(categories,style:TextStyle(fontSize: 14,fontWeight: FontWeight.w800)),
                                        ),

                                      )
                                  ],
                                ),
                              ),
                            Expanded(
                              flex: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,



                                children: [
                                  IconButton(

                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            // Construire le widget de destination ici
                                            return EditMovie(name:movie['name']);
                                          },
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit_outlined),iconSize:40,color: Colors.white
                                    ,),
                                 IconButton(

                                     onPressed: () async {
                                          FirebaseFirestore.instance
                                              .collection('Movies')
                                              .get()
                                              .then((QuerySnapshot querySnapshot) {
                                          querySnapshot.docs.forEach((doc) {
                                          if(doc["name"].toString()==movie['name']){

                                          doc.reference.delete();
                                 }});});},
                                        icon: Icon(Icons.delete),iconSize:40,color: Colors.white
                                   ,),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(onPressed: ()=>addlike(document.id,movie['like']) ,icon: Setlike(isliked:movie['liked'] )),
                                         Gap(5),
                                          Text(movie['like'].toString(),style: TextStyle(fontSize: 20),),
                                        ],
                                      ),

                                  ]
                              ),
                            )
                            ],
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
                    onTap: (){
                      var collectionReference = FirebaseFirestore.instance.collection('Movies');
                      var query = collectionReference.where('name', isEqualTo: movie['name']);
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
                      });}
                );
              }).toList()
          )
          ;
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app_flutter/Provider/AllUsersProvider.dart';
import 'package:dating_app_flutter/Provider/UserProvider.dart';
import 'package:dating_app_flutter/Screens/conversationScreen.dart';
import 'package:dating_app_flutter/common/theme_helper.dart';
import 'package:dating_app_flutter/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserViews extends StatefulWidget {
  const UserViews({Key? key}) : super(key: key);


  @override
  State<UserViews> createState() => _UserViewsState();
}

class _UserViewsState extends State<UserViews> {

  DatabaseMethod databaseMethod = new DatabaseMethod();

  creatChatRoomAndStartConversation({String? username, String? userImage}) async {
    UserProvider userProvider = Provider.of<UserProvider>(context,listen: false);
    print("helllllllllllllllo ${userProvider.userModel.name.toString()}");
    if(username != userProvider.userModel.name.toString()){
       String chatRoomId = await getChatRoomId(username!, userProvider.userModel.name.toString());
      List<String> users = [username ,userProvider.userModel.name.toString()];
      Map<String,dynamic> chatRoomMap={
        "user": users,
        username: userImage,
        userProvider.userModel.name.toString() : userProvider.userModel.imageUrl.toString(),
        "chatRoomId": chatRoomId
      };

      DatabaseMethod().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ConversationScreen(chatRoomId: chatRoomId, userName: username,imageUrl: userImage!,)));
    }else{
      print("you can not send messege to yourself");
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }


  @override
  Widget build(BuildContext context) {

    final allUsersProvider = Provider.of<AllUsersProvider>(context,listen: false);

    return Scaffold(
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: allUsersProvider.getAllUsers(context).asStream(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null)
                ? Center( child:  CircularProgressIndicator(),) :

            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              // here we use our demo procuts list
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data =
                  snapshot.data!.docs[index];

                    return data['status'] == 'online' ? GestureDetector(
                      onTap: (){
                        creatChatRoomAndStartConversation(username: data['name'], userImage: data['imageUrl']);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(

                          width: (MediaQuery.of(context).size.width/2)-15,
                          height: 150,
                          decoration: BoxDecoration(

                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            image: DecorationImage(
                              image: NetworkImage(data['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child:  Padding(
                            padding: EdgeInsets.all(0),
                            child: Container(

                              decoration:  BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                gradient: LinearGradient(
                                    colors: [
                                      Palette.fullBlue,
                                      Color(0x19000000),
                                    ],
                                    begin: FractionalOffset(0.0, 1.5),
                                    end: FractionalOffset(0.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(

                                          children: [
                                            Text(
                                              data['name'].toString().toUpperCase(),
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(data['age']
                                              ,
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900,color: Palette.fullBlue),
                                            ),
                                          ],
                                        ),
                                        Text(data['country']
                                          ,
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,color: Palette.primary),
                                        ),
                                      ],
                                    ),
                                    Text(data['status']
                                      ,
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ) :
                    GestureDetector(
                      onTap: (){
                        print("current image is ${data['imageUrl']}");
                        creatChatRoomAndStartConversation(username: data['name'], userImage: data['imageUrl']);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(

                          width: (MediaQuery.of(context).size.width/2)-15,
                          height: 150,
                          decoration: BoxDecoration(

                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            image: DecorationImage(
                              image: NetworkImage(data['imageUrl']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child:  Padding(
                            padding: EdgeInsets.all(0),
                            child: Container(

                              decoration:  BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                gradient: LinearGradient(
                                    colors: [
                                      Palette.fullBlue,
                                      Color(0x19000000),
                                    ],
                                    begin: FractionalOffset(0.0, 1.5),
                                    end: FractionalOffset(0.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(

                                          children: [
                                            Text(
                                              data['name'].toString().toUpperCase(),
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(data['age']
                                              ,
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900,color: Palette.fullBlue),
                                            ),
                                          ],
                                        ),
                                        Text(data['country']
                                          ,
                                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,color: Palette.primary),
                                        ),
                                      ],
                                    ),
                                    Text(data['status']
                                      ,
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                });
          },
        ),
      ),
    );
  }

  screenWidth(BuildContext context) {

  }
}

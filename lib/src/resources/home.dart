import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tclearpartner/src/app.dart';
import 'package:tclearpartner/src/firebase/fire_store.dart';
import 'package:tclearpartner/src/firebase/firebase.dart';
import 'package:tclearpartner/src/resources/accept_job.dart';
import 'package:tclearpartner/src/resources/calendar_job.dart';
import 'package:tclearpartner/src/resources/generate_screen.dart';
import 'package:tclearpartner/src/resources/history_page.dart';
import 'package:tclearpartner/src/resources/new_job.dart';
import 'package:tclearpartner/src/resources/notification_page.dart';
import 'package:tclearpartner/src/resources/setting_page.dart';
import 'package:tclearpartner/src/utils/colors.dart';
import 'package:tclearpartner/src/utils/get_image_storage.dart';
import 'package:tclearpartner/src/utils/image.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseUser user;
  HomeScreen(this.user);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin{
  final PageStorageBucket bucket = PageStorageBucket();
  bool mapToggle = false;
  Position _currentLocation;
  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        print(_currentLocation);
        _currentLocation = currloc;
        mapToggle = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(widget.user),
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(imageLogo, height: 30, width: 30, color: white,),
              SizedBox(width: 5,),
              Text('TClear',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.normal,
                    color: white
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          StreamBuilder(
              stream: store
                  .collection('thongbaopartner')
                  .document(widget.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return  IconButton(
                      icon: Icon(Icons.notifications_active),);
                  default:
                    DocumentSnapshot document = snapshot.data;
                    if(document.data != null){
                      List<dynamic> list = snapshot.data['list_notification'];
                      return Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          IconButton(
                              icon: Icon(Icons.notifications_active),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => NotificationPage(widget.user.uid)));
                              }),
                          list.length != 0 ?CircleAvatar(
                            child: Text(
                              '${list.length}',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            radius: 8,
                            backgroundColor: Colors.amberAccent,
                          ) : SizedBox(),
                        ],
                      );
                    }else{
                      return IconButton(
                          icon: Icon(Icons.notifications_active),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => NotificationPage(widget.user.uid)));
                          });
                    }
                }
              })
        ],
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 50),
              color: white,
              child: TabBar(
                  isScrollable: false,
                  labelColor: green,
                  indicatorColor: green,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(text: "VIỆC MỚI"),
                    Tab(text: "XÁC NHẬN"),
                  ]),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: PageStorage(
                  bucket: bucket,
                  child: TabBarView(children: [
                    Container(child: _buildTapJob(context)),
                    //Container(child: _buildTapExample(context)),

                    Container(
                      child: _buildTapAccept(context),
                    ),
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTapExample(BuildContext context) {
    return StreamBuilder(
      stream: GetStore.getListNewJob(),
        builder: (context, snap){
      return Text('abv');
    });
  }

  Widget _buildTapJob(BuildContext context) {
    var storeCongViecChoLam = store.collection('dangvieclam').snapshots();

    return mapToggle ? FutureBuilder(
        future: FirestoreGetInforUser.getUserModel(),
        builder: (context, user) {
          switch(user.connectionState){
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator(),);
            default:
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                child: StreamBuilder(
                    stream: storeCongViecChoLam,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data.documents.length != 0) {
                        return ListView(
                          children: snapshot.data.documents.map<Widget>((document) {
                            List<dynamic> listWork = document['list_work'];

                            String idCustomer = document.documentID;
                            return (listWork != null && listWork.length != 0)
                                ? Column(
                              children: listWork.map((idDetail) {
                                return
                                  NewJob(idCustomer, user.data, idDetail, _currentLocation);
                              }).toList(),
                            )
                                : SizedBox();
                          }).toList(),
                        );
                      } else {
                        return Center(
                          child: Text('Không có công việc'),
                        );
                      }
                    }),
              );
          }

        }
    ) : Center(
      child: Text('Không có công việc'),
    );
  }

  Widget _buildTapAccept(BuildContext context) {
    var storeCongViecChoLam =
    store.collection('nhanviec').document(widget.user.uid).snapshots();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 150,
      child: StreamBuilder(
          stream: storeCongViecChoLam,
          builder: (context, snapshot) {
            List<dynamic> listWork = [];
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text('Không có công việc'),
                );
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                DocumentSnapshot documentSnapshot = snapshot.data;
                if(documentSnapshot.data != null){
                  listWork.clear();
                  listWork = snapshot.data['list_work'];
                  return listWork != null && listWork.length != 0
                      ? ListView(
                    children: listWork.map((idWork) {
                      return AcceptJob(widget.user.uid, idWork);
                    }).toList(),
                  )
                      : Center(
                    child: Text('Không có công việc'),
                  );}else{
                  return Center(
                    child: Text('Không có công việc'),
                  );
                }
            }
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class NavDrawer extends StatefulWidget {
  final FirebaseUser partner;
  NavDrawer(this.partner);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: StreamBuilder(
                stream: store
                    .collection('userpartners')
                    .document(widget.partner.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                CircleAvatar(
                                  child: ClipOval(
                                    child: SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: snapshot.data['image'] != null ? GetImageAvtStorage(snapshot.data['image']) : Image.asset(imageAvatar, fit: BoxFit.fill,),
                                    ),
                                  ),
                                  radius: 40,
                                ),
                                Text(
                                  '${snapshot.data['name']}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  textAlign:  TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: FutureBuilder(
                                future: AddStore.avgStar(widget.partner.uid),
                                builder: (context, snapStar) {
                                  switch (snapStar.connectionState) {
                                    case ConnectionState.waiting:
                                      return Text(
                                        'Chuyên nghiệp',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16),
                                      );
                                    case ConnectionState.done:
                                      double star = 0;
                                      if(!snapStar.data.isNaN){
                                        star = snapStar.data;}
                                      return Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Chuyên nghiệp',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              star > 0
                                                  ? Icon(
                                                star < 1 ? Icons.star_half : Icons.star,
                                                color: Colors.yellow,
                                              )
                                                  : Icon(Icons.star_border,  color: Colors.yellow,),
                                              star > 1
                                                  ? Icon(
                                                star < 2 ? Icons.star_half : Icons.star,
                                                color: Colors.yellow,
                                              )
                                                  : Icon(Icons.star_border,  color: Colors.yellow,),
                                              star > 2
                                                  ? Icon(
                                                star < 3 ? Icons.star_half : Icons.star,
                                                color: Colors.yellow,
                                              )
                                                  : Icon(Icons.star_border,  color: Colors.yellow,),
                                              star > 3
                                                  ? Icon(
                                                star < 4 ? Icons.star_half : Icons.star,
                                                color: Colors.yellow,
                                              )
                                                  : Icon(Icons.star_border, color: Colors.yellow,),
                                              star > 4
                                                  ? Icon(
                                                star < 5 ? Icons.star_half : Icons.star,
                                                color: Colors.yellow,
                                              )
                                                  : Icon(Icons.star_border,  color: Colors.yellow,) ,
                                            ],
                                          ),
                                          Text(
                                            '${star.toStringAsFixed(2)}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ],
                                      );
                                    default:
                                      return Center(
                                          child: Icon(Icons.star_border,  color: Colors.yellow,)
                                      );
                                  }
                                }),
                          )
                        ],
                      );
                  }
                }),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Lịch làm việc'),
            onTap: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => CalendarJob(widget.partner.uid)))
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.dvr),
            title: Text('QR code'),
            onTap: () => {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text('Hướng dẫn sử dụng mã QR'),
                    content: Text('Bạn hãy đưa mà QR này cho khách hàng khi làm việc,'
                        ' để xác nhận thông tin của mình và để đánh dấu sự đã đến của mình, và đã đến làm việc'),
                    actions: [
                      FlatButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text('Đóng', style: TextStyle(color: Colors.black),)),
                      FlatButton(onPressed: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => GenerateScreen(widget.partner.uid)));
                      }, child: Text('Tiếp tục', style: TextStyle(color: Colors.green),)),
                    ],
                  )),

            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Lịch sử công việc'),
            onTap: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => HistoryPage(widget.partner.uid)))
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Thay đổi thông tin'),
            onTap: () {
              FirestoreGetInforUser.getUserModel().then((userModel){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => SettingPage(userModel)));
              });

            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Đăng xuất'),
            onTap: () {
              showDialog(context: context, child: AlertDialog(
                content: Text('Bạn muốn đăng xuất'),
                actions: [
                  FlatButton(onPressed: () {
                    auth.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/app', (Route<dynamic> route) => false);
                  }, child: Text('Đăng xuất', style: TextStyle(color: green,),)),
                  FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('Đóng', style: TextStyle(color: black,))),
                ],
              ));
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

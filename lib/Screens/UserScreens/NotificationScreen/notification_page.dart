import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniq/Theme/theme.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.Blackcolor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, top: 10.0, bottom: 10),
                  child: Text("Notifications",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white)),
                ),
                TextNotificationAdaptor(),
                TextNotificationAdaptor(),
                TextNotificationAdaptor(),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //         left: 15.0, right: 15, top: 10, bottom: 10),
                //     child: MaterialButton(
                //         onPressed: () {
                //           // Navigator.push(
                //           //     context,
                //           //     MaterialPageRoute(
                //           //         builder: (context) => HomeScreenBuyer()));
                //         },
                //         textColor: Colors.white,
                //         color: MyColors.Orangecolor,
                //         minWidth: double.infinity,
                //         height: 60,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(10.0)),
                //         child: const Text(
                //           "Publish notification",
                //           style: TextStyle(
                //               fontSize: 18,
                //               color: MyColors.Blackcolor,
                //               fontWeight: FontWeight.bold),
                //         )),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}

class TextNotificationAdaptor extends StatelessWidget {
  const TextNotificationAdaptor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5, bottom: 5),
      child: Card(
        color: MyColors.LightBlackcolor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          child: ExpandableNotifier(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://th.bing.com/th/id/R.40deba34f6c2decf532724c4c03f4fc4?rik=DmIMwHsFZgTrNw&riu=http%3a%2f%2fimg.doooor.com%2fimg%2fforum%2f201412%2f02%2f141955p15dugfkga555fcf.jpg&ehk=WtRMuE8T84Y04XeZy%2fCihE5BF1EwBS9p9QoEqnvYHXA%3d&risl=&pid=ImgRaw&r=0",
                          height: 50,
                          width: 60,
                          fit: BoxFit.cover,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "information of the content breifly",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Section infomation",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: MyColors.Orangecolor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: true,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      expandIcon: CupertinoIcons.arrow_down_right_arrow_up_left,
                      iconSize: 22,
                      iconColor: MyColors.Greencolor,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Notification content",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                    collapsed: Text(
                        "College notifications are showed in here sh jd djsh dsh sd jv svh jh sd sdj sj j sd sdj sd sdjs s sdjv sdj sd sdvj sdj sdj ja   hs jsj  v dsj sj js vsdj sd s sdm dj j saa ssg gdvvvd fsfs sy as asc vss z sv sgsg gs vg vgd v vskv svs vjsaisshjs j vsdv s dseyk dv  s nsd sd v djsh sdj sdj vds jsv sdjv sdj vsdjh vsdh sd vjs js vjs sdj djs hdsjh vsjh svdh j dvhjshsd sd sd hsd ghsdsdh  sdh sdh sjh sdvhsddgs ysgdvsdvdv bsdnvb bd znvb xbnbn xvvsd hjs sdn sd  vds sd sd shjuheuhj ev hs shjs d dv sdv sj sdjvdj dds v d sdjh dshjsd sd sdhj dshsj shjd sdjh sdhj sd vdh sds hdv hdh dvh jds dv hsdh vsuu ev ue udsvhds hd hsdh sdhjdsjsddsh ds ds sd jhsd jsdsd nsdj  veue h jhe ehj eh d sddsj dshjsdh vdhj dvhjds vdhsdjh vehhuekgfg g dg ds hjsdhdsd hsdh dsjh djhsd sdjh sdhj sdjdh sdhjsuheu heu hjdsh jh dsh s",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.justify,
                        softWrap: false,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    expanded: Column(
                      children: [
                        Text(
                            "College sh jd djsh dsh sd jv svh jh sd sdj sj j sd sdj sd sdjs s sdjv sdj sd sdvj sdj sdj ja   hs jsj  v dsj sj js vsdj sd s sdm dj j saa ssg gdvvvd fsfs sy as asc vss z sv sgsg gs vg vgd v vskv svs vjsaisshjs j vsdv s dseyk dv  s nsd sd v djsh sdj sdj vds jsv sdjv sdj vsdjh vsdh sd vjs js vjs sdj djs hdsjh vsjh svdh j dvhjshsd sd sd hsd ghsdsdh  sdh sdh sjh sdvhsddgs ysgdvsdvdv bsdnvb bd znvb xbnbn xvvsd hjs sdn sd  vds sd sd shjuheuhj ev hs shjs d dv sdv sj sdjvdj dds v d sdjh dshjsd sd sdhj dshsj shjd sdjh sdhj sd vdh sds hdv hdh dvh jds dv hsdh vsuu ev ue udsvhds hd hsdh sdhjdsjsddsh ds ds sd jhsd jsdsd nsdj  veue h jhe ehj eh d sddsj dshjsdh vdhj dvhjds vdhsdjh vehhuekgfg g dg ds hjsdhdsd hsdh dsjh djhsd sdjh sdhj sdjdh sdhjsuheu heu hjdsh jh dsh s",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.justify,
                            softWrap: false,
                            maxLines: 50,
                            overflow: TextOverflow.ellipsis),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: MyColors.Yellowcolor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Pdf View",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
// class PdfImageAdaptor extends StatelessWidget {
//   const PdfImageAdaptor({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network("https://th.bing.com/th/id/R.40deba34f6c2decf532724c4c03f4fc4?rik=DmIMwHsFZgTrNw&riu=http%3a%2f%2fimg.doooor.com%2fimg%2fforum%2f201412%2f02%2f141955p15dugfkga555fcf.jpg&ehk=WtRMuE8T84Y04XeZy%2fCihE5BF1EwBS9p9QoEqnvYHXA%3d&risl=&pid=ImgRaw&r=0",
//                       height: 80,width:80,
//                       fit: BoxFit.cover,)),
//                 Padding(
//                   padding: const EdgeInsets.only(left:10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Section infomation",style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),),
//                       SizedBox(height: 5,),
//                       Text("information of the content breifly",
//                         style: TextStyle(
//                           fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color:Colors.red,
//                           ),
//                           child:Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Text("View",style:TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold
//                             )),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }


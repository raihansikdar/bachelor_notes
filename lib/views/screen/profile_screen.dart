import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:shopping_notes/controller/fetch_shopping_data_controller.dart';
import 'package:shopping_notes/controller/my_drawer_controller.dart';
import 'package:shopping_notes/controller/transferData_controller.dart';
import 'package:shopping_notes/utils/app_colors.dart';
import 'package:shopping_notes/utils/assets_path.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfileScreen extends GetView<MyDrawerController> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  ZoomDrawer.of(context)?.close();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white38,
                  size: 30,
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(
                        AssetsPath.profileJPEG,
                      ),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        const Icon(Icons.image);
                      },
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Developed By 👋",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white54,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                "Mohammad Raihan Sikdar",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Divider(
                height: 8.0,
                thickness: 2.0,
                color: Colors.white38,
              ),
              const SizedBox(
                height: 8.0,
              ),
              GestureDetector(
                onTap: (){
                  _launchBrowser(url: "www.linkedin.com/in/raihansikdar/");
                },
                child: Row(
                  children: [
                   SvgPicture.asset(AssetsPath.linkedinSVG,height: 14,width: 14,color: AppColors.yellowColor,),
                    const SizedBox(width: 5,),
                    const Text("Connect with me",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              GestureDetector(
                onTap: (){
                  _lunchEmailUrl(mail: 'raihansikdar10@gmail.com');
                },
                child: Row(
                  children: [
                    Icon(Icons.email,color: AppColors.yellowColor,size: 15,),
                    const SizedBox(width: 5,),
                    const Text("Press here to mail me.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Divider(
                height: 8.0,
                thickness: 2.0,
                color: Colors.white38,
              ),
              const SizedBox(
                height: 8.0,
              ),

              GetBuilder<TransferDataController>(
                  builder: (_transferDataController) {
                    return GestureDetector(
                        onTap: (){
                          Get.find<FetchShoppingDataController>().searchShoppingNoteList.isEmpty ?
                          Get.snackbar("Empty", "There is no Notes.",colorText: Colors.white,icon: const Icon(Icons.delete_sweep,color: Colors.white,size: 30,))
                              : showDialog(context: context, builder: (context){

                            return AlertDialog(
                              backgroundColor: const Color.fromARGB(255, 56, 39, 39),
                              titlePadding: const EdgeInsets.only(top: 16,bottom: 8,left: 16,right: 16),
                              title: const Text("Confirm Delete",style: TextStyle(fontSize: 20.0,letterSpacing: 0.6 ,fontWeight: FontWeight.w600,color: Colors.white),),
                              contentPadding: const EdgeInsets.symmetric(vertical:8,horizontal: 16.0),
                              content: const Text("Are you sure you want to delete all the notes from home page.",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w400,color: Colors.yellow),),
                              actions: [
                                ElevatedButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: const Text("Cancel")),
                                ElevatedButton(onPressed: () async{
                                  final response = await _transferDataController.transferData();
                                  if(response == true){
                                    Get.snackbar("Successful", "Notes have been deleted",colorText:Colors.white,backgroundColor: Colors.green.withOpacity(0.7));
                                    Navigator.pop(context);
                                    Get.find<FetchShoppingDataController>().fetchData();
                                  }else{
                                    Get.snackbar("Failed", "Notes not deleted",colorText:Colors.white,backgroundColor: Colors.red.withOpacity(0.7));
                                  }
                                }, child: const Text("Delete")),
                              ],
                            );

                          });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete_sweep,color: AppColors.yellowColor,),
                            const SizedBox(width: 5,),
                            const Text("Delete all notes.",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ));
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }


  dynamic _lunchEmailUrl({required String mail}) async {
    try
    {
      Uri email = Uri(
        scheme: 'mailto',
        path: mail,
        queryParameters: {
          'subject': "want to develop apps"
        },
      );

      await launchUrl(email);
    }
    catch(e) {
      debugPrint(e.toString());
    }
  }

  dynamic _launchBrowser({required String url}) async {
    try
    {
      Uri email = Uri(
          scheme: 'https',
          path: url,
      );

      await launchUrl(email);
    }
    catch(e) {
      debugPrint(e.toString());
    }
  }
}
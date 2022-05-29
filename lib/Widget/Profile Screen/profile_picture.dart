import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicross_patient/Service/storage.dart';

import '../../Constant/colors.dart';
import '../../Model/screen_size.dart';
import '../../Service/database_service.dart';
import '../loading_dialog.dart';
import '../snack_bar.dart';


class ProfilePicture extends StatelessWidget {
  const ProfilePicture({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage =  Storage();
    return Badge(
                  alignment: Alignment.topRight,
                  badgeColor: primaryColor,
                badgeContent:  IconButton(
                    onPressed: () async {
                      try {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);

                        if (image?.path != null) {
                          final path = image?.path;
                          final name = image?.name;

                          showLoaderDialog(context);
                          
                          await storage
                              .uploadFile(path.toString(), name.toString())
                              .then((value) async {
                            String? url = await storage.getFile().then((value){
                              return value
                            });

                            DatabaseService.addImageUrl(url??"https://www.kindpng.com/picc/m/252-2524695_dummy-profile-image-jpg-hd-png-download.png");
                          });
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar("No Image selected",
                                  Icons.warning, Colors.red));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar("Something went wrong !",
                                  Icons.warning, Colors.red));
                      }
                    },
                    icon: const Icon(Icons.add_a_photo_rounded,color: kwhite),
                  ),
                  child: FutureBuilder<String>(
                    future: DatabaseService.getImage(),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> snapshot) {
                          if(snapshot.data == null){
                        return SizedBox(
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        height: ScreenSize.height * 0.17,
                        width: ScreenSize.width * 0.34,
                      );
                          }
                    
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: NetworkImage(snapshot.data.toString()),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: ScreenSize.height * 0.17,
                          width: ScreenSize.width * 0.34,
                        ); 
                    },
                  ),
                );
  }
}
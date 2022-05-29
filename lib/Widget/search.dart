import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Model/screen_size.dart';
import '../Provider/homepage_controller.dart';
import 'custom_textfield.dart';

class SearchArea extends StatefulWidget {
  const SearchArea({Key? key}) : super(key: key);

  @override
  State<SearchArea> createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenSize.height * 0.01),
      child: SizedBox(
        width: ScreenSize.width * 0.9,
        height: ScreenSize.height * 0.08,
        child: CustomTextField(
          isUnderlineField: true,
          onChanged: (val) {
            Provider.of<HomePageController>(context, listen: false)
                .searchOnChange(val);
          },
          prefixIcon: Icons.search,
          hintText: "Search Doctors",
        ),
      ),
    );
  }
}

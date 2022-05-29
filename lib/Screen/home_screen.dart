import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Service/database_service.dart';
import '../Widget/Home Screen/doc_card_list.dart';
import '../Widget/Home Screen/specialization_chips.dart';
import '../Widget/Home Screen/top_welcome_tile.dart';
import '../Widget/search.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Provider.of<DatabaseService>(context, listen: false).getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<DatabaseService>(context, listen: false).getProfileDetails();
    return Column(
      children: const [
        TopWelcomeTiles(),
        SearchArea(),
        SpecializationChips(),
        DocCardList(),
      ],
    );
  }
}




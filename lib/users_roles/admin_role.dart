import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:microlearning/components/admins_blocks/admins_blocks.dart';

class AdminRole extends StatefulWidget {
  @override
  _AdminRoleState createState() => _AdminRoleState();
}

class _AdminRoleState extends State<AdminRole> {

  @override
  Widget build(BuildContext context) {
    final List<String> butList = [
      AppLocalizations.of(context).addDivision,
      AppLocalizations.of(context).addModerator,
      AppLocalizations.of(context).addCourse,
      AppLocalizations.of(context).addCourseCard,
    ];

    return SafeArea(
      child: ListView.builder(
          itemCount: butList.length,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (_, index) => AdminBlock(
                items: butList,
                i: index,
              )),
    );
  }
}

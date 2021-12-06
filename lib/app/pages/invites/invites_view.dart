import 'package:dazle/app/pages/invites/components/invites_list_tile.dart';
import 'package:dazle/app/pages/invites/invites_controller.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/form_fields/custom_search_field.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class InvitesPage extends View {
  InvitesPage({Key key}) : super(key: key);

  @override
  _InvitesPageState createState() => _InvitesPageState();
}


class _InvitesPageState extends ViewState<InvitesPage, InvitesController> {
  _InvitesPageState() : super(InvitesController(DataConnectionRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: 'Invites',
      ),
      backgroundColor: Colors.white,
      body: ListView(
        physics: ScrollPhysics(),
        children: [
          ControlledWidgetBuilder<InvitesController>(
            builder: (context, controller) {
              return Container(
                decoration: AppConstant.bottomBorder,
                child: CustomSearchField(
                  controller: controller.searchTextController,
                  hintText: 'Search, invite or notify agent',
                  iconData: Icons.contacts_outlined,
                  onChanged: (value) {
                    print('onChanged onChanged $value');
                    controller.searchUser();
                  },
                  suggestionsCallback: (pattern) async {
                    print('suggestionsCallback $pattern');

                    return null;
                  },
                  onSuggestionSelected: (suggestion) {
                    controller.searchTextController.text = suggestion;
                    controller.getInvites(filterByName: suggestion);
                  },
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();

                    controller.getInvites(filterByName: value);
                  },
                  onPressedButton: () {
                  },
                ),
              );
            }
          ),
          InvitesListTile()
        ],
      )
    );
  }
}
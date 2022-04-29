import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/data_connection_repository.dart';
import '../../utils/app_constant.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_loading_format.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/form_fields/custom_search_field.dart';
import 'components/my_connection_list_tile.dart';
import 'my_connection_controller.dart';

class MyConnectionPage extends View {
  MyConnectionPage({Key? key}) : super(key: key);

  @override
  _MyConnectionPageState createState() => _MyConnectionPageState();
}

class _MyConnectionPageState
    extends ViewState<MyConnectionPage, MyConnectionController> {
  _MyConnectionPageState()
      : super(MyConnectionController(DataConnectionRepository()));

  @override
  Widget get view {
    return Scaffold(
        key: globalKey,
        appBar: CustomAppBar(
          title: 'My Connections',
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            ControlledWidgetBuilder<MyConnectionController>(
                builder: (context, controller) {
              return Row(
                children: [
                  controller.isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: CustomLoadingFormat(
                            margin: EdgeInsets.only(left: 20),
                            height: 17,
                            width: 85,
                            radius: 16,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: CustomText(
                            text: controller.myConnection.length > 1
                                ? "${controller.myConnection.length} connections"
                                : "${controller.myConnection.length} connection",
                            fontSize: 15,
                          ),
                        ),
                  Expanded(
                    child: Container(
                      decoration: AppConstant.bottomBorder,
                      child: CustomSearchField(
                        controller: controller.searchTextController,
                        hintText: 'Search by name',
                        withIcon: true,
                        iconData: Icons.contacts_outlined,
                        onChanged: (value) {
                          controller.searchUser();
                        },
                        suggestionsCallback: (pattern) async {
                          return [];
                        },
                        onSuggestionSelected: (suggestion) {
                          controller.searchTextController.text = suggestion;
                          controller.getMyConnection(filterByName: suggestion);
                        },
                        onSubmitted: (value) {
                          controller.getMyConnection(filterByName: value);
                        },
                        onPressedButton: () {},
                      ),
                    ),
                  )
                ],
              );
            }),
            MyConnectionListTile()
          ],
        ));
  }
}

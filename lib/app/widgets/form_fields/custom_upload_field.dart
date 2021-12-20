import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CustomUploadField extends StatefulWidget {
  final String text;

  /// default selected list of assets
  final List<AssetEntity> defaultSelected;

  /// on change value for asset image.
  final ValueChanged onAssetValue;

  const CustomUploadField({
    Key key,
    this.text,
    @required this.onAssetValue,
    @required this.defaultSelected
  }) : super(key: key);

  @override
  _CustomUploadFieldState createState() => _CustomUploadFieldState();
}

class _CustomUploadFieldState extends State<CustomUploadField> {
  List<AssetEntity> selectedAssets =[];

  @override
  void initState() {
    super.initState();
    widget.defaultSelected?.forEach((e) {
      selectedAssets.add(e);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomFieldLayout(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: CustomButton(
              text: widget.text ?? '',
              textColor: App.hintColor,
              backgroudColor: App.hintColor,
              main: false,
              onPressed: () async {
                var result = await AppConstant.loadAssets(context: context, selectedAssets: selectedAssets);
                
                setState(() {
                  selectedAssets = result;
                });

                widget.onAssetValue(selectedAssets);
              }
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: App.hintColor
            //   )
            // ),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: selectedAssets.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 5 : 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FutureBuilder(
                    future: selectedAssets[index].thumbDataWithSize(200, 200, format: ThumbFormat.png),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done){
                        return Stack(
                          overflow: Overflow.visible,
                          children: [
                            Positioned.fill(
                              child: Image.memory(
                                snapshot.data,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: App.hintColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      AppConstant.boxShadow
                                    ]
                                  ),
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  selectedAssets.removeAt(index);

                                  widget.onAssetValue(selectedAssets);
                                  // update photo container data
                                  setState(() { });
                                },
                              ),
                            )
                          ],
                        );
                      }
                        
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
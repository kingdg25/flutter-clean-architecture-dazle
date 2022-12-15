import 'dart:io';

import 'package:dazle/app/pages/listing_details/listing_details_presenter.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/pdf/pdf_generator.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:dazle/app/utils/app_constant.dart';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:share_plus/share_plus.dart';

class ListingDetailsController extends Controller {
  final ListingDetailsPresenter listingDetailsPresenter;

  User? _currentUser;

  User? get currentUser => _currentUser;

  Property? _selectedListing;
  Property? get selectedListing => _selectedListing;

  double progressValue = .25;
  bool showProgressBar = false;

  final listingId;

  ListingDetailsController(
      {DataListingRepository? dataListingRepo, this.listingId})
      : listingDetailsPresenter = ListingDetailsPresenter(dataListingRepo),
        super();

  @override
  void initListeners() async {
    await getCurrentUser();
    await getSelectedListing();

    // get selected listing
    listingDetailsPresenter.getSelectedListingOnNext = (Property res) {
      print('get selected listing on next $res');
      // if (res != null) {
      _selectedListing = res;
      // }
    };

    listingDetailsPresenter.getSelectedListingOnComplete = () {
      print('get selected listing on complete');
      refreshUI();
    };

    listingDetailsPresenter.getSelectedListingOnError = (e) {
      print('get selected listing on error $e');

      if (e is Map) {
        if (e.containsKey("error_type")) {
          AppConstant.statusDialog(
              context: getContext(),
              text: "${e.toString()}",
              title: "Something went wrong'");
        }
      }
    };

    // delete listing
    listingDetailsPresenter.deleteListinOnNext = () {
      print('delete listing on next');
    };

    listingDetailsPresenter.deleteListinOnComplete = () {
      print('delete listing on complete');
      AppConstant.showLoader(getContext(), false);
      _statusDialog('Success!', 'Deleted Sucessfully');
    };
    listingDetailsPresenter.deleteListinOnError = (e) {
      print('delete listing on eror $e');
      AppConstant.showLoader(getContext(), false);

      if (!e['error']) {
        _statusDialog('Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog('Something went wrong', '${e.toString()}');
      }
    };
  }

  getCurrentUser() async {
    User user = await App.getUser();

    // if (user != null) {
    _currentUser = user;
    refreshUI();
    // }
  }

  getSelectedListing() async {
    listingDetailsPresenter.getSelectedListing(listingId);
  }

  deleteListing({String? listingId}) async {
    listingDetailsPresenter.deleteListing(listingId!);
  }

  getListingToDisplay() async {}

  _statusDialog(String title, String text,
      {bool? success, Function? onPressed}) {
    AppConstant.statusDialog(
        context: getContext(),
        success: success ?? false,
        title: title,
        text: text,
        onPressed: onPressed);
  }

  void showHideProgressBar() {
    if (showProgressBar) {
      showProgressBar = false;
    } else {
      showProgressBar = true;
    }
    refreshUI();
  }

  void setProgressBarValue(double newProgressValue) {
    progressValue = newProgressValue;
    refreshUI();
  }

  String progressPercentage() {
    double initial = progressValue / 1;
    double percent = initial * 100;

    return '$percent';
  }

  showModal() {
    showModalBottomSheet(
      context: getContext(),
      builder: ((builder) => bottomSheet()),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(getContext()).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          CustomText(
            text: 'Share Listing as',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  icon: Icon(
                    Icons.picture_as_pdf,
                    color: App.mainColor,
                    size: 30,
                  ),
                  label: CustomText(
                    text: 'PDF',
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () async {
                    Navigator.pop(getContext());
                    User currentUser = await App.getUser();
                    if (currentUser.accountStatus != 'Deactivated') {
                      AppConstant.mixPanelInstance!
                          .track('Share Listing as PDF');
                      showHideProgressBar();

                      await Future.delayed(const Duration(milliseconds: 700));
                      setProgressBarValue(.5);

                      String? pdfFilePath = await PdfGenerator()
                          .sharePdf(property: this._selectedListing!);

                      setProgressBarValue(1);
                      await Future.delayed(
                          const Duration(seconds: 1, milliseconds: 300));

                      List<String> filePaths = [];
                      filePaths.add(pdfFilePath!);

                      await Share.shareFiles(
                        filePaths,
                        mimeTypes: [
                          Platform.isAndroid ? "image/jpg" : "application/pdf"
                        ],
                        subject:
                            'Dazle Property Listing-${this.selectedListing!.id}',
                        text:
                            'Dazle Property Listing-${this._selectedListing!.id}',
                      );
                      setProgressBarValue(.25);
                      showHideProgressBar();
                    } else {
                      AppConstant.statusDialog(
                          context: getContext(),
                          title: 'Action not Allowed',
                          text: 'Please Reactivate your account first.',
                          success: false);
                    }
                  },
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  icon: Icon(
                    Icons.share,
                    color: App.mainColor,
                  ),
                  label: CustomText(
                    text: 'Link',
                    fontWeight: FontWeight.w500,
                  ),
                  onPressed: () async {
                    AppConstant.mixPanelInstance!
                        .track('Share Listing as Link');
                    await Share.share(
                        'https://dazle-links.web.app/web_listing_details?listingId=${this.selectedListing!.id}',
                        subject: 'TestShare');
                    Navigator.pop(getContext());
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    listingDetailsPresenter
        .dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}

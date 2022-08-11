import 'package:dazle/app/pages/download_list/download_list_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class DownloadListController extends Controller {
  final DownloadListPresenter downloadListPresenter;

  Mixpanel? _mixpanel;
  Mixpanel? get mixpanel => _mixpanel;

  double progressValue = .25;
  bool showProgressBar = false;

  DownloadListController(userRepo)
      : downloadListPresenter = DownloadListPresenter(),
        super();

  @override
  void initListeners() {
    initMixpanel();
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

  Future<void> initMixpanel() async {
    _mixpanel = await AppConstant.mixPanelInit();
  }
}

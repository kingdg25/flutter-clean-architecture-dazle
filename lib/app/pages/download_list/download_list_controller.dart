import 'package:dazle/app/pages/download_list/download_list_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DownloadListController extends Controller {
  final DownloadListPresenter downloadListPresenter;

  double progressValue = .25;
  bool showProgressBar = false;

  DownloadListController(userRepo)
      : downloadListPresenter = DownloadListPresenter(),
        super();

  @override
  void initListeners() {}

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
}

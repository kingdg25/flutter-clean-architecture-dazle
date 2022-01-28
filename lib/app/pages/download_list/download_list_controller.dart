import 'package:dazle/app/pages/download_list/download_list_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class DownloadListController extends Controller {
  final DownloadListPresenter downloadListPresenter;

  DownloadListController(userRepo)
      : downloadListPresenter = DownloadListPresenter(),
        super();

  @override
  void initListeners() {}
}

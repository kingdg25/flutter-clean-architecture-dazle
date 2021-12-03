import 'package:dazle/app/pages/my_connection/my_connection_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/my_connection_tile.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class MyConnectionController extends Controller {
  final MyConnectionPresenter myConnectionPresenter;

  List<MyConnectionTile> _myConnection;
  List<MyConnectionTile> get myConnection => _myConnection;

  List<String> popupMenuList;

  MyConnectionController(userRepo)
    : myConnectionPresenter = MyConnectionPresenter(userRepo),
      _myConnection = <MyConnectionTile>[],
      popupMenuList = ['Remove'],
      super();


  @override
  void initListeners() {
    // read my connection
    getMyConnection();

    myConnectionPresenter.readMyConnectionOnNext = (List<MyConnectionTile> res) {
      print('read my connection on next $res');
      if (res != null){
        _myConnection = res;
      }
    };

    myConnectionPresenter.readMyConnectionOnComplete = () {
      print('read my connection on complete');
      AppConstant.showLoader(getContext(), false);
      refreshUI();
    };

    myConnectionPresenter.readMyConnectionOnError = (e) {
      print('read my connection on error $e');
      AppConstant.showLoader(getContext(), false);
    };


    // remove my connection
    myConnectionPresenter.removeConnectionOnNext = (res) {
      print('remove my connection on next $res');
    };

    myConnectionPresenter.removeConnectionOnComplete = () {
      print('remove my connection on complete');
      AppConstant.showLoader(getContext(), false);
      refreshUI();
    };

    myConnectionPresenter.removeConnectionOnError = (e) {
      print('remove my connection on error $e');
      AppConstant.showLoader(getContext(), false);
    };
  }


  void getMyConnection() {
    myConnectionPresenter.readMyConnection();
  }

  void removeConnection(MyConnectionTile res) {
    myConnectionPresenter.removeConnection(invitedId: res.id);
  }



  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    myConnectionPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}
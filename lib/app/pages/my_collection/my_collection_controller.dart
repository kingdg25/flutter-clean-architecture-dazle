import 'package:dazle/app/pages/my_collection/my_collection_presenter.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MyCollectionController extends Controller {
  final MyCollectionPresenter myCollectionPresenter;

  List<Property> _myCollection;
  List<Property> get myCollection => _myCollection;

  MyCollectionController(userRepo)
      : myCollectionPresenter = MyCollectionPresenter(userRepo),
        _myCollection = <Property>[],
        super();

  @override
  void initListeners() {
    getData();

    // get my collection
    myCollectionPresenter.getMyCollectionOnNext = (List<Property> res) {
      print('get my collection on next $res');
      // if (res != null){
      _myCollection = res;
      // }
    };

    myCollectionPresenter.getMyCollectionOnComplete = () {
      print('get my collection on complete');
      refreshUI();
    };

    myCollectionPresenter.getMyCollectionOnError = (e) {
      print('get my collection on error $e');
    };
  }

  void getData() {
    myCollectionPresenter.getMyCollection();
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    myCollectionPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}

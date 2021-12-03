import 'package:dazle/app/pages/my_connection/my_connection_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/my_connection_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class MyConnectionController extends Controller {
  final MyConnectionPresenter myConnectionPresenter;

  List<MyConnectionTile> _myConnection;
  List<MyConnectionTile> get myConnection => _myConnection;

  List<String> popupMenuList;

  final TextEditingController searchTextController;
  List<String> suggestionsCallback;

  MyConnectionController(userRepo)
    : myConnectionPresenter = MyConnectionPresenter(userRepo),
      _myConnection = <MyConnectionTile>[],
      popupMenuList = ['Remove'],
      searchTextController = TextEditingController(),
      suggestionsCallback = <String>[],
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


    // search invite
    myConnectionPresenter.searchUserOnNext = (res) {
      print('search invite on next $res');
      suggestionsCallback = res;
      // refreshUI();
    };

    myConnectionPresenter.searchUserOnComplete = () {
      print('search invite on complete');
      refreshUI();
    };

    myConnectionPresenter.searchUserOnError = (e) {
      print('search invite on error $e');
    };
  }


  void getMyConnection() {
    myConnectionPresenter.readMyConnection();
  }

  void removeConnection(MyConnectionTile res) {
    myConnectionPresenter.removeConnection(invitedId: res.id);
  }

  void searchUser(){
    String text = searchTextController.text;
    
    ( text == "" ) ? myConnectionPresenter.searchUser(pattern: "") : myConnectionPresenter.searchUser(pattern: searchTextController.text);
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
    searchTextController.dispose();
    super.onDisposed();
  }
  
}
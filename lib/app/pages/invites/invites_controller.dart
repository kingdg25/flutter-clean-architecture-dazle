import 'package:dazle/app/pages/invites/invites_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/invite_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class InvitesController extends Controller {
  final InvitesPresenter invitesPresenter;

  List<InviteTile> _invites;
  List<InviteTile> get invites => _invites;
  var isLoading = true;
  var error = false;

  final TextEditingController searchTextController;
  List<String> suggestionsCallback;

  InvitesController(userRepo)
      : invitesPresenter = InvitesPresenter(userRepo),
        _invites = <InviteTile>[],
        searchTextController = TextEditingController(),
        suggestionsCallback = <String>[],
        super();

  @override
  void initListeners() {
    // read invites
    getInvites();

    invitesPresenter.readInvitesOnNext = (List<InviteTile> res) {
      print('read invites on next $res');
      _invites = res;
    };

    invitesPresenter.readInvitesOnComplete = () {
      print('read invites on complete');
      refreshUI();
      isLoading = false;
    };

    invitesPresenter.readInvitesOnError = (e) {
      isLoading = false;
      error = true;
      print('read invites on error $e');
      refreshUI();
    };

    // add connection
    invitesPresenter.addConnectionOnNext = (res) {
      print('add connection on next $res');
    };

    invitesPresenter.addConnectionOnComplete = () {
      print('add connection on complete');
      AppConstant.statusDialog(
        context: getContext(),
        text: "Successfully Invited",
        title: "",
      );
      refreshUI();
    };

    invitesPresenter.addConnectionOnError = (e) {
      print('add connection on error $e');
      AppConstant.showLoader(getContext(), false);
    };

    // search invite
    invitesPresenter.searchUserOnNext = (res) {
      print('search invite on next $res');
      suggestionsCallback = res;
      refreshUI();
    };

    invitesPresenter.searchUserOnComplete = () {
      print('search invite on complete');

      refreshUI();
    };

    invitesPresenter.searchUserOnError = (e) {
      print('search invite on error $e');
    };
  }

  void getInvites({String? filterByName}) {
    invitesPresenter.readInvites(filterByName: filterByName);
  }

  void addConnection(InviteTile res) {
    print(res.displayName);
    invitesPresenter.addConnection(invitedId: res.id);
  }

  void refreshUi() {
    error = false;
    isLoading = true;
    refreshUI();
    initListeners();
  }

  void searchUser() {
    String text = searchTextController.text;
    print('searchTextController $text');

    if (text == "" || text.isEmpty) {
      getInvites();
    } else {
      invitesPresenter.searchUser(pattern: searchTextController.text);
    }
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    invitesPresenter.dispose(); // don't forget to dispose of the presenter
    searchTextController.dispose();
    super.onDisposed();
  }
}

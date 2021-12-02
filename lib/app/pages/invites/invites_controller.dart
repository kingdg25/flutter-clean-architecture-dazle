import 'package:dazle/app/pages/invites/invites_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/invite_tile.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class InvitesController extends Controller {
  final InvitesPresenter invitesPresenter;

  List<InviteTile> _invites;
  List<InviteTile> get invites => _invites;

  InvitesController(userRepo)
    : invitesPresenter = InvitesPresenter(userRepo),
      _invites = <InviteTile>[],
      super();


  @override
  void initListeners() {
    // read invites
    getInvites();

    invitesPresenter.readInvitesOnNext = (List<InviteTile> res) {
      print('read invites on next $res');
      if (res != null){
        _invites = res;
      }
    };

    invitesPresenter.readInvitesOnComplete = () {
      print('read invites on complete');
      AppConstant.showLoader(getContext(), false);
      refreshUI();
    };

    invitesPresenter.readInvitesOnError = (e) {
      print('read invites on error $e');
      AppConstant.showLoader(getContext(), false);
    };


    // add connection
    invitesPresenter.addConnectionOnNext = (res) {
      print('add connection on next $res');
    };

    invitesPresenter.addConnectionOnComplete = () {
      print('add connection on complete');
      AppConstant.showLoader(getContext(), false);
      refreshUI();
    };

    invitesPresenter.addConnectionOnError = (e) {
      print('add connection on error $e');
      AppConstant.showLoader(getContext(), false);
    };
  }

  void getInvites() {
    invitesPresenter.readInvites();
  }

  void addConnection(InviteTile res){
    print(res.displayName);
    invitesPresenter.addConnection(invitedId: res.id);
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
    super.onDisposed();
  }
  
}
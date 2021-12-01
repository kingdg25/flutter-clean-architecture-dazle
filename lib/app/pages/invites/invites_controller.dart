import 'package:dazle/app/pages/invites/invites_presenter.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class InvitesController extends Controller {
  final InvitesPresenter invitesPresenter;

  InvitesController(userRepo)
    : invitesPresenter = InvitesPresenter(),
      super();


  @override
  void initListeners() {

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
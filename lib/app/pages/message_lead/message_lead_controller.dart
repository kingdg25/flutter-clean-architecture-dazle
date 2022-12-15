import 'package:dazle/app/pages/message_lead/message_lead_presenter.dart';
import 'package:dazle/domain/entities/message.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MessageLeadController extends Controller {
  final MessageLeadPresenter messageLeadPresenter;

  List<Message> _messageLeads;
  List<Message> get messageLeads => _messageLeads;

  MessageLeadController(userRepo)
      : messageLeadPresenter = MessageLeadPresenter(userRepo),
        _messageLeads = <Message>[],
        super();

  @override
  void initListeners() {
    messageLeadPresenter.getMessageLeads();
    // get message leads
    messageLeadPresenter.getMessageLeadsOnNext = (List<Message> res) {
      print('get message leads on next $res');
      // if(res != null) {
      _messageLeads = res;
      // }
      refreshUI();
    };

    messageLeadPresenter.getMessageLeadsOnComplete = () {
      print('get message leads on complete');
    };

    messageLeadPresenter.getMessageLeadsOnError = (e) {
      print('get message leads on error $e');
    };
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    messageLeadPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}

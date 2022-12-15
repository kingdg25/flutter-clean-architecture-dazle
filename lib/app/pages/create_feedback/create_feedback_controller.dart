import 'package:dazle/app/pages/create_feedback/create_feedback_presenter.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/domain/entities/user.dart';
import 'package:flutter/material.dart';
// import 'package:dazle/app/pages/profile/profile_view.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class CreateFeedbackController extends Controller {
  final CreateFeedbackPresenter createFeedbackPresenter;

  UserFeedback? userFeedback;

  CreateFeedbackController(userRepo)
      : createFeedbackPresenter = CreateFeedbackPresenter(userRepo),
        super();

  @override
  void initListeners() {
    // Create Feedback
    createFeedbackPresenter.createFeedbackOnNext = (feedback) async {
      print('Create Feedback on next: $feedback');
      AppConstant.showLoader(getContext(), false);
      await _statusDialog('Done!', 'Your Feedback was successfully submitted.');

      Navigator.pop(getContext());

      //Todo: Add condition if feedback is != null
    };

    createFeedbackPresenter.createFeedbackOnComplete = () async {
      print('Create Feedback on complete.');
      AppConstant.showLoader(getContext(), false);
    };

    createFeedbackPresenter.createFeedbackOnError = (e) {
      print('Create Feedback on error: $e');
      AppConstant.showLoader(getContext(), false);
      if (!e['error']) {
        _statusDialog('Oops!', '${e['status'] ?? ''}');
      } else {
        _statusDialog('Something went wrong', '${e.toString()}');
      }
    };
  }

  void createFeedback() async {
    AppConstant.showLoader(getContext(), true);
    createFeedbackPresenter.createFeedback(feedback: userFeedback);
  }

  Future _statusDialog(String title, String text,
      {bool? success, Function? onPressed}) async {
    return await AppConstant.statusDialog(
        context: getContext(),
        success: success ?? false,
        title: title,
        text: text,
        onPressed: onPressed);
  }

  @override
  void onResumed() => print('On resumed');

  @override
  void onReassembled() => print('View is about to be reassembled');

  @override
  void onDeactivated() => print('View is about to be deactivated');

  @override
  void onDisposed() {
    createFeedbackPresenter
        .dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
}

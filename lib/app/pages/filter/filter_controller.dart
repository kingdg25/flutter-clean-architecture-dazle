import 'package:dazle/app/pages/filter/filter_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';


class FilterController extends Controller {
  final FilterPresenter filterPresenter;

  RangeValues rangeSLiderValue;

  set setRangeSLiderValue (RangeValues value) => rangeSLiderValue = value;

  FilterController(userRepo)
    : filterPresenter = FilterPresenter(),
      rangeSLiderValue = RangeValues(0.2, 0.8),
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
    filterPresenter.dispose(); // don't forget to dispose of the presenter
    super.onDisposed();
  }
  
}
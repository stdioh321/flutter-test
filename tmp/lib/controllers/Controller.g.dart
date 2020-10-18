// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Controller on ControllerBase, Store {
  final _$numClicksAtom = Atom(name: 'ControllerBase.numClicks');

  @override
  int get numClicks {
    _$numClicksAtom.context.enforceReadPolicy(_$numClicksAtom);
    _$numClicksAtom.reportObserved();
    return super.numClicks;
  }

  @override
  set numClicks(int value) {
    _$numClicksAtom.context.conditionallyRunInAction(() {
      super.numClicks = value;
      _$numClicksAtom.reportChanged();
    }, _$numClicksAtom, name: '${_$numClicksAtom.name}_set');
  }

  final _$ControllerBaseActionController =
      ActionController(name: 'ControllerBase');

  @override
  dynamic addClick() {
    final _$actionInfo = _$ControllerBaseActionController.startAction();
    try {
      return super.addClick();
    } finally {
      _$ControllerBaseActionController.endAction(_$actionInfo);
    }
  }
}

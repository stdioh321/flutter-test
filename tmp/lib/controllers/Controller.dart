// import 'package:mobx/mobx.dart';

// class Controller {
//   var numClicks = Observable(10);
//   Action addClick;
//   _addClick() {
//     print("CALLED: _addClick()");
//     numClicks.value++;
//   }

//   Controller() {
//     addClick = Action(_addClick);
//   }
// }

import 'package:mobx/mobx.dart';
part "Controller.g.dart";

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store {
  @observable
  int numClicks = 0;

  @action
  addClick() {
    numClicks++;
  }
}

import 'package:mobx/mobx.dart';

class Counter with Store {
  @observable
  int value = 0;

  @action
  increment() {
    value++;
  }
}

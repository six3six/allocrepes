import 'dart:async';

abstract class SettingRepository {

  Stream<bool> showOrderPages();

  Future<void> changeOrderPagesView(bool shown);

  Stream<bool> showProgramPages();

  Future<void> changeProgramPagesView(bool shown);

  Stream<bool> showCls();

  Future<void> changeClsView(bool shown);

  Stream<String> headline();

  Future<void> changeHeadline(String headline);

  Stream<String> headlineURL();

  Future<void> changeHeadlineURL(String url);
}

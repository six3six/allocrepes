import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:setting_repository/setting_repository.dart';

class SettingRepositoryFirestore extends SettingRepository {
  static final ruleRoot = FirebaseFirestore.instance.collection('rules');

  @override
  Stream<bool> showOrderPages() {
    final showOrder = ruleRoot.doc('show_order');
    return showOrder.snapshots().map((snap) => snap.data()?['enable'] ?? false);
  }

  @override
  Future<void> changeOrderPagesView(bool shown) {
    return ruleRoot.doc('show_order').update({
      'enable': shown,
    });
  }

  @override
  Stream<bool> showProgramPages() {
    return ruleRoot.doc('show_program').snapshots().map(
          (snap) => snap.data()?['enable'] ?? false,
        );
  }

  @override
  Future<void> changeProgramPagesView(bool shown) {
    return ruleRoot.doc('show_program').update({
      'enable': shown,
    });
  }

  @override
  Stream<bool> showCls() {
    return ruleRoot.doc('show_cls').snapshots().map(
          (snap) => snap.data()?['enable'] ?? false,
        );
  }

  @override
  Future<void> changeClsView(bool shown) {
    return ruleRoot.doc('show_cls').update({
      'enable': shown,
    });
  }

  final String headlineRule = 'headline';

  @override
  Stream<String> headline() {
    return ruleRoot.doc(headlineRule).snapshots().map(
          (snap) => snap.data()?['headline'] ?? '',
        );
  }

  @override
  Future<void> changeHeadline(String headline) {
    return ruleRoot.doc(headlineRule).update({
      'headline': headline,
    });
  }

  @override
  Stream<String> headlineURL() {
    return ruleRoot.doc(headlineRule).snapshots().map(
          (snap) => snap.data()?['url'] ?? '',
        );
  }

  @override
  Future<void> changeHeadlineURL(String url) {
    return ruleRoot.doc(headlineRule).update({
      'url': url,
    });
  }
}

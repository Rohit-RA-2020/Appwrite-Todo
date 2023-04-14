import 'package:flutter/material.dart';

SnackBar myOwnSnackBar(String? content) {
  return SnackBar(content: Text(content ?? 'An Error occured'));
}

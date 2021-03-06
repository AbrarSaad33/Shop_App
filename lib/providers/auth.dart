import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token='';
  DateTime? _expiryDate;
  String _userId ='';
  Timer? _authTimer;

  bool get isAuth {
    return _token != '';
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != '') {
      return _token ;
    }
    return '';
  }

  String get userId {
    return _userId.toString();
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyA7fFelZjWfWni54MAdv167mt9G6NaFQg8');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _authLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryData': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> singup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> singin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _expiryDate = null;
    _userId = '';
    _token = '';
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print('expiredate is $_expiryDate ,userId is $_userId,token is $_token');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData') ?? "") as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryData']);
    // if it is after is valid, if it is not the token is invalid.
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _authLogout();
    return true;
  }

  void _authLogout() {
    // if already another timer exist
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeExpiry), logout);
  }
}

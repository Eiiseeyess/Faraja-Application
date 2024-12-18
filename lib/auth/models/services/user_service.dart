import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_frontend/network_helper/network_helper.dart';
import 'package:hackathon_frontend/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../../../local_storage/local_storage.dart';
import '../core/user.dart';

class UserService extends NetworkHelper {
  Future<Either<String, dynamic>> register(
      String userName,
      String firstName,
      String lastName,
      String gender,
      String email,
      String phoneNumber,
      String password,
      String dateOfBirth) async {
    try {
      var response = await http.post(
        Uri.parse("${Constants.BASE_URL}/accounts/register/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': userName,
          'first_name': firstName,
          'last_name': lastName,
          'gender': gender,
          'email': email,
          'phone': phoneNumber,
          'password': password,
          'date_of_birth': dateOfBirth
        }),
      );

      if (response.statusCode == 201) {
        var jsonData = jsonDecode(response.body);
        debugPrint("Register Response JSON: $jsonData");
        debugPrint("Access Token: ${jsonData['access']}");
        debugPrint("Refresh Token: ${jsonData['refresh']}");

        // Save the tokens in local storage
        if (jsonData['access'] != null && jsonData['refresh'] != null) {
          // Storing the tokens as TokenPair
          TokenPair tokenPair = TokenPair(
            access: jsonData['access'],
            refresh: jsonData['refresh'],
          );
          await LocalStorage.saveToken(tokenPair);

          // Returning the User object
          if (jsonData.containsKey('user')) {
            User user = User.fromJson(jsonData['user']);
            return Right(user);
          } else {
            debugPrint('User object missing in the response');
            return const Left('User object missing in the response');
          }
        } else {
          debugPrint('Missing access or refresh token in the response');
          return const Left('Missing access or refresh token in the response');
        }
      } else {
        debugPrint("Error: ${response.body}");
        return Left(
            'Failed to register user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error registering user: $e');
      return Left('Error registering user: $e');
    }
  }

  Future<Either<String, User>> loginUser(
      String userName, String password) async {
    try {
      var response = await http.post(
        Uri.parse("${Constants.BASE_URL}/accounts/login/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': userName,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        debugPrint("Login Response JSON: $jsonData");

        debugPrint("Access Token: ${jsonData['access']}");
        debugPrint("Refresh Token: ${jsonData['refresh']}");

        // Save the tokens in local storage
        if (jsonData['access'] != null && jsonData['refresh'] != null) {
          // Storing the tokens as TokenPair
          TokenPair tokenPair = TokenPair(
            access: jsonData['access'],
            refresh: jsonData['refresh'],
          );
          await LocalStorage.saveToken(tokenPair);

          // Returning the User object
          return Right(User.fromJson(jsonData));
        } else {
          debugPrint('Missing access or refresh token in the response');
          return const Left('Missing access or refresh token in the response');
        }
      } else {
        debugPrint("Error: ${response.body}");
        return Left('Failed to log in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error logging in: $e");
      return Left('Error logging in: $e');
    }
  }

  Future<Either<String, User>> getUserDetails() async {
    try {
      // Retrieve the access token from local storage
      TokenPair? tokenPair = await LocalStorage.getToken();
      if (tokenPair == null) {
        return const Left('No tokens found, user might not be logged in');
      }

      var response = await http.get(
        Uri.parse("${Constants.BASE_URL}/accounts/user/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${tokenPair.access}",
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        // Convert the JSON response to a User object
        User user = User.fromJson(jsonData);
        return Right(user);
      } else {
        // Handle errors
        debugPrint("Error fetching user details: ${response.body}");
        return Left(
            'Failed to fetch user details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      return Left('Error fetching user details: $e');
    }
  }

  Future<Either<String, User>> updateUserPartially(
      int userId, Map<String, dynamic> updatedFields) async {
    try {
      // Retrieve the access token
      TokenPair? tokenPair = await LocalStorage.getToken();
      if (tokenPair == null) {
        return const Left('No tokens found, user might not be logged in');
      }

      var response = await http.patch(
        Uri.parse("${Constants.BASE_URL}/accounts/$userId/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${tokenPair.access}",
        },
        body: jsonEncode(updatedFields), // Send only the updated fields
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        User updatedUser = User.fromJson(jsonData);
        return Right(updatedUser);
      } else {
        debugPrint("Error updating user details: ${response.body}");
        return Left(
            'Failed to update user details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating user details: $e');
      return Left('Error updating user details: $e');
    }
  }

  Future<Either<String, String>> logoutUser() async {
    try {
      // Retrieve the access and refresh tokens from local storage
      TokenPair? tokenPair = await LocalStorage.getToken();
      if (tokenPair == null) {
        return const Left('No tokens found, user might not be logged in');
      }

      var response = await http.post(
        Uri.parse("${Constants.BASE_URL}/accounts/logout/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${tokenPair.access}",
        },
        body: jsonEncode({'refresh': tokenPair.refresh}),
      );

      if (response.statusCode == 200) {
        debugPrint("Logout successful");

        // Remove tokens from local storage
        await LocalStorage.deleteToken();

        return const Right('Logout successful');
      } else {
        debugPrint("Error: ${response.body}");
        return Left('Failed to logout. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error logging out: $e');
      return Left('Error logging out: $e');
    }
  }

  Future<Either<String, String>> deleteAccount() async {
    try {
      // Retrieve the access token from local storage
      TokenPair? tokenPair = await LocalStorage.getToken();
      if (tokenPair == null) {
        return const Left('No tokens found, user might not be logged in');
      }

      var response = await http.delete(
        Uri.parse("${Constants.BASE_URL}/accounts/delete-account/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${tokenPair.access}",
        },
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        String message = jsonData['detail']; // Extract the success message
        // Optionally clear local storage since the account is deleted
        await LocalStorage.deleteToken();
        return Right(message);
      } else {
        // Handle server errors
        debugPrint("Error deleting account: ${response.body}");
        return Left(
            'Failed to delete account. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle unexpected errors
      debugPrint('Error deleting account: $e');
      return Left('Error deleting account: $e');
    }
  }
}

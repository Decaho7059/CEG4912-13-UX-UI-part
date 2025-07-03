import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class MongoDatabase {
  static Db? _mainDb;
  static DbCollection? _mainCollection;
  static Db? _additionalInfoDb;
  static DbCollection? _additionalInfoCollection;

  // Connect to the main database
  static Future<void> connectMainDB() async {
    if (_mainDb != null && _mainDb!.isConnected) {
      print("Main database is already connected.");
      return;
    }
    try {
      print("Attempting to connect to the main database...");
      _mainDb = await Db.create(mongoUrl);
      await _mainDb!.open();
      _mainCollection = _mainDb!.collection(collectionName);
      print("Successfully connected to the main database.");
    } catch (e) {
      print("Failed to connect to MongoDB (main database): $e");
      rethrow;
    }
  }

  // Connect to the additional info database
  static Future<void> connectAdditionalInfoDB() async {
    if (_additionalInfoDb != null && _additionalInfoDb!.isConnected) {
      print("Additional info database is already connected.");
      return;
    }
    try {
      print("Attempting to connect to the additional info database...");
      _additionalInfoDb = await Db.create(additionalMongoUrl);
      await _additionalInfoDb!.open();
      _additionalInfoCollection = _additionalInfoDb!.collection(usercollection);
      print("Successfully connected to the additional info database.");
    } catch (e) {
      print("Failed to connect to MongoDB (additional info): $e");
      rethrow;
    }
  }

  // Check if email exists in main database
  static Future<bool> checkEmailExists(String email) async {
    if (_mainCollection == null) throw Exception("Main database connection not established.");
    try {
      var existingUser = await _mainCollection!.findOne({'email': email});
      return existingUser != null;
    } catch (e) {
      print("Error checking email: $e");
      return false;
    }
  }

  // Insert document into the main database with email uniqueness check
  static Future<void> insertDocument(Map<String, dynamic> data) async {
    if (_mainCollection == null) throw Exception("Main database connection not established.");
    try {
      bool emailExists = await checkEmailExists(data['email']);
      if (emailExists) {
        throw Exception("This email is already in use. Please use another email.");
      }
      var result = await _mainCollection!.insertOne(data);
      if (result.isSuccess) {
        print("Document successfully inserted with ID: ${result.id}");
      } else {
        print("Failed to insert document.");
      }
    } catch (e) {
      print("Error inserting document: $e");
      rethrow;
    }
  }

  // Verify user credentials in main database
  static Future<bool> verifyUser(String email, String password) async {
    if (_mainCollection == null) throw Exception("Main database connection not established.");
    try {
      var user = await _mainCollection!.findOne({'email': email, 'password': password});
      return user != null;
    } catch (e) {
      print("Error verifying user: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    if (_mainCollection == null) await connectMainDB();
    try {
      print("Querying database for user with email: $email");
      final user = await _mainCollection!.findOne({'email': email});
      if (user != null) {
        print("User found: ${user.toString()}");
      } else {
        print("No user found with email: $email");
      }
      return user;
    } catch (e) {
      print("Error retrieving user by email: $e");
      return null;
    }
  }

  // Check if additional info exists for a user in additional info database
  static Future<bool> checkAdditionalInfoExists(String username) async {
    if (_additionalInfoCollection == null) throw Exception("Additional info database connection not established.");
    try {
      var existingInfo = await _additionalInfoCollection!.findOne({'username': username});
      return existingInfo != null;
    } catch (e) {
      print("Error checking additional info: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getAdditionalInfoByUsername(String username) async {
    if (_additionalInfoCollection == null) await connectAdditionalInfoDB();
    try {
      print("Querying additional info for username: $username");
      final info = await _additionalInfoCollection!.findOne({'username': username});
      if (info != null) {
        print("Additional info found: ${info.toString()}");
      } else {
        print("No additional info found for username: $username");
      }
      return info;
    } catch (e) {
      print("Error retrieving additional info: $e");
      return null;
    }
  }

  // Upsert additional info for a user
  static Future<void> upsertAdditionalInfo(Map<String, dynamic> additionalInfo) async {
    if (_additionalInfoCollection == null) await connectAdditionalInfoDB();
    try {
      final existingInfo = await getAdditionalInfoByUsername(additionalInfo['username']);
      if (existingInfo != null) {
        print("Updating existing additional info for username: ${additionalInfo['username']}");
        await _additionalInfoCollection!.updateOne(
          where.eq('username', additionalInfo['username']),
          modify.set('phoneNumber', additionalInfo['phoneNumber'])
              .set('aptNumber', additionalInfo['aptNumber'])
              .set('streetNumber', additionalInfo['streetNumber'])
              .set('cityName', additionalInfo['cityName'])
              .set('country', additionalInfo['country'])
              .set('postalCode', additionalInfo['postalCode'])
              .set('packageType', additionalInfo['packageType']),
        );
        print("Additional info updated successfully.");
      } else {
        print("Inserting new additional info for username: ${additionalInfo['username']}");
        additionalInfo['_id'] = ObjectId(); // Generate new ObjectId if absent
        await _additionalInfoCollection!.insertOne(additionalInfo);
        print("Additional info inserted successfully.");
      }
    } catch (e) {
      print("Error upserting additional info: $e");
      rethrow;
    }
  }

  // Retrieve all users
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    if (_mainCollection == null) throw Exception("Main database connection not established.");
    try {
      final users = await _mainCollection!.find().toList();
      return users.map((user) => user.cast<String, dynamic>()).toList();
    } catch (e) {
      print("Error retrieving users: $e");
      return [];
    }
  }

  // Delete user by ID
  static Future<void> deleteUser(String hexId) async {
    if (_mainCollection == null) throw Exception("Main database connection not established.");
    try {
      await _mainCollection!.remove(where.id(ObjectId.fromHexString(hexId)));
      print("User deleted successfully.");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  // Update user by ID
  static Future<void> updateUser(String id, Map<String, dynamic> updatedData) async {
    if (_mainCollection == null) throw Exception("Main database connection not established.");
    final objectId = ObjectId.fromHexString(id);
    try {
      var modifier = modify;
      updatedData.forEach((key, value) {
        modifier = modifier.set(key, value);
      });
      await _mainCollection?.updateOne(
        where.id(objectId),
        modifier,
      );
      print("User updated successfully.");
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  // Retrieve complete user profile
  static Future<Map<String, dynamic>> getCompleteUserProfile(String email) async {
    final user = await getUserByEmail(email);
    if (user == null) throw Exception("User with email $email not found.");
    final additionalInfo = await getAdditionalInfoByUsername(user['username']);
    return {
      'user': user,
      'additionalInfo': additionalInfo ?? {},
    };
  }

  // Close the database connections
  static Future<void> close() async {
    try {
      if (_mainDb != null && _mainDb!.isConnected) {
        await _mainDb!.close();
        print("Main database connection closed.");
      }
      if (_additionalInfoDb != null && _additionalInfoDb!.isConnected) {
        await _additionalInfoDb!.close();
        print("Additional info database connection closed.");
      }
    } catch (e) {
      print("Error closing MongoDB connections: $e");
    }
  }
}

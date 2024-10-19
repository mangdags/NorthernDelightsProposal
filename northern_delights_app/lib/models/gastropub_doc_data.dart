import 'package:cloud_firestore/cloud_firestore.dart';

class GastropubAllUnsorted {
  Stream<List<Map<String, dynamic>>> getGastropubData() {
    return FirebaseFirestore.instance.collection('gastropubs').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Attach the document ID to the data
          return data;
        }).toList();
      },
    );
  }
}

class GastropubMostViewed {
  Stream<List<Map<String, dynamic>>> getGastropubMostViewed() {
    return FirebaseFirestore.instance
        .collection('gastropubs')
        .orderBy('gastro_view_count', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Attach the document ID to the data
        return data;
      }).toList();
    });
  }
}

class GastropubService {
  Stream<List<Map<String, dynamic>>> getStream(String filter) {
    switch (filter) {
      case 'mostViewed':
        return GastropubMostViewed().getGastropubMostViewed();
      case 'allUnsorted':
      default:
        return GastropubAllUnsorted().getGastropubData();
    }
  }
}
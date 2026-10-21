import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MissaoService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _colecao {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return firestore.collection('usuarios').doc(uid).collection('missoes');
  }

  Future<void> registrarConclusao(String titulo) async {
    await _colecao.add({
      'titulo': titulo,
      'concluidaEm': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listarMissoes() {
    return _colecao.orderBy('concluidaEm', descending: true).snapshots();
  }
}

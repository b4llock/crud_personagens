import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/personagem.dart';

class PersonagemService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _colecao {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return firestore.collection('usuarios').doc(uid).collection('personagens');
  }

  Future<void> criarHeroi(Personagem personagem) async {
    await _colecao.add(personagem.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listarPersonagens() {
    return _colecao.snapshots();
  }

  Future<void> tomarDano(String id, int novaVida) async {
    await _colecao.doc(id).update({'vida': novaVida});
  }

  Future<void> deletarPersonagem(String id) async {
    await _colecao.doc(id).delete();
  }
}

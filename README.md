# The Dev's Quest — atividade Firebase

Projeto Flutter baseado em [crud_personagens](https://github.com/1tassianak/crud_personagens). O login usa Firebase Auth. Personagens e missões concluídas ficam em subcoleções do usuário autenticado no Cloud Firestore:

```text
usuarios/{uid}/personagens/{id}  → nome, vida, forca
usuarios/{uid}/missoes/{id}      → titulo, concluidaEm
```

O documento `usuarios/{uid}` não precisa conter dados para que as subcoleções existam. O perfil nesse documento é um desafio bônus da atividade.

## Configuração necessária na sua conta Firebase

1. Use Flutter 3.44 ou superior e confira com `flutter --version` e `flutter doctor`.
2. Crie um projeto seu no [Firebase Console](https://console.firebase.google.com/). Ative **Authentication → E-mail/senha** e crie um banco **Cloud Firestore**.
3. Instale e autentique o Firebase CLI: `npm install -g firebase-tools` e `firebase login`.
4. Instale o FlutterFire CLI: `dart pub global activate flutterfire_cli`.
5. Na raiz deste projeto, execute `flutter pub get` e `flutterfire configure --project=SEU_ID_DO_PROJETO --platforms=android,web`. O arquivo `lib/firebase_options.dart` é necessário para compilar, mas fica fora da entrega.
6. Cole o conteúdo de `firestore.rules` em **Firestore Database → Regras** e publique. Faça isso antes de testar o app com dados reais.
7. Execute `flutter run -d chrome` ou `flutter run` em um dispositivo Android.

`lib/firebase_options.dart`, `firebase.json`, `.firebaserc` e `android/app/google-services.json` estão no `.gitignore`. Confira `git status` antes de enviar o projeto. O código entregue não contém credenciais nem configuração de um projeto Firebase específico.

## Como conferir os critérios de aceite

1. Cadastre o usuário A, crie um personagem, aplique dano, cure e exclua outro personagem. Confira `usuarios/{uidA}/personagens` no console.
2. Registre uma missão concluída na aba **Missões**. Confira `usuarios/{uidA}/missoes`, com `titulo` e `concluidaEm`.
3. Saia e cadastre o usuário B. As listas de personagens e missões devem começar vazias. Crie dados de B e confirme que A não os vê ao entrar novamente.
4. No Google Cloud Console, abra **Firestore → (default) → Segurança → Simulador**. Simule a leitura de `usuarios/{uidA}/personagens/{id}` com o UID de A: deve ser permitida. Repita com o UID de B e sem autenticação: ambas devem ser negadas. Faça capturas dos três resultados.
5. Se a coleção antiga `personagens` existir na raiz, confira que seus dados já não são necessários antes de apagá-la no console. A mudança de caminho no código não migra documentos antigos automaticamente.

O enunciado pede respostas para perguntas de reflexão, mas não traz as perguntas no arquivo fornecido. Elas precisam ser obtidas no material complementar da disciplina.

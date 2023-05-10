import 'package:docs_clone_flutter/colors.dart';
import 'package:docs_clone_flutter/common/widgets/loader.dart';
import 'package:docs_clone_flutter/models/document.model.dart';
import 'package:docs_clone_flutter/models/error.model.dart';
import 'package:docs_clone_flutter/repository/auth.repository.dart';
import 'package:docs_clone_flutter/repository/document.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(BuildContext context, WidgetRef ref) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackbar.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  void navigateToDocument(BuildContext context, String documentId) async {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                createDocument(context, ref);
              },
              icon: const Icon(Icons.add, color: kBlackColor)),
          IconButton(
              onPressed: () {
                signOut(ref);
              },
              icon: const Icon(Icons.logout, color: kRedColor)),
        ],
      ),
      body: FutureBuilder<ErrorModel>(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return Center(
            child: Container(
              width: 400,
              margin: const EdgeInsets.only(top: 30),
              child: ListView.builder(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: (context, index) {
                    DocumentModel document = snapshot.data!.data[index];
                    return InkWell(
                      onTap: () => navigateToDocument(context, document.id),
                      child: SizedBox(
                        height: 50,
                        child: Card(
                          child: Center(
                              child: Text(
                            document.title,
                            style: const TextStyle(fontSize: 17),
                          )),
                        ),
                      ),
                    );
                  }),
            ),
          );
        },
        future: ref
            .watch(documentRepositoryProvider)
            .getDocuments(ref.watch(userProvider)!.token),
      ),
    );
  }
}


/**
 * he following TypeErrorImpl was thrown building
HomeScreen(dirty, dependencies:
[UncontrolledProviderScope], state: _ConsumerState#6f497):  
Unexpected null value.

The relevant error-causing widget was:
  HomeScreen
  HomeScreen:file:///C:/Users/Bruno/dev/docs_clone_flutter/l  ib/router/router.dart:11:45
 */
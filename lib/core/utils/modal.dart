import 'package:client/core/providers/user.dart';
import 'package:client/router/router.dart';
import 'package:client/styles/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Modal {
  static final Modal _instance = Modal._internal();
    Modal._internal();

  factory Modal() => _instance;
  
  static Future<dynamic> promptLogin(
    BuildContext context, String msgValue,
    String positiveBtn, String negativeBtn
  ) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: 
          Text(
            msgValue,
            style: 
              const TextStyle(
                color: Colors.black,
                fontSize: 16.0
              ),
          ),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              positiveBtn,
              style: const TextStyle(color: AppColors.primary)
            ),
            onPressed: ()
              => Provider.of<UserProvider>(
                  context, 
                  listen: false
                ).signOut(context)
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(negativeBtn),
          onPressed: () async => GlobalNavigator.goBack(),
        ),
      ),
    );
  }
  
  static Future<dynamic> promptUserVerify(
    BuildContext context, String msgValue,
    String positiveBtn, String negativeBtn,
    String userId
  ) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: 
          Text(
            msgValue,
            style: 
              const TextStyle(
                color: Colors.black,
                fontSize: 16.0
              ),
          ),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              positiveBtn,
              style: const TextStyle(color: AppColors.primary)
            ),
            onPressed: () {
              // AppData().updateUserDetails(
              //   userId: userId,
              // ).then(
                // (_) => instance
                //   .createClient(
                //     client: instance.clientRequest[i].client,
                //   )
                //   .then((value) => FirebaseFirestore.instance
                //       .collection("clientRequests")
                //       .doc(instance.clientRequest[i].userId)
                //       .delete()),
              // );
            }
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(negativeBtn),
          onPressed: () async => GlobalNavigator.goBack(),
        ),
      ),
    );
  }
  
  static Future<dynamic> modalInfo(
    BuildContext context, String msgValue, String msgBtn) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: 
          Text(
            msgValue,
            style: 
              const TextStyle(
                color: Colors.black,
                fontSize: 16.0
              ),
          ),
        cancelButton: CupertinoActionSheetAction(
          child: Text(msgBtn),
          onPressed: () => GlobalNavigator.pop(context),
        ),
      ),
    );
  }

  static modalLoader(
    BuildContext context, String title, String subject) async {
    return showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(subject),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: 
                const SizedBox(
                  // child: CupertinoActivityIndicator(color: Colors.white),
                  height: 50,
                  width: 50,
                ),
              onPressed: () => GlobalNavigator.pop(context),
            ),
          ],
        );
      },
    );
  }

}
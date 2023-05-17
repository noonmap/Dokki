import 'package:dokki/common/constant/colors.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final int commentId;
  final String question;
  final String bookId;
  final Function onPressedFunction;
  const CustomAlertDialog(
      {Key? key,
      required this.question,
      required this.commentId,
      required this.bookId,
      required this.onPressedFunction})
      : super(key: key);

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: grayColor000,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.question,
              style: TextStyle(
                color: grayColor600,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onPressedFunction();
                  },
                  child: Text("확인"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.pressed)) {
                          return brandColor300;
                        }
                        return brandColor300;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("취소"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.pressed)) {
                          return brandColor300;
                        }
                        return brandColor300;
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

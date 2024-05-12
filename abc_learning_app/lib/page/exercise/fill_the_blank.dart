import 'package:abc_learning_app/constant/color_palette.dart';
import 'package:abc_learning_app/constant/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class FillInTheBlanks extends StatefulWidget {
  final String sentence;
  final TextEditingController controller;
  final bool checkAnswer;

  FillInTheBlanks(
      {required this.sentence,
      required this.controller,
      required this.checkAnswer});

  @override
  _FillInTheBlanksState createState() => _FillInTheBlanksState();
}

class _FillInTheBlanksState extends State<FillInTheBlanks> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    widget.sentence.split('...').asMap().forEach((index, part) {
      children.add(
        Column(
          children: [
            const Gap(5),
            Text(
              part,
              style: TextStyles.exerciseContent,
            ),
          ],
        ),
      );

      if (index != widget.sentence.split('...').length - 1) {
        children.add(
          SizedBox(
            width: 70,
            height: 42,
            child: TextFormField(
              readOnly: widget.checkAnswer,
              maxLines: 1,
              style: TextStyles.exerciseContent,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 5, top: 0),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorPalette.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    });

    return Wrap(
      children: children,
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

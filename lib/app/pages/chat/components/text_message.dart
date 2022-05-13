import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/chat.dart';
import '../../../widgets/custom_text.dart';

class TextMessage extends StatelessWidget {
  final Chat? message;
  const TextMessage({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: message!.isSentByMe ? Color.fromARGB(255, 214, 245, 234) : null,
      // elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          width: 220,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: message!.text,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(message!.date),
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

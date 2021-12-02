import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../model/chat/attachment_model.dart';
import '../../../../../model/chat/message_model.dart';
import 'docfile_preview_widget.dart';
import 'file_widget.dart';
import 'message_widgets.dart';

class ReceipientMessage extends StatelessWidget {
  final MessageModel message;
  final bool hideNip;
  const ReceipientMessage(
      {Key? key, required this.message, required this.hideNip})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1.sw * 0.72),
        child: Bubble(
          elevation: 0.0,
          margin: BubbleEdges.only(left: hideNip ? 8.0 : 0.0),
          padding: const BubbleEdges.all(3.0),
          stick: true,
          nip: hideNip ? null : BubbleNip.leftTop,
          color: Theme.of(context).colorScheme.secondary,
          child: _MessageBody(message: message),
        ),
      ),
    );
  }
}

class _MessageBody extends StatelessWidget {
  final MessageModel message;
  const _MessageBody({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if text is empty, that means there is an attachment
    if (message.text.isEmpty && message.attachments!.first is ImageAttachment) {
      // show image attachments with time shown on top of it
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          ImageView(attachments: message.attachments!),
          TrailingText(
            key: ValueKey("${message.messageId}${message.receipt}"),
            time: message.time,
            receipt: message.receipt,
            color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
          )
        ],
      );
    } else {
      bool hasAttachments = message.attachments != null;
      return Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          if (hasAttachments)
            // show attachments
            if (message.attachments!.first is DocumentAttachment)
              DocFilePreviewWidget(
                key: ObjectKey(message.attachments),
                message: message,
                color: Theme.of(context).colorScheme.primaryVariant,
                trailingColor: Theme.of(context)
                    .colorScheme
                    .primaryVariant
                    .withOpacity(0.6),
                attachment: message.attachments!.first as DocumentAttachment,
              )
            else if (message.attachments!.first is VoiceAttachment)
              Offstage()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageView(
                    key: ObjectKey(message.attachments),
                    attachments: message.attachments!,
                  ),
                  TextWidget(
                    key: ValueKey("${message.messageId}${message.text}"),
                    text: message.text,
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                ],
              )
          else
            // show text only
            TextWidget(
              key: ValueKey("${message.messageId}${message.text}"),
              text: message.text,
              color: Theme.of(context).colorScheme.primaryVariant,
            ),
          // Date Widget
          if (message.attachments?.first is! DocumentAttachment)
            TrailingText(
              key: ValueKey("${message.messageId}${message.receipt}"),
              time: message.time,
              color:
                  Theme.of(context).colorScheme.primaryVariant.withOpacity(0.6),
            )
        ],
      );
    }
  }
}

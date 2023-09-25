import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notes_app/cubits/notes_cubit/notes_cubit.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/widgets/custom_app_bar.dart';
import 'package:notes_app/widgets/custom_text_field.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'edit_note_colors_list_view.dart';

class EditNoteViewBody extends StatefulWidget {
  const EditNoteViewBody({super.key, required this.note});

  final NoteModel note;

  @override
  State<EditNoteViewBody> createState() => _EditNoteViewBodyState();
}

class _EditNoteViewBodyState extends State<EditNoteViewBody> {
  String? title, content;

///////////
  ///
  ///
  ///

  final SpeechToText speechToTextInstance = SpeechToText();
  String recordedAudioString = "";
  bool isLoading = false;

  void initializedSpeechToText() async {
    await speechToTextInstance.initialize();
    setState(() {});
  }

  void startListeningNow() async {
    FocusScope.of(context).unfocus();
    await speechToTextInstance.listen(onResult: onSpeechToTextResult);
    setState(() {});
  }

  void stopListeningNow() async {
    await speechToTextInstance.stop();
    setState(() {});
  }

  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) {
    recordedAudioString = recognitionResult.recognizedWords;
    print('Speech Result');
    print(recordedAudioString);
  }

  @override
  void initState() {
    super.initState();
    initializedSpeechToText();
  }

  ///////////////

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(
              onPressed: () {
                widget.note.title = title ?? widget.note.title;
                widget.note.subTitle = content ?? widget.note.subTitle;
                widget.note.save();
                BlocProvider.of<NotesCubit>(context).fetchAllNotes();
                Navigator.pop(context);
              },
              title: 'Edit Note',
              icon: Icons.check,
            ),
            const SizedBox(height: 50),
            CustomTextFiel(
              hint: widget.note.title,
              onChanged: (p0) {
                title = p0;
              },
            ),
            const SizedBox(height: 16),

            CustomTextFiel(
              //hint: widget.note.subTitle,
              hint: recordedAudioString.isEmpty
                  ? widget.note.subTitle
                  : recordedAudioString,
              maxLines: 5,
              onChanged: (p0) {
                //content = p0;
                content =
                    recordedAudioString.isEmpty ? p0 : recordedAudioString;
                // setState(() {});
              },
              // onSaved: (p0) {
              //   content =
              //       recordedAudioString.isEmpty ? p0 : recordedAudioString;
              // },
            ),
            const SizedBox(height: 16),
            ////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                speechToTextInstance.isListening
                    ? FloatingActionButton(
                        backgroundColor: Colors.grey[850],
                        child: Center(
                          child: LoadingAnimationWidget.beat(
                            color: speechToTextInstance.isListening
                                ? Colors.deepPurple
                                : isLoading
                                    ? Colors.deepPurple[400]!
                                    : Colors.deepPurple[200]!,
                            size: 33,
                          ),
                        ),
                        onPressed: () {
                          stopListeningNow();

                          setState(() {
                            content = recordedAudioString.isEmpty
                                ? content
                                : recordedAudioString;
                          });
                        },
                      )
                    : IconButton(
                        onPressed: () {
                          speechToTextInstance.isListening
                              ? stopListeningNow()
                              : startListeningNow();

                          setState(() {});
                        },
                        icon: const Icon(Icons.mic),
                      ),
              ],
            ),
            ////////////////////////////////
            const SizedBox(height: 16),
            EditNoteColorsList(note: widget.note),
          ],
        ),
      ),
    );
  }
}

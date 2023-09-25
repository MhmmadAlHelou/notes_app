import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:notes_app/cubits/add_note_cubit/add_note_cubit.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../models/note_model.dart';
import 'colors_list_view.dart';
import 'custom_botton.dart';
import 'custom_text_field.dart';

import 'package:intl/intl.dart';

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key});

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? title, subTitle;

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
    return Form(
      key: formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          const SizedBox(height: 32),
          CustomTextFiel(
            hint: 'Title',
            onSaved: (p0) {
              title = p0;
            },
          ),
          const SizedBox(height: 16),
          CustomTextFiel(
            hint: recordedAudioString.isEmpty ? 'Content' : recordedAudioString,
            maxLines: 5,
            onSaved: (p0) {
              subTitle = recordedAudioString.isEmpty ? p0 : recordedAudioString;
            },
          ),
          //   Spacer(),
          const SizedBox(height: 28),
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
                      },
                    )
                  : IconButton(
                      onPressed: () {
                        speechToTextInstance.isListening
                            ? stopListeningNow()
                            : startListeningNow();
                      },
                      icon: const Icon(Icons.mic),
                    ),
            ],
          ),

          ////////////////////////////////
          const SizedBox(height: 28),
          const ColorsListView(),
          const SizedBox(height: 28),
          BlocBuilder<AddNoteCubit, AddNoteState>(
            builder: (context, state) {
              return CustomButton(
                title: 'Add',
                isLoading: state is AddNoteLoading ? true : false,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    var noteModel = NoteModel(
                        title: title!,
                        subTitle: subTitle!,
                        date: DateFormat('yyyy-MM-dd')
                            .format(DateTime.now())
                            .toString(),
                        // date: DateTime.now().toString(),
                        color: Colors.blue.value);
                    BlocProvider.of<AddNoteCubit>(context).addNote(noteModel);
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

import 'chord.dart';
import 'note.dart';
import 'timing.dart';

class Measure {
  final Chord? chord;
  final List<Note> notes;
  final bool repeatStart;
  final bool repeatEnd;

  Measure({
    required this.notes,
    this.repeatStart = false,
    this.repeatEnd = false,
    this.chord,
  }) {
    assert(notes.every((note) => note.timing != Timing.unspecified));
  }

  factory Measure.fromNoteList(
    List<Note?> input, {
    bool repeatStart = false,
    bool repeatEnd = false,
    Chord? chord,
  }) {
    final notes = <Note>[];
    for (int i = 0; i < input.length; i++) {
      var note = input[i];
      if (note != null) {
        if (note.timing == Timing.unspecified) {
          notes.add(
            note.copyWithTiming(
              Timing.withinNoteList(listLength: input.length, noteIndex: i),
            ),
          );
        } else {
          notes.add(note);
        }
      }
    }
    return Measure(
      notes: notes,
      repeatStart: repeatStart,
      repeatEnd: repeatEnd,
      chord: chord,
    );
  }
}

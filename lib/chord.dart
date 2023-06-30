enum Chord {
  a,
  am,
  a7,
  am7,
  b,
  bm,
  b7,
  c,
  cm,
  c7,
  d,
  dm,
  d7,
  dm7,
  e,
  em,
  e7,
  emaj7,
  f,
  fm,
  fmaj7,
  fm7,
  g,
  gm,
  g7,
  gsus4
}

extension ChordLabelFn on Chord {
  String id() {
    switch (this) {
      case Chord.a:
        return 'a';
      case Chord.am:
        return 'am';
      case Chord.a7:
        return 'a7';
      case Chord.am7:
        return 'am7';
      case Chord.b:
        return 'b';
      case Chord.bm:
        return 'bm';
      case Chord.b7:
        return 'b7';
      case Chord.c:
        return 'c';
      case Chord.cm:
        return 'cm';
      case Chord.c7:
        return 'c7';
      case Chord.d:
        return 'd';
      case Chord.dm:
        return 'dm';
      case Chord.d7:
        return 'd7';
      case Chord.dm7:
        return 'dm7';
      case Chord.e:
        return 'e';
      case Chord.em:
        return 'em';
      case Chord.e7:
        return 'e7';
      case Chord.emaj7:
        return 'emaj7';
      case Chord.f:
        return 'f';
      case Chord.fm:
        return 'fm';
      case Chord.fmaj7:
        return 'fmaj7';
      case Chord.fm7:
        return 'fm7';
      case Chord.g:
        return 'g';
      case Chord.gm:
        return 'gm';
      case Chord.g7:
        return 'g7';
      case Chord.gsus4:
        return 'gsus4';
    }
  }
}

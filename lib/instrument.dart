enum Instrument {
  banjo,
  guitar,
}

extension StringsFn on Instrument {
  int stringCount() {
    switch (this) {
      case Instrument.banjo:
        return 5;
      case Instrument.guitar:
        return 6;
    }
  }
}

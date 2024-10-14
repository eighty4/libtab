enum Instrument {
  banjo,
  guitar,
}

extension InstrumentLabelFn on Instrument {
  String label() => switch (this) {
        Instrument.banjo => "Banjo",
        Instrument.guitar => "Guitar"
      };
}

extension InstrumentStringCountFn on Instrument {
  int stringCount() =>
      switch (this) { Instrument.banjo => 5, Instrument.guitar => 6 };
}

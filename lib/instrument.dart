enum Instrument {
  banjo,
  guitar,
}

extension StringsFn on Instrument {
  int stringCount() =>
      switch (this) { Instrument.banjo => 5, Instrument.guitar => 6 };
}

#!/bin/sh
set -e

# run through all the checks done for ci

flutter test
flutter analyze
dart format lib test --set-exit-if-changed

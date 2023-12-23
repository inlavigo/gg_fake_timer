
rm -rf coverage
dart run coverage:test_with_coverage
genhtml coverage/lcov.info -o coverage/html

if  !([ -z ${1+x} ])
then
  open coverage/html/src/index.html
fi

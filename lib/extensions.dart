extension ExceptionMessage on Exception {
  getMessage() => toString().substring(11);
}

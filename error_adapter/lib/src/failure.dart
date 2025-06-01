abstract class Failure {
  Failure(this.message);

  final String message;
}

class MessageFailure extends Failure {
  MessageFailure(super.message);
}

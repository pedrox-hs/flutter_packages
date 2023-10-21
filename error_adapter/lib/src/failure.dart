abstract class Failure {
  Failure(this.message);

  final String message;
}

class MessageFailure extends Failure {
  MessageFailure(String message) : super(message);
}

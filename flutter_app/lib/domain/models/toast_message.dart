enum ToastType {
  info,
  success,
  warn,
  error,
  copy,
  paste,
  trash,
}

class ToastMessage {
  const ToastMessage({
    required this.id,
    required this.message,
    this.type = ToastType.info,
  });

  final int id;
  final String message;
  final ToastType type;
}

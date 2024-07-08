enum States { init, loading, success, error }

class StateResource<T> {
  final T? data;
  final String? error;
  final bool isInitState;
  final bool isLoadingState;

  const StateResource._({
    this.data,
    this.error,
    this.isInitState = false,
    this.isLoadingState = false,
  });

  factory StateResource.success(T data) => StateResource<T>._(data: data);

  factory StateResource.error(String error) => StateResource<T>._(error: error);

  factory StateResource.loading({T? data}) =>
      StateResource<T>._(data: data, isLoadingState: true);

  factory StateResource.init() => StateResource<T>._(isInitState: true);

  bool isLoading(){
    return isLoadingState;
  }

  bool isError(){
    return !isLoadingState && !isInitState && error != null;
  }

  bool isSuccess(){
    return !isLoadingState && !isInitState && data != null;
  }

  bool isInit(){
    return isInitState;
  }
}
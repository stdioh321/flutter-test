import 'package:http_interceptor/http_interceptor.dart';

class CustomInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    // print("RequestData");
    // print(data);
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    // print("ResponseData");
    // print(data);
    return data;
  }
}

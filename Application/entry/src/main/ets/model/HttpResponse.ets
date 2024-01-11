import http from '@ohos.net.http';

export class HttpResponse<T = any> {
  result: string | Object | ArrayBuffer | T;
  resultType: http.HttpDataType;
  responseCode: http.ResponseCode | number;
  header: Object;
  cookies: string;
}
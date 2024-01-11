import http from '@ohos.net.http';
const key = '884f8692b4d64c1f90726661239e3aba'

// 实时天气
export function getNowWeather(location: number): Promise<http.HttpResponse> {
  // 每一个httpRequest对应一个HTTP请求任务，不可复用
  let httpRequest = http.createHttp();
  return httpRequest.request(
    // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
    "https://devapi.qweather.com/v7/weather/now?location=" + location + "&key=" + key+'&lang=en',
    {
      method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
      expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
    });
}

// 7日天气
export function get7dWeather(location: number): Promise<http.HttpResponse> {
  // 每一个httpRequest对应一个HTTP请求任务，不可复用
  let httpRequest = http.createHttp();
  return httpRequest.request(
    // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
    "https://devapi.qweather.com/v7/weather/7d?location=" + location + "&key=" + key+'&lang=en',
    {
      method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
      expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
    });
}

// 24小时天气预报
export function get24hWeather(location: number): Promise<http.HttpResponse> {
  // 每一个httpRequest对应一个HTTP请求任务，不可复用
  let httpRequest = http.createHttp();
  return httpRequest.request(
    // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
    "https://devapi.qweather.com/v7/weather/24h?location=" + location + "&key=" + key+'&lang=en',
    {
      method: http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
      expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
    });
}
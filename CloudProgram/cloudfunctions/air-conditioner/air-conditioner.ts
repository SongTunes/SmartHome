// 云函数
// 插入数据
import CloudDBZoneWrapper from "./CloudDBZoneWrapper"
import {SmartAirConditioner} from "./SmartAirConditioner"

let myHandler = async function (event, context, callback, logger) {
  console.log("event")
  logger.info(event);

  var res = new context.HTTPResponse(context.env, {
    "res-type":"context.env",
    "faas-content-type":"json",
  },"application/json", "200");

  var userId;
  var action;
  var deviceName;
  var deviceId;
  var data;

  var queryRes;
  var queryRes1;
  var queryRes2;
  var queryRes3;


  var body = {
    result: ""
  };

  const cloudDBZoneWrapper = new CloudDBZoneWrapper(logger);

  var _body;
  if (event.body) {
    _body = JSON.parse(event.body);
  } else {
    _body = event
  };
  action = _body.action;

  switch (action) {
    case "select":
      //
      userId = _body.userId;
      // console.log("selecting")
      queryRes = await cloudDBZoneWrapper.selectByUserId(userId);
      console.log(queryRes)
      //
      body.result = queryRes;
      res.body = body;
      break;
    case "upsert":
      data = new SmartAirConditioner();
      userId = _body.userId;
      deviceName = _body.deviceName;

      userId ? data.setUserId(userId) : 0;
      deviceName ? data.setDeviceName(deviceName) : 0;

      queryRes = await cloudDBZoneWrapper.upsert(data);  // 把数据写入云数据库
      console.log(queryRes)
      //
      body.result = queryRes;
      res.body = body;
      break;
    case "delete":
      deviceId = _body.deviceId;
      data = new SmartAirConditioner();
      data.setDeviceId(deviceId);

      queryRes = await cloudDBZoneWrapper.delete(data);
    // queryRes = String(queryRes);
      console.log(queryRes)
    //
      body.result = queryRes;
      res.body = body;
      break;
    case "update":
      deviceId = _body.deviceId;
      data = new SmartAirConditioner();
      data.setDeviceId(deviceId);
    // let mainKey = "deviceId";
      let targetKey = "isOn";
      let targetValue = _body.isOn;
    // console.log("before update")
      queryRes1 = await cloudDBZoneWrapper.update(data, targetKey, targetValue);

      targetKey = "mode";
      targetValue = _body.mode;
    // console.log("before update")
      queryRes2 = await cloudDBZoneWrapper.update(data, targetKey, targetValue);

      targetKey = "temperature";
      targetValue = _body.temperature;
    // console.log("before update")
      queryRes3 = await cloudDBZoneWrapper.update(data, targetKey, targetValue);

      queryRes = queryRes1 && queryRes2 && queryRes3

    // queryRes = String(queryRes);
      console.log(queryRes)
    //
      body.result = queryRes;
      res.body = body;
      break;

    default:
      ;
      // console.log("default");
  }



  // function calTemperature (tep) {
  //   var insertTep;
  //   insertTep = tep + 1;
  //
  //   return insertTep;
  // }





  callback(res);
};
export { myHandler };
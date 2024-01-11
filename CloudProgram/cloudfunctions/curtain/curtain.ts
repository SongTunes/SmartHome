// 云函数
// 插入数据
import CloudDBZoneWrapper from "./CloudDBZoneWrapper"
import {SmartCurtain} from "./SmartCurtain"

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
      data = new SmartCurtain();
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
      data = new SmartCurtain();
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
      data = new SmartCurtain();
      data.setDeviceId(deviceId);
    // let mainKey = "deviceId";
      let targetKey = "isOpened";
      let targetValue = _body.isOpened;
    // console.log("before update")
      queryRes = await cloudDBZoneWrapper.update(data, targetKey, targetValue);
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


  callback(res);
};
export { myHandler };
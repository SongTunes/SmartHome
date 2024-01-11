import "@hw-agconnect/function-ohos";
import agconnect from '@hw-agconnect/api-ohos';
import { AirConditionUiModel } from '../../model/AirConditionUiModel';
import { AirConditionModel } from '../../model/AirConditionModel';

export async function delAirCondition(deleteId:string):Promise<string>{
  let return_string = ""
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("air-conditioner-$latest")
  let params = {
    "action":"delete",
    "deviceId": deleteId,
  }
  await functionCallable.call(params).then((ret:any)=>{
    let resStr = JSON.stringify(ret.getValue().result);
    console.info("gwc delete device:"+resStr)
    return_string = resStr
  })
  return return_string
}

export async function addAirCondition(userId:string,deviceName:string):Promise<string>{
  let return_string = ""
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("air-conditioner-$latest")
  let params = {
    "action":"upsert",
    "userId": userId,
    "deviceName": deviceName
  }
  await functionCallable.call(params).then((ret:any)=>{
    let resStr = JSON.stringify(ret.getValue().result);
    return_string = resStr
  })
  return return_string
}


export async function modifyAirCondition(deviceId:string,isOn:boolean,mode:string,temperature:number):Promise<string>{
  let return_string = ""
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("air-conditioner-$latest")
  let params = {
    "action":"update",
    "deviceId":deviceId,
    "isOn":isOn,
    "mode":mode,
    "temperature":temperature
  }
  await functionCallable.call(params).then((ret)=>{
    let resStr = JSON.stringify(ret.getValue().result);
    return_string = resStr
  })
  return return_string

}


export async function getAirCondition(userId:string):Promise<AirConditionUiModel>{
  let out = new AirConditionUiModel()
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("air-conditioner-$latest")
  let params = {"action":"select","userId":userId}
  await functionCallable.call(params).then((ret)=>{
    let resu = ret.getValue() as Object
    let airconditionresult = resu as AirConditionModel
    let airconditions = airconditionresult.result
    out.number = airconditions.length
    let aircondition_deviceId = []
    let aircondition_deviceName = []
    let aircondition_isOn = []
    let aircondition_mode = []
    let aircondition_temperature = []


    for(let index=0;index<airconditions.length;index++){
      aircondition_deviceId.push(airconditions[index].deviceId)
      aircondition_deviceName.push(airconditions[index].deviceName)
      aircondition_isOn.push(airconditions[index].isOn)
      aircondition_mode.push(airconditions[index].mode)
      aircondition_temperature.push(airconditions[index].temperature)

    }
    out.deviceId=aircondition_deviceId
    out.deviceName=aircondition_deviceName
    out.isOn=aircondition_isOn
    out.mode=aircondition_mode
    out.temperature=aircondition_temperature

    console.info("gwc out1:"+out.deviceId)
  })

  console.info("gwc out2:"+out.deviceId)
  return out
}


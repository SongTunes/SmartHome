import "@hw-agconnect/function-ohos";
import agconnect from '@hw-agconnect/api-ohos';
import { LampUiModel } from '../../model/LampUiModel';
import { LampModel } from '../../model/LampModel';
export async function delLamp(deleteId:string):Promise<string>{
  let return_string = ""
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("lamp-$latest")
  let params = {
    "action":"delete",
    "deviceId": deleteId,
  }
  await functionCallable.call(params).then((ret:any)=>{
    let resStr = JSON.stringify(ret.getValue().result);
    return_string = resStr
  })
  return return_string
}

export async function addLamp(userId:string,deviceName:string,coordX:number,coordY:number):Promise<string>{
  let return_string = ""
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("lamp-$latest")
  let params = {
    "action":"upsert",
    "userId": userId,
    "deviceName": deviceName,
    "coordX": coordX,
    "coordY": coordY
  }
  await functionCallable.call(params).then((ret:any)=>{
    let resStr = JSON.stringify(ret.getValue().result);
    return_string = resStr
  })
  return return_string
}

export async function modifyLamp(deviceId:string,isOn:boolean):Promise<string>{
  let return_string = ""
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("lamp-$latest")
  let params = {
    "action":"update",
    "deviceId":deviceId,
    "isOn": isOn
  }
  await functionCallable.call(params).then((ret)=>{
    let resStr = JSON.stringify(ret.getValue().result);
    return_string = resStr
  })
  return return_string
}

export async function getLamp(userId:string):Promise<LampUiModel>{
  let out = new LampUiModel()
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("lamp-$latest")
  let params = {"action":"select","userId":userId}
  await functionCallable.call(params).then((ret)=>{
    let resu = ret.getValue() as Object
    let lampresult = resu as LampModel
    let lamps = lampresult.result
    out.number = lamps.length
    let temp_deviceId = []
    let temp_deviceName = []
    let temp_isOn = []
    let temp_coordX = []
    let temp_coordY = []
    for(let index=0;index<lamps.length;index++){
      temp_deviceId.push(lamps[index].deviceId)
      temp_deviceName.push(lamps[index].deviceName)
      temp_isOn.push(lamps[index].isOn)
      temp_coordX.push(lamps[index].coordX)
      temp_coordY.push(lamps[index].coordY)
    }
    out.deviceId=temp_deviceId
    out.deviceName=temp_deviceName
    out.isOn=temp_isOn
    out.coordX=temp_coordX
    out.coordY=temp_coordY
  })

  return out
}
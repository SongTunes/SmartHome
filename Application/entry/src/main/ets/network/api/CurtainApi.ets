import "@hw-agconnect/function-ohos";
import agconnect from '@hw-agconnect/api-ohos';
import { CurtainModel } from '../../model/CurtainModel';
import { CurtainUiModel } from '../../model/CurtainUiModel';

export async function delCurtain(deleteId:string):Promise<string>{
  let return_string = ""
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("curtain-$latest")
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

export async function addCurtain(userId:string,deviceName:string):Promise<string>{
  let return_string = ""
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("curtain-$latest")
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

export async function modifyCurtain(deviceId:string,isOpened:boolean):Promise<string>{
  let return_string = ""
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("curtain-$latest")
  let params = {
    "action":"update",
    "deviceId":deviceId,
    "isOpened": isOpened
  }
  await functionCallable.call(params).then((ret)=>{
    let resStr = JSON.stringify(ret.getValue().result);
    return_string = resStr
  })
  return return_string
}

export async function getCurtain(userId:string):Promise<CurtainUiModel>{
  let out = new CurtainUiModel()
  agconnect.instance().init(getContext(this))
  let functionCallable = agconnect.function().wrap("curtain-$latest")
  let params = {"action":"select","userId":userId}
  await functionCallable.call(params).then((ret)=>{
    let resu = ret.getValue() as Object
    let curtainresult = resu as CurtainModel
    let curtains = curtainresult.result
    out.number = curtains.length
    let curtain_deviceId = []
    let curtain_deviceName = []
    let curtain_isOpened = []

    for(let index=0;index<curtains.length;index++){
      curtain_deviceId.push(curtains[index].deviceId)
      curtain_deviceName.push(curtains[index].deviceName)
      curtain_isOpened.push(curtains[index].isOpened)

    }
    out.deviceId=curtain_deviceId
    out.deviceName=curtain_deviceName
    out.isOpened=curtain_isOpened

    console.info("gwc out1:"+out.deviceId)
  })

  console.info("gwc out2:"+out.deviceId)
  return out
}
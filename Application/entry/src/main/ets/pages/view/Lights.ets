import agconnect from '@hw-agconnect/api-ohos';
import thermal from '@ohos.thermal';
import { LampModel } from '../../model/LampModel';
import { LampUiModel } from '../../model/LampUiModel';
import { AddDeviceDialog, CustomDialogExample } from './Dialog';
import "@hw-agconnect/function-ohos";
import { getLamp, modifyLamp } from '../../network/api/LightApi';
import router from '@ohos.router';
@Entry
@Component
export default struct Lights{
  deleteId = ''
  scroller: Scroller = new Scroller()
  userId : String = "";
  dialogController:CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      lampUiModel:$lampUiModel,
      userId:this.userId.toString(),
      delDevice:this.deleteId,
      cancel: this.onCancel,
      confirm: this.onAcceptDel,
    }),
    alignment: DialogAlignment.Default
  })

  addDevice:CustomDialogController = new CustomDialogController({
    builder: AddDeviceDialog({
      lampUiModel:$lampUiModel,
      userId:this.userId.toString(),
      cancel: this.onCancel,
      confirm: this.onAcceptAdd,
    })
  })
  onCancel(){console.info('取消');}
  onAcceptAdd(){
    // 如果添加成功
    if(true){
      AlertDialog.show({message:"添加成功"})
    }
    else {
      AlertDialog.show({message:"添加失败"})
    }
  }
  onAcceptDel(){
    // 如果删除成功
    if(true){
      AlertDialog.show({message:"删除成功"})
    }
    else {
      AlertDialog.show({message:"删除失败"})
    }
  }

  @State lampUiModel:LampUiModel = {
    number: 0,
    deviceId: [],
    deviceName: [],
    isOn: [],
    coordX: [],
    coordY: []
  };
  @State user:Object = router.getParams()
  build(){
    Column(){
      // 房间的布局图
      Image($r('app.media.home'))
        .height('44%')
        .borderRadius(40)
        .shadow({
          radius:20,
          color:'#ff665a5a',
          offsetX:15,
          offsetY:15
        })
      ForEach(this.lampUiModel.isOn,(item:boolean,index:number)=>{
        if(item==false){
          Image($r('app.media.off'))
            .height(50)
            .width(50)
            .position({x:this.lampUiModel.coordX[index],y:this.lampUiModel.coordY[index]})
        }
        else {Image($r('app.media.on'))
          .height(50)
          .width(50)
          .position({x:this.lampUiModel.coordX[index],y:this.lampUiModel.coordY[index]})
        }
      },item=>item)
      // 中间为台灯的具体信息
      Scroll(this.scroller) {
        Column() {
          ForEach(this.lampUiModel.deviceName, (item:String,index:Number) => {
            Column(){
              Button({ type: ButtonType.Circle, stateEffect: true }){
                Image($r('app.media.delete'))
                  .width(28)
                  .height(28)
              }
              .width(40).height(40).margin({ left: 20 }).backgroundColor('#ffffff')
              .position({x:10,y:10})
              .onClick(()=>{
                this.deleteId = this.lampUiModel.deviceId[index.valueOf()]
                this.dialogController.open();
              })
              Text(item.toString())
                .textAlign(TextAlign.Center)
                .fontSize('20.00fp')
                .width('90%')
                .height('100')
                .fontColor('#ffd79f9f')
                .backgroundColor('#00ff0b0b')
                .fontWeight(FontWeight.Bolder)
              Toggle({
                type: ToggleType.Switch,
                isOn: (this.lampUiModel.isOn[index.valueOf()])
              })
                .onChange(async (isOn:boolean)=>{
                  // 修改台灯状态
                  isOn = !this.lampUiModel.isOn[index.valueOf()];
                  if (isOn == false) {
                    let ret = await modifyLamp(this.lampUiModel.deviceId[index.valueOf()],isOn)
                    if(ret=="true"){
                      this.lampUiModel = await getLamp(this.userId.toString())
                    }
                  }
                  else {
                    let ret = await modifyLamp(this.lampUiModel.deviceId[index.valueOf()],isOn)
                    if(ret=="true"){
                      this.lampUiModel = await getLamp(this.userId.toString())
                    }
                  }
                })
                .position({x:'80%',y:'15%'})
                .selectedColor('#ffd79f9f')
            }
            .width('90%')
            .height('100')
            // .backgroundColor('#fff0d6cc')
            .backgroundColor('#ffffff')
            .borderRadius(15)
            .margin({ top: 10 })
          }, item => item)
          Column(){
            Button('添加设备')
              .borderRadius(20)
              .backgroundColor('#ffd79f9f')
              // 添加设备
              .onClick(()=>{
                // this.initData()
                this.addDevice.open()
              })

          }
          .width('100%')
          .margin({ top: 10 })

        }}
      .height('46%')
      .scrollable(ScrollDirection.Vertical)  // 滚动方向纵向
      .scrollBar(BarState.On)  // 滚动条常驻显示
      .scrollBarColor(Color.Gray)  // 滚动条颜色
      .scrollBarWidth(10) // 滚动条宽度
      .edgeEffect(EdgeEffect.None)
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }){
        Column(){
          Button(){
            Image($r('app.media.home_icon_off'))
              .size({height:35,width:35})
          }
          .onClick(()=>{
            router.replaceUrl({
              url:'pages/Weather' ,
              params:{
                userId:this.user['userId'],
                phoneNumber:this.user['phoneNumber']
              }
            })
          })
          .backgroundColor(Color.White)
        }
        .margin({left:50,right:10})
        .backgroundColor('#ffffff')
        Column(){
          Button(){
            Image($r('app.media.lamp_icon_on'))
              .size({height:35,width:35})
          }
          .backgroundColor(Color.White)
          Text('Lamp')
            .fontColor('#ffEAA692')
        }
        .margin({left:10,right:10})
        .backgroundColor('#ffffff')
        Column(){
          Button(){
            Image($r('app.media.air_icon_off'))
              .size({height:35,width:35})
          }
          .onClick(()=>{
            router.replaceUrl({
              url:'pages/view/AirCondition' ,
              params:{
                userId:this.user['userId'],
                phoneNumber:this.user['phoneNumber']
              }
            })
          })
          .backgroundColor(Color.White)
        }
        .margin({left:10,right:10})
        .backgroundColor('#ffffff')
        Column(){
          Button(){
            Image($r('app.media.curtain_icon_off'))
              .size({height:35,width:35})
          }
          .onClick(()=>{
            router.replaceUrl({
              url:'pages/view/Curtain' ,
              params:{
                userId:this.user['userId'],
                phoneNumber:this.user['phoneNumber']
              }
            })
          })
          .backgroundColor(Color.White)
        }
        .margin({left:10,right:10})
        .backgroundColor('#ffffff')
      }
      .margin({top:5})
      .width('80%')
      .height('8%')
      .backgroundColor('#ffffff')
      .borderRadius(40)
      .shadow({
        radius:20,
        color:'#ff665a5a',
        offsetX:15,
        offsetY:15
      })
    }
    .height('100%')
    .backgroundColor('#fff0d6cc')

  }
  aboutToAppear(){
    this.lampUiModel = new LampUiModel()
    this.userId = this.user['phoneNumber'].substring(4)
    this.initData()
  }

  async initData(){
    this.lampUiModel = await getLamp(this.userId.toString())
  }
}
import router from '@ohos.router'
import { AirConditionUiModel } from '../../model/AirConditionUiModel';
import "@hw-agconnect/function-ohos";
import {delAirCondition,addAirCondition,modifyAirCondition,getAirCondition} from '../../network/api/AirConditionApi'
@CustomDialog
struct CustomDialogExample {
  @Link AirConditionUiModel:AirConditionUiModel
  @Link current_index:number
  userId : string = "";
  controller: CustomDialogController
  scroller: Scroller = new Scroller()
  name:string = ''

  @Builder itemEnd(id:string,index: number) {
    // 侧滑后尾端出现的组件
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.delete_2'))
    }
    .onClick(async () => {
      //this.CurtainUiModel.deviceName.splice(index, 1);
      let ret = await delAirCondition(id)
      console.info("return gwc:"+ret)
      if(ret=="true") {
        this.AirConditionUiModel = await getAirCondition(this.userId)
      }
    })

  }


  build() {
    Column() {
      Text('请选择当前要控制的设备：').fontSize(20).margin(10).fontColor('#e2e3a8b5')
      Scroll(this.scroller) {
        List() {
          ForEach(this.AirConditionUiModel.deviceName, (item, index) => {
            ListItem() {
              Button(item,{ type: ButtonType.Normal })
                .onClick(() => {

                  this.current_index=index
                  console.info("choose gwc:"+index)
                  console.info("choose gwc:"+this.current_index)

                })
                .backgroundColor('#ffd79f9f').fontColor('#ffece9eb').width('60%')
                .margin(10).borderRadius(10)
            }
            .width('100%').height(50)
            .swipeAction({ end: this.itemEnd.bind(this,this.AirConditionUiModel.deviceId[index] ,index) }) // 设置侧滑属性
          })
        }
      }.scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(5)
      .width('100%')
      .height('60%')
      Text('——————————————————————').fontColor('#e2e3a8b5')
      Text('添加新的设备：').fontSize(20).margin(10).fontColor('#e2e3a8b5')
      TextArea()
        .margin(5)
        .onChange((value:string)=>{
          this.name = value
          // console.log(value)
        })
      Button('确认', { type: ButtonType.Normal })
        .onClick(async () => {
          let ret = await addAirCondition(this.userId,this.name)
          if (ret=="true"){
            this.AirConditionUiModel = await getAirCondition(this.userId)

          }
        })
        .backgroundColor('#ffd79f9f').fontColor('#ffece9eb').borderRadius(20).width('40%')


    }.width('100%')
    .height('90%')


  }
}

@Entry
@Component
export default struct aircondition {
  @State user:Object = router.getParams()
  @State temp: number =25
  @State mode: string ='COOL'
  @State onoff: string =''
  @State picture: string=''
  userId : string = "";
  @State current_index: number=-1
  init_pic:string=''
  @State AirConditionUiModel: AirConditionUiModel = {
    number: 0,
    deviceId: [],
    deviceName: [],
    isOn: [],
    mode:[],
    temperature:[]

  };
  //@Link user: Object

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      AirConditionUiModel:$AirConditionUiModel,
      userId:this.userId.toString(),
      current_index:$current_index,


    }),
  })



  private TempUp() {
    this.temp += 1
  }
  private TempDown() {
    this.temp -= 1
  }
  private Switch() {

    if(this.onoff=='' || this.onoff=='OFF'){
      this.onoff='ON'
    }
    else{
      this.onoff='OFF'
    }


  }
  private ShowTemp() {
    if(this.onoff=='ON'){
      return String(this.temp+'°C')
    }
    else{
      return ''
    }
  }

  private ShowMode() {
    console.info('gaowancong:'+this.AirConditionUiModel.isOn)
    console.info('gaowancong:'+this.AirConditionUiModel.mode)
    if(this.AirConditionUiModel.isOn[this.current_index]==true && this.AirConditionUiModel.mode[this.current_index]=='Heat'){
      this.picture='app.media.heatshow'
      return this.picture
    }
    else if(this.AirConditionUiModel.isOn[this.current_index]==true && this.AirConditionUiModel.mode[this.current_index]=='Cool'){
      this.picture='app.media.coolshow'
      return this.picture
    }
    else if(this.AirConditionUiModel.isOn[this.current_index]==false){
      console.info('gaowancong:11')
      this.picture='app.media.coolshow'
      return this.picture
    }
  }

  build() {
    Column() {
      Column({ space: 10 }) {

        Row() {
          if (this.current_index != -1 && this.AirConditionUiModel.isOn[this.current_index] == true && this.AirConditionUiModel.mode[this.current_index] == 'Cool') {
            Image($r('app.media.coolshow')).width(40).height(40).position({ x: '50%', y: '10%' })
          }
          else if (this.current_index != -1 && this.AirConditionUiModel.isOn[this.current_index] == true && this.AirConditionUiModel.mode[this.current_index] == 'Heat') {
            Image($r('app.media.heatshow')).width(40).height(40).position({ x: '50%', y: '10%' })
          }
          else { //init或者关闭
            Image($r(this.init_pic)).width(40).height(40).position({ x: '50%', y: '10%' })
          }

          if (this.current_index != -1 && this.AirConditionUiModel.isOn[this.current_index] == true) {
            Text(String(this.AirConditionUiModel.temperature[this.current_index]) + '°C')
              .fontSize(30)
              .fontColor(Color.Black)
              .fontWeight(500)
              .width(100)
              .height(80)
              .position({ x: '70%', y: '6%' })
          }
          else { //init或者关闭

          }


          if (this.current_index != -1 && this.AirConditionUiModel.isOn[this.current_index] == false) {
            Text('OFF')
              .fontSize(30)
              .fontColor(Color.Black)
              .fontWeight(500)
              .width(100)
              .height(80)
              .position({ x: '50%', y: '27%' })
          }
          else if (this.current_index != -1 && this.AirConditionUiModel.isOn[this.current_index] == true) {
            Text('ON')
              .fontSize(30)
              .fontColor(Color.Black)
              .fontWeight(500)
              .width(100)
              .height(80)
              .position({ x: '50%', y: '27%' })
          }
          else {
            Text('')
              .fontSize(30)
              .fontColor(Color.Black)
              .fontWeight(500)
              .width(100)
              .height(80)
              .position({ x: '50%', y: '27%' })
          }
        }
        .width(350)
        .height(280)
        .backgroundImage($r('app.media.air_new'), ImageRepeat.NoRepeat)
        .backgroundImageSize(ImageSize.Cover)

        Row() {
          Text('功能').position({ x: '5%', y: '10%' })
          Text('————————————————————').position({ x: '0%', y: '18%' }).fontColor(0xCCCCCC)
          Row() {
            //开关
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.cold')).width(50).height(50)
            }
            .width(55)
            .height(55)
            .backgroundColor('#fff0d6cc')
            .overlay('制冷', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
            .onClick(async () => {
              this.mode = 'COOL'
              console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.mode)
              console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.temperature)
              console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.isOn)
              let ret = await modifyAirCondition(this.AirConditionUiModel.deviceId[this.current_index], this.AirConditionUiModel.isOn[this.current_index], 'Cool', this.AirConditionUiModel.temperature[this.current_index])
              if (ret == "true") {
                console.info("gaowancong acmodel-result:" + ret)
                this.AirConditionUiModel = await getAirCondition(this.userId.toString())
              }
              console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.mode)
              console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.temperature)
              console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.isOn)
            })


            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.onoff')).width(50).height(50)
            }
            .width(55)
            .height(55)
            .backgroundColor(0xFFFFFF)
            .overlay('开/关', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
            .onClick(async () => {
              this.Switch.bind(this)
              console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.mode)
              console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.temperature)
              console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.isOn)
              if (this.AirConditionUiModel.isOn[this.current_index] == false) {
                let ret = await modifyAirCondition(this.AirConditionUiModel.deviceId[this.current_index], true, this.AirConditionUiModel.mode[this.current_index], this.AirConditionUiModel.temperature[this.current_index])
                if (ret == "true") {
                  console.info("gaowancong acmodel-result:" + ret)
                  this.AirConditionUiModel = await getAirCondition(this.userId.toString())
                }
              }
              else {
                let ret = await modifyAirCondition(this.AirConditionUiModel.deviceId[this.current_index], false, this.AirConditionUiModel.mode[this.current_index], this.AirConditionUiModel.temperature[this.current_index])
                if (ret == "true") {
                  console.info("gaowancong acmodel-result:" + ret)
                  this.AirConditionUiModel = await getAirCondition(this.userId.toString())
                }

                console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.mode)
                console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.temperature)
                console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.isOn)
              }
            }

            )

            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.hot')).width(50).height(50)
            }
            .width(55)
            .height(55)
            .backgroundColor(0xFFFFFF)
            .overlay('制热', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
            .onClick(async () => {
              this.mode = 'HEAT'
              console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.mode)
              console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.temperature)
              console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.isOn)
              let ret = await modifyAirCondition(this.AirConditionUiModel.deviceId[this.current_index], this.AirConditionUiModel.isOn[this.current_index], 'Heat', this.AirConditionUiModel.temperature[this.current_index])
              if (ret == "true") {
                console.info("gaowancong acmodel-result:" + ret)
                this.AirConditionUiModel = await getAirCondition(this.userId.toString())
              }
              console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.mode)
              console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.temperature)
              console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.isOn)
            })

          }.width('100%').justifyContent(FlexAlign.SpaceAround).position({ x: '0%', y: '28%' })

          //温度升降
          Row() {
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.down')).width(50).height(50)
            }
            .width(55)
            .height(55)
            .backgroundColor(0xFFFFFF)
            .overlay('升温', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
            .onClick(
              async () => {
                this.TempUp.bind(this)
                console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.mode)
                console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.temperature)
                console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.isOn)
                let ret = await modifyAirCondition(this.AirConditionUiModel.deviceId[this.current_index], this.AirConditionUiModel.isOn[this.current_index], this.AirConditionUiModel.mode[this.current_index], this.AirConditionUiModel.temperature[this.current_index] + 1)
                if (ret == "true") {
                  console.info("gaowancong acmodel-result:" + ret)
                  this.AirConditionUiModel = await getAirCondition(this.userId.toString())
                }
                console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.mode)
                console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.temperature)
                console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.isOn)
              }


            )

            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.up')).width(50).height(50)
            }
            .width(55)
            .height(55)
            .backgroundColor(0xFFFFFF)
            .overlay('降温', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
            .onClick(
              async () => {
                this.TempDown.bind(this)
                console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.mode)
                console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.temperature)
                console.info("gaowancong acmodel -before:" + this.AirConditionUiModel.isOn)
                let ret = await modifyAirCondition(this.AirConditionUiModel.deviceId[this.current_index], this.AirConditionUiModel.isOn[this.current_index], this.AirConditionUiModel.mode[this.current_index], this.AirConditionUiModel.temperature[this.current_index] - 1)
                if (ret == "true") {
                  console.info("gaowancong acmodel-result:" + ret)
                  this.AirConditionUiModel = await getAirCondition(this.userId.toString())
                }
                console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.mode)
                console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.temperature)
                console.info("gaowancong acmodel-after:" + this.AirConditionUiModel.isOn)
              }
            )

          }.width('100%').justifyContent(FlexAlign.SpaceAround).position({ x: '0%', y: '65%' })

        }
        .backgroundColor(0xFFFFFF)
        .borderRadius(20)
        .width('80%')
        .height('30%')
        .backgroundColor('#fffae9e9')

        Row() {
          Text('设备').position({ x: '5%', y: '14%' })
          Text('————————————————————').position({ x: '0%', y: '22%' }).fontColor(0xCCCCCC)
          Text('当前设备：').width('100%').height('20%').position({ x: '5%', y: '30%' })
          if (this.current_index != -1) {
            Text(String(this.AirConditionUiModel.deviceName[this.current_index]))
              .width('100%')
              .height('20%')
              .position({ x: '35%', y: '30%' })
          }
          else {
            Text('无').width('100%').height('20%').position({ x: '35%', y: '30%' })
          }

          Flex({ justifyContent: FlexAlign.Center }) {
            Button('选择或添加设备').position({ x: '28%', y: '60%' }).backgroundColor(0xFFFFFF).fontColor(0x000000)
              .onClick(() => {
                this.dialogController.open()
              })
          }.width('100%').height('40%')
        }
        .backgroundColor(0xFFFFFF)
        .borderRadius(20)
        .width('80%')
        .height('20%')
        .backgroundColor('#fffae9e9')
      }
      .alignItems(HorizontalAlign.Center)
      .height(200)
      .backgroundColor('#fff0d6cc')
      .width('100%')
      .height('90%')
      // 补充

      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Column() {
          Button() {
            Image($r('app.media.home_icon_off'))
              .size({ height: 35, width: 35 })
          }
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/Weather',
              params: {
                userId: this.user['userId'],
                phoneNumber: this.user['phoneNumber']
              }
            })
          })
          .backgroundColor(Color.White)
        }
        .margin({ left: 50, right: 10 })
        .backgroundColor('#ffffff')

        Column() {
          Button() {
            Image($r('app.media.lamp_icon_off'))
              .size({ height: 35, width: 35 })
          }
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/view/Lights',
              params: {
                userId: this.user['userId'],
                phoneNumber: this.user['phoneNumber']
              }
            })
          })
          .backgroundColor(Color.White)
        }
        .margin({ left: 10, right: 10 })
        .backgroundColor('#ffffff')

        Column() {
          Button() {
            Image($r('app.media.air_icon_on'))
              .size({ height: 35, width: 35 })
          }
          .backgroundColor(Color.White)

          Text('Air-c')
            .fontColor('#ffEAA692')
        }
        .margin({ left: 10, right: 10 })
        .backgroundColor('#ffffff')

        Column() {
          Button() {
            Image($r('app.media.curtain_icon_off'))
              .size({ height: 35, width: 35 })
          }
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/view/Curtain',
              params: {
                userId: this.user['userId'],
                phoneNumber: this.user['phoneNumber']
              }
            })
          })
          .backgroundColor(Color.White)
        }
        .margin({ left: 10, right: 10 })
        .backgroundColor('#ffffff')
      }
      .margin({ top: 5 })
      .width('80%')
      .height('8%')
      .backgroundColor('#ffffff')
      .borderRadius(40)
      .shadow({
        radius: 20,
        color: '#ff665a5a',
        offsetX: 15,
        offsetY: 15
      })

    }.height('100%')
    .backgroundColor('#fff0d6cc')


    }
  aboutToAppear() {
    this.AirConditionUiModel = new AirConditionUiModel()
    this.userId = this.user['phoneNumber'].substring(4)
    this.initData()
  }

  async initData() {
    this.AirConditionUiModel = await getAirCondition(this.userId.toString())
  }
}
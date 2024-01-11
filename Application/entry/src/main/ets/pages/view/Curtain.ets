import router from '@ohos.router'
import { CurtainUiModel } from '../../model/CurtainUiModel';
import "@hw-agconnect/function-ohos";
import agconnect from '@hw-agconnect/api-ohos';
import {delCurtain,addCurtain,modifyCurtain,getCurtain} from '../../network/api/CurtainApi'
import { init } from '@ohos/agconnect-auth-component/src/main/ets/common/AuthInfo';

@CustomDialog
struct CustomDialogExample {
  @Link CurtainUiModel:CurtainUiModel
  userId : string = "";
  controller: CustomDialogController
  scroller: Scroller = new Scroller()
  @Link current_index:number
  @Link flag:number

  name:string = ''
  @Builder itemEnd(id:string,index:number) {
    // 侧滑后尾端出现的组件
    Button({ type: ButtonType.Circle }) {
      Image('image/delete.png')
    }
    .onClick(async () => {
      //this.CurtainUiModel.deviceName.splice(index, 1);
      let ret = await delCurtain(id)
      console.info("return gwc:"+ret)
      if(ret=="true") {
        this.CurtainUiModel = await getCurtain(this.userId)
      }
    })

  }

  build() {
    Column() {
      Text('请选择当前要控制的设备：').fontSize(20).margin(10).fontColor('#e2e3a8b5')
      Scroll(this.scroller) {
        List() {
          ForEach(this.CurtainUiModel.deviceName, (item, index) => {
            ListItem() {
              Button(item)
                .onClick(() => {
                  if(this.CurtainUiModel.isOpened[index]){
                    this.flag=2//open
                  }
                  else{
                    this.flag=0//close
                  }
                  this.current_index=index
                  console.info("choose gwc:"+index)
                  console.info("choose gwc:"+this.current_index)

                })
                .backgroundColor('#ffd79f9f').fontColor('#ffece9eb').width('60%')
                .margin(10).borderRadius(10)
                .margin(10)
            }
            .width('100%').height(50)
            .swipeAction({ end: this.itemEnd.bind(this,this.CurtainUiModel.deviceId[index], index) }) // 设置侧滑属性
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
      Button('确认')
        .onClick(async () => {
          let ret = await addCurtain(this.userId,this.name)
          if (ret=="true"){
            this.CurtainUiModel = await getCurtain(this.userId)

          }
        }).backgroundColor('#ffd79f9f').fontColor('#ffece9eb').borderRadius(20).width('40%')

    }.width('100%')
    .height('90%')


  }
}
@Entry
@Component
struct Curtain {
  @State user:Object = router.getParams()
  @State flag: number = 0
  // 0:静关 1:动开 2:静开 3:动关
  @State init_flag: number = 0
  @State picture: string = 'image/open.gif'
  @State num: number = 0
  @State control: number = 0//first:0
  userId : string = "";
  @State current_index: number=-1
  @State CurtainUiModel: CurtainUiModel = {
    number: 0,
    deviceId: [],
    deviceName: [],
    isOpened: []
  };


  textTimerController: TextTimerController = new TextTimerController()
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({
      CurtainUiModel:$CurtainUiModel,
      userId:this.userId.toString(),
      current_index:$current_index,
      flag:$flag,


    }),
  })


  private ShowAnimateOpen(init_state:Boolean) {
    // if (init_state ){//init:open
    //   this.init_flag=2
    // }
    // if (init_state ){//
    //   this.init_flag=0
    // }
    if (this.flag == 0) {
      this.picture = 'image/close_state.png';
    }
    else if (this.flag == 1) {
      this.picture = 'image/open.gif';
    }
    else if (this.flag == 2 ) {
      this.picture = 'image/open_state.png';
    }
    else if (this.flag == 3) {
      this.picture = 'image/close.gif';
    }

    return this.picture

  }

  build() {
    Column(){
    Column({ space: 300 }){
      // 补充
      Row() {
        if(this.current_index!=-1) {
          Image(this.ShowAnimateOpen(this.CurtainUiModel.isOpened[this.current_index]))
            .width(398)
            .height(200)
            .position({ x: '1%', y: '1%' })
        }
        else{
          Image(this.ShowAnimateOpen(false))
            .width(398)
            .height(200)
            .position({ x: '1%', y: '1%' })
        }
      }

      Column({ space: 100 }) {
        Row() {
          Text('功能').position({ x: '5%', y: '15%' })
          Text('————————————————').position({ x: '0%', y: '24%' }).fontColor(0xCCCCCC)
          Toggle({ type: ToggleType.Button, isOn: false }) {
            Text('开/关').padding({ left: 20, right: 20 }).fontSize(15)
          }
          .width("70%")
          .height("50%")
          .position({ x: '15%', y: '35%' })
          .selectedColor(0xFFFFFF)
          .onChange(async (isOn: boolean) => {

            console.info('Component status:' + isOn)
            if(this.current_index!=-1){
              // 0:静关 1:动开 2:静开 3:动关
              console.info('gwctestopen'+this.CurtainUiModel.isOpened[this.current_index])
              if(this.CurtainUiModel.isOpened[this.current_index]){//opened-------
                console.info("gaowancong curtainmodel -before:"+this.CurtainUiModel.isOpened)
                let ret = await modifyCurtain(this.CurtainUiModel.deviceId[this.current_index],false)
                if(ret=="true"){
                  console.info("gaowancong curtainmodel-result:"+ret)
                  this.CurtainUiModel = await getCurtain(this.userId.toString())
                }
                console.info("gaowancong curtainmodel-after:"+this.CurtainUiModel.isOpened)

                this.flag = 3
                setTimeout(() => {
                  this.flag = 0
                }, 6000)

              }
              else{//closed------
                console.info("gaowancong curtainmodel -before:"+this.CurtainUiModel.isOpened)
                let ret = await modifyCurtain(this.CurtainUiModel.deviceId[this.current_index],true)
                if(ret=="true"){
                  console.info("gaowancong curtainmodel-result:"+ret)
                  this.CurtainUiModel = await getCurtain(this.userId.toString())
                }
                console.info("gaowancong curtainmodel -after:"+this.CurtainUiModel.isOpened)
                this.flag = 1
                setTimeout(() => {
                  this.flag = 2
                }, 6000)
                // if (isOn) {//open
                //   this.flag = 1
                //   setTimeout(() => {
                //     this.flag = 2
                //   }, 6000)
                // }
                // else {//close
                //   this.flag = 3
                //   setTimeout(() => {
                //     this.flag = 0
                //   }, 6000)
                // }
              }
            }
            else{
              this.flag=0//default
            }

          })

        }
        .backgroundColor(0xFFFFFF)
        .borderRadius(20)
        .width('80%')
        .height('30%')
        .backgroundColor('#fffae9e9')

        Row() {
          Text('设备').position({ x: '5%', y: '14%' })
          Text('————————————————').position({ x: '0%', y: '22%' }).fontColor(0xCCCCCC)
          Text('当前设备：').width('100%').height('20%').position({x:'5%',y:'30%'})
          //log.info('gwcc'+this.CurtainUiModel.deviceName[0])
          if (this.current_index!=-1){
            Text(String(this.CurtainUiModel.deviceName[this.current_index])).width('100%').height('20%').position({ x: '35%', y: '30%' })
          }
          else{
            Text('无').width('100%').height('20%').position({ x: '35%', y: '30%' })
          }

          Flex({ justifyContent: FlexAlign.Center }) {
            Button('选择或添加设备').position({ x: '21%', y: '60%' }).backgroundColor(0xFFFFFF).fontColor(0x000000)
              .onClick(() => {
                this.dialogController.open()
              })
          }.width('100%').height('40%')
        }
        .backgroundColor(0xFFFFFF)
        .borderRadius(20)
        .width('80%')
        .height('50%')
        .backgroundColor('#fffae9e9')
      }.width('80%').height('50%').justifyContent(FlexAlign.SpaceAround)
    }.alignItems(HorizontalAlign.Center).height(200).backgroundColor('#fff0d6cc').width('100%').height('90%')
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
            Image($r('app.media.lamp_icon_off'))
              .size({height:35,width:35})
          }
          .onClick(()=>{
            router.replaceUrl({
              url:'pages/view/Lights' ,
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
            Image($r('app.media.curtain_icon_on'))
              .size({height:35,width:35})
          }
          .backgroundColor(Color.White)
          Text('Curtain')
            .fontColor('#ffEAA692')
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


  aboutToAppear() {
    this.CurtainUiModel = new CurtainUiModel()
    this.userId = this.user['phoneNumber'].substring(4)
    this.initData()
  }

  async initData() {
    this.CurtainUiModel = await getCurtain(this.userId.toString())
  }
}
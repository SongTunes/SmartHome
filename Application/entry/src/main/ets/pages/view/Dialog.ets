
import { LampUiModel } from '../../model/LampUiModel'
import { addLamp, delLamp, getLamp } from '../../network/api/LightApi'
@CustomDialog
export struct CustomDialogExample {
  @Link lampUiModel:LampUiModel
  userId:string
  delDevice:string
  controller: CustomDialogController
  cancel: () => void
  confirm: () => void
  build() {
    Column() {
      Text('确认删除该设备').fontSize(20).margin({ top: 10, bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(async () => {
            let ret = await delLamp(this.delDevice)
            if(ret=="true"){
              this.lampUiModel = await getLamp(this.userId)
              this.controller.close()
              this.confirm()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
  }
}

@CustomDialog
export struct AddDeviceDialog {
  @Link lampUiModel:LampUiModel
  controller: CustomDialogController
  userId:string
  @State position_x:number = 0
  @State position_y:number = 0
  name:string = ''
  cancel: () => void
  confirm: () => void
  build() {
    Column(){
      Column(){
        Image($r('app.media.home'))
          .width('100%')
          .onClick((event:ClickEvent)=>{
            this.position_x = event.x
            this.position_y = event.y
            console.log('x: '+this.position_x.toString()+'\ny:'+this.position_x.toString())
          })
      }.height('60%')
      Column(){
        Text('设备名称')
          .fontSize(20)
          .margin(10)
        TextArea()
          .margin(5)
          .onChange((value:string)=>{
            this.name = value
            // console.log(value)
          })
        if (this.position_x != 0){
          Text('x: '+this.position_x.toFixed(1)+'\ny:'+this.position_y.toFixed(1))
        }

      }.height('30%')
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
            this.cancel()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确认')
          .onClick(async () => {
            let ret = await addLamp(this.userId,this.name,this.position_x,this.position_y)
            if (ret=="true"){
              this.lampUiModel = await getLamp(this.userId)
              this.controller.close()
              this.confirm()
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
    .width('100%')
    .height('80%')

  }
}
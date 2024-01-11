import picker from '@ohos.file.picker';
import { weatherPart } from './view/weatherPart';
import router from '@ohos.router';
import { CityModel } from '../model/CityModel'

@Entry
@Component
struct Weather {
  @State user:Object = router.getParams()
  phoneNumber:string
  userId:string
  @State city1:CityModel = { locationId: 101010100, locationName: '北京' }
  @State city2:CityModel = { locationId: 101280601, locationName: '深圳' }
  @State city3:CityModel = { locationId: 101020100, locationName: '上海' }
  @State city4:CityModel = { locationId: 101250101, locationName: '长沙' }
  @State city5:CityModel = { locationId: 101310101, locationName: '海口' }
  @State city6:CityModel = { locationId: 101070201, locationName: '大连' }
  @State currentIndex:number = 0;
  private swiperController: SwiperController = new SwiperController()
  build() {
    Column(){
      Row() {
        Blank()
        Image($r('app.media.icon_more'))
          .width(28)
          .height(28)
          .onClick(()=>router.pushUrl({url:"pages/Info"}))
          .margin({top:5})

      }
      .width('80%').height('5%')
      Column(){
        Swiper(this.swiperController) {
          Column(){
            weatherPart({selectCity:$city1})
          }
          Column(){
            weatherPart({selectCity:$city2})
          }
          Column(){
            weatherPart({selectCity:$city3})
          }
          Column(){
            weatherPart({selectCity:$city4})
          }
          Column(){
            weatherPart({selectCity:$city5})
          }
          Column(){
            weatherPart({selectCity:$city6})
          }
          Column(){
            Blank()
              .width('90%')
              .height('80%')
          }
        }
        .indicatorStyle({
          size: 0
        })
        .width('100%')
      }
      .width('100%')
      .height('85%')
      .justifyContent(FlexAlign.Center)
      // 下面的图标
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }){
        Column(){
          Button(){
            Image($r('app.media.home_icon_on'))
              .size({height:35,width:35})
          }
          .backgroundColor(Color.White)
          Text('Home')
            .fontColor('#ffEAA692')
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
      // tabContent({user:$user})
    }
    .margin({top:5})
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.homepage'))
    .backgroundImageSize({width:'100%',height:'100%'})
  }
  aboutToAppear(){
    this.phoneNumber = this.user['phoneNumber']
    this.userId = this.user['userId']
  }
}
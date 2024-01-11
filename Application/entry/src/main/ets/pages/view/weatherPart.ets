
import util from '@ohos.util'
import router from '@ohos.router'
import { CityModel } from '../../model/CityModel'
import { NowWeatherModel } from '../../model/NowWeatherModel'
import { SimpleWeather } from '../../model/SimpleWeather'
import { getNowWeather } from '../../network/api/WeatherApi'
import utils from '../../utils/utils'
@Component
export struct  weatherPart{
  @Link selectCity:CityModel
  @State simpleWeather:SimpleWeather = {
    nowTemp:0,
    precip:0,
    iconDays:'',
    date:'',
    day:'',
    hour:'',
    humidity:0,
    windSpeed:0,
    windScale:'',
    text:''
  }
  windscale:string[]=['Calm','Light air','Light breeze','Gentle breeze',
  'Moderate breeze','Fresh breeze','Strong breeze','Near gale',
  'Gale','Strong gale','Storm','Violent storm','Hurricane']
  build(){
    Column(){
      Blank()
        .height('10%')
      Column(){
        Text(this.selectCity.locationName+',\nChina')
          .margin({top:50,right:145})
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Text(this.simpleWeather.nowTemp)
          .margin({top:20,right:170})
          .fontSize(60)
          .fontWeight(FontWeight.Bold)
        Text('°c')
          .fontSize(20)
          .fontColor('#E6000000')
          .fontWeight(FontWeight.Bold)
          .position({x:110,y:150})
        Text(this.simpleWeather.date)
          .fontColor('#ffffff')
          .padding({left:15,right:15,top:5,bottom:5})
          .borderRadius(20)
          .backgroundColor('#ffdec4be')
          .position({x:'55%',y:90})
        Text(this.simpleWeather.windScale)
          .fontColor('#ffffff')
          .padding({left:15,right:15,top:5,bottom:5})
          .borderRadius(20)
          .backgroundColor('#fffcc2c2')
          .position({x:'55%',y:130})
        Text(this.simpleWeather.text)
          .fontColor('#ffffff')
          .padding({left:15,right:15,top:5,bottom:5})
          .borderRadius(20)
          .backgroundColor('#ffe3dba5')
          .position({x:'55%',y:170})
        Text(this.simpleWeather.day+','+this.simpleWeather.hour)
          .fontColor("#ff808080")
          .borderRadius(20)
          .position({x:40,y:205})
      }
      .backgroundColor('#ffffff')
      .width('75%')
      .height('40%')
      .margin({left:18})
      .borderRadius(40)
      .shadow({
        radius:20,
        color:'#ff665a5a',
        offsetX:15,
        offsetY:15

      })
      // .offset()
      Image(this.simpleWeather.iconDays)
        .position({y:-25,x:120})
        .height('30%')
      Button('VIEW STATS', { type: ButtonType.Normal })
        .width('50%')
        .margin({top:-25,left:15})
        .borderRadius(40)
        .backgroundColor('#ffd79f9f')
        .height(50)
        .onClick(()=>{
          router.pushUrl({
            url:"pages/WeatherDetail",
            params:{
              locationId:this.selectCity.locationId,
              locationName:this.selectCity.locationName,
              precipitation:this.simpleWeather.precip,
              humidity:this.simpleWeather.humidity,
              wind:this.simpleWeather.windSpeed
            }

          })
        })
      Row(){
        Image($r('app.media.precipitation_gray'))
          .size({height:25,width:25})
          .margin({top:20})
        Blank().width('2%')
        Text('Precipitation  '+this.simpleWeather.precip+' %')
          .margin({top:20})
          .fontColor("#ffabaaaa")
          .fontWeight(FontWeight.Bold)
      }
      Row(){
        Image($r('app.media.humidity_gray'))
          .size({height:20,width:20})
          .margin({top:10})
        Blank().width('2%')
        Text('Humidity  '+this.simpleWeather.humidity+' %')
          .margin({top:10})
          .fontColor("#ffabaaaa")
          .fontWeight(FontWeight.Bold)
      }
      Row(){
        Image($r('app.media.wind_gray'))
          .size({height:20,width:20})
          .margin({top:10})

        Blank().width('2%')
        Text('Wind  '+this.simpleWeather.windSpeed+' km/h')
          .margin({top:10})
          .fontColor("#ffabaaaa")
          .fontWeight(FontWeight.Bold)

      }

    }
    // .position({x:20,y:20})
  }
  aboutToAppear(){
    this.initData()

  }
  async initData(){
    let resultNow = await getNowWeather(this.selectCity.locationId)
    let weatherNow = resultNow.result as NowWeatherModel
    this.simpleWeather.nowTemp = weatherNow.now.temp
    this.simpleWeather.precip = weatherNow.now.precip
    this.simpleWeather.iconDays = 'Images/'+weatherNow.now.icon+'.png'
    this.simpleWeather.humidity = weatherNow.now.humidity
    this.simpleWeather.windSpeed = weatherNow.now.windSpeed
    this.simpleWeather.windScale = this.windscale[weatherNow.now.windScale]
    this.simpleWeather.text = weatherNow.now.text
    this.simpleWeather.date = utils.getDate()
    this.simpleWeather.day = utils.getDay()
    this.simpleWeather.hour = utils.getHour()
  }
}
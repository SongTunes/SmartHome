import router from '@ohos.router'
import { NowWeatherModel, Weather24hModel, Weather7dModel } from '../model/NowWeatherModel'
import { WeatherUiModel } from '../model/WeatherUiModel'
import { get24hWeather, get7dWeather, getNowWeather } from '../network/api/WeatherApi'
import utils from '../utils/utils'
@Entry
@Component
struct WeatherDetail {
  @State tempmax7d:string[] = []
  @State tempmin7d:string[] = []
  scroller: Scroller = new Scroller()
  weather:Object = router.getParams()
  @State weather3d:string[] = []
  @State week:string[] = ['Monday','Tuesday','Wednesday']
  @State message:string = ''
  private lineHeight: number = 40;
  private lineWidth: number = 320;
  @State selectDay: string = '今天';
  @State selectCity:Object = router.getParams()
  @State @Watch('calculatePoint') weatherUiModel:WeatherUiModel = {
    nowTemp: 0,
    nowWeatherText: 0,
    tempMax: 0,
    tempMin: 0,
    category: 0,
    precip: 0,
    hourlyTemp: [],
    iconDays: [],
    date: '-月-日',
    day: '',
    dayArr: utils.getDayArr(),
    hoursArr: utils.getHoursArr(),
    pointArr: []
  }
  // 城市，温度，天气状况
  build(){
    Column(){

      Column(){
        Column(){
          Text(this.selectCity['locationName']+',\nChina')
            .margin({top:50,right:125})
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
            .position({x:30,y:50})
          Text(this.weatherUiModel.nowTemp)
            .margin({top:20,right:150})
            .fontSize(60)
            .fontWeight(FontWeight.Bold)
            .position({x:25,y:130})
          Text(this.weatherUiModel.tempMin+'°c / '+this.weatherUiModel.tempMax+'°c')
            .fontSize(20)
            .position({x:30,y:200})
            .fontColor('#ffa5a2a2')
          Text('°c')
            .fontSize(20)
            .fontColor('#E6000000')
            .fontWeight(FontWeight.Bold)
            .position({x:100,y:140})
          Image(this.weatherUiModel.iconDays[0])
            .size({width:'60%'})
            .position({y:20,x:125})
        }
        .width('100%')
        .height('55%')
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }){
          Row(){
            Image($r('app.media.precipitation_color'))
              .size({width:20})
            Text(this.selectCity['precipitation']+' %')
              .fontColor('#ff7daec4')
              .margin({left:5})
          }
          .padding({left:15,right:15,top:5,bottom:5})
          .borderRadius(20)
          .backgroundColor('#ffd5edf8')
          .width('20%')
          Row(){
            Image($r('app.media.humidity_color'))
              .size({width:20})
            Text(this.selectCity['humidity']+' %')
              .fontColor('#ffdb9b9b')
              .margin({left:5})
          }
          .padding({left:15,right:15,top:5,bottom:5})
          .borderRadius(20)
          .backgroundColor('#fffadede')
          .margin({left:10})
          Row(){
            Image($r('app.media.wind_color'))
              .size({width:20})
            Text(this.selectCity['wind']+' km/h')
              .fontColor('#ff9e8ab1')
              .margin({left:5})
          }
          .padding({left:15,right:15,top:5,bottom:5})
          .borderRadius(20)
          .backgroundColor('#fff1e8fa')
          .margin({left:10})
        }
        .height('10%')
        Column(){
          Text('Today')
            .position({x:-170})
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
        }
        .margin({top:5,bottom:5})
        .height('5%')
        Column() {
          //时间
          Row() {
            ForEach(this.weatherUiModel.hoursArr, (item) => {
              Text(item)
                .textAlign(TextAlign.Center)
                .layoutWeight(3)
            })
          }
          .margin({ bottom: 10 })

          // 温度折线
          if (this.weatherUiModel.hourlyTemp.length > 0) {
            Polyline({ width: this.lineWidth, height: this.lineHeight })
              .points([[0, this.weatherUiModel.pointArr[0]],
                [(this.lineWidth * 0.25).toString(), this.weatherUiModel.pointArr[1]], [(this.lineWidth * 0.5).toString(), this.weatherUiModel.pointArr[2]],
                [(this.lineWidth * 0.75).toString(), this.weatherUiModel.pointArr[3]], [(this.lineWidth * 1).toString(), this.weatherUiModel.pointArr[4]]])
              .fillOpacity(0)
              .stroke('#AAB8CA')
              .strokeWidth(1)

            Row() {
              ForEach(this.weatherUiModel.hourlyTemp, (item) => {
                Text(item.temp + '℃')
                  .textAlign(TextAlign.Center)
                  .layoutWeight(1)
              })
            }
            .margin({ top: 35 })
          }
        }
        .height('25%')
        .width('100%')
      }
      .height('58%')
      .width('100%')
      Column(){
        // 近三天
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }){
          ForEach(this.weather3d, (item:String,index:Number) => {
            Column(){
              Image(this.weatherUiModel.iconDays[index.valueOf()+1])
                .size({width:'80%',height:'40%'})
              Text(item.toString())
                .margin({top:15})
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
              Text('°c')
                .fontSize(18)
                .position({x:72,y:75})
                .fontColor('#E6000000')
                .fontWeight(FontWeight.Bold)
              Text(this.weatherUiModel.hoursArr[index.valueOf()+1])
                .fontSize(12)
                .margin({top:10})
                .fontColor('#ffa5a2a2')

            }
            .alignItems(HorizontalAlign.Center)
            .width('28%')
            .height('45%')
            .shadow({
              radius:20,
              color:'#ffb1adad',
              offsetX:15,
              offsetY:15
            })
            .borderRadius(20)
          }, item => item)
        }

        Scroll(this.scroller) {
          Column() {
            ForEach(this.weatherUiModel.dayArr, (item:string,index:number) => {
              Row(){
                Text(item.toString())
                  .padding({left:10})
                  .width('40%')
                  .height(50)
                  .backgroundColor(0xFFFFFF)
                  .borderRadius(15)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bolder)
                Image(this.weatherUiModel.iconDays[index])
                  .width('40%')
                  .size({width:'10%'})
                Text(this.tempmax7d[index]+'°c / '+this.tempmin7d[index]+'°c')
                  .width('20%')
                  .height(50)
                  .backgroundColor(0xFFFFFF)
                  .borderRadius(15)
                  .fontSize(16)
                  .margin({left:'40%'})
              }
              // .justifyContent(FlexAlign.Center)
              .width('100%')
            }, item => item)
          }.width('100%')
        }
        .margin({top:'5%'})
        .height('45%')
        .scrollable(ScrollDirection.Vertical)  // 滚动方向纵向
        // .scrollBar(BarState.On)  // 滚动条常驻显示
        .scrollBarColor(Color.Gray)  // 滚动条颜色
        .scrollBarWidth(10) // 滚动条宽度
        .edgeEffect(EdgeEffect.None)

      }
      .margin({top:10})
        .height('42%')
        .width('100%')

    }

  }
  calculatePoint() {
    if (this.weatherUiModel.hourlyTemp.length > 0) {
      for (var i = 0; i < 5; i++) {
        let tempArg = parseInt(this.weatherUiModel.hourlyTemp[0].temp)
        if (i == 0) {
          this.weatherUiModel.pointArr[i] = this.lineHeight - tempArg
        } else {
          this.weatherUiModel.pointArr[i] = this.lineHeight -
          (((parseInt(this.weatherUiModel.hourlyTemp[i].temp) - tempArg) * 3) +
          parseInt(this.weatherUiModel.hourlyTemp[i].temp))
        }
      }
    }
  }

  async aboutToAppear(){
    await this.initData()
  }

  async initData(){
    let resultNow = await getNowWeather(this.selectCity['locationId'])
    let weatherNow = resultNow.result as NowWeatherModel
    this.weatherUiModel.nowTemp = weatherNow.now.temp
    this.weatherUiModel.precip = weatherNow.now.precip
    this.weatherUiModel.nowWeatherText = weatherNow.now.text
    this.weatherUiModel.category = weatherNow.now.windDir
    // 获取24小时天气
    this.weatherUiModel.hoursArr = utils.getHoursArr()
    let result24h = await get24hWeather(this.selectCity['locationId'])
    let weather24h = result24h.result as Weather24hModel
    this.weatherUiModel.hourlyTemp = []
    this.weather3d = []
    for(let index = 0; index < 5; index++){
      this.weatherUiModel.hourlyTemp.push({temp: weather24h.hourly[index].temp})
    }
    for(let index = 0; index < 3; index++){
      this.weather3d.push(weather24h.hourly[index+1].temp)
    }
    // 获取近7日信息
    this.weatherUiModel.dayArr = utils.getDayArr()
    let result7d = await get7dWeather(this.selectCity['locationId'])
    let weather7d = result7d.result as Weather7dModel
    this.weatherUiModel.tempMax = weather7d.daily[0].tempMax
    this.weatherUiModel.tempMin = weather7d.daily[0].tempMin
    this.weatherUiModel.iconDays = []
    this.tempmax7d = []
    this.tempmin7d = []
    for(let index=0;index<5;index++){
      this.weatherUiModel.iconDays.push('Images/'+weather7d.daily[index].iconDay+'.png')
      this.tempmax7d.push(weather7d.daily[index].tempMax)
      this.tempmin7d.push(weather7d.daily[index].tempMin)
    }
    // 日期信息
    this.weatherUiModel.date = utils.getDate()
    this.weatherUiModel.day = utils.getDay()
  }
}
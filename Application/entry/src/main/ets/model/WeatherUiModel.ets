// 天气首页模型
export class WeatherUiModel {
  nowTemp; //当日气温
  nowWeatherText; //未来两小时   天气状况的文字描述，包括阴晴雨雪等天气状态的描述
  tempMax; //最高气温
  tempMin; //最低气温
  category; //空气质量
  precip; //降雨量，大于0有雨
  hourlyTemp: { temp }[]; //小时温度
  iconDays: string[]; //每日天气状况图标
  date; //日期
  day; //星期
  dayArr: string[]; //星期数组
  hoursArr: string[]; //时间数组
  pointArr: number[];//折线图数组
}
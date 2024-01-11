const weeks = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
let myDate = new Date();
let mon = myDate.getMonth() + 1;
let date = myDate.getDate();
let hours = myDate.getHours();
let day = myDate.getDay();

// 获取日期，格式：xx年xx月
const getDate = ()=>{
  return mon + "月" + date + "日"
}

const getHour = ()=>{
  if(hours<12){
    if(hours==0){
      return '12 am'
    }
    else {
      return hours.toString()+' am'
    }
  }
  else {
    return hours.toString()+' pm'
  }
}

// 获取星期几
const getDay = ()=>{
  let day = myDate.getDay();
  return weeks[day]
}

// 获取今日往后五天
const getDayArr = ()=>{
  let arr = []
  arr.push("Today", "Tomorrow", weeks[day <= 4 ? day + 2 : day - 5],
    weeks[day <= 3 ? day + 3 : day - 4], weeks[day <= 2 ? day + 4 : day - 3])
  return arr
}

// 获取时间此刻往后五小时
const getHoursArr = ()=>{
  let hoursArr = []
  for (var i = 0; i < 5; i++) {
    hoursArr.push((hours + i)%24 + ":00")
  }
  return hoursArr
}

// utils
const utils = {
  getDate,
  getDay,
  getDayArr,
  getHoursArr,
  getHour
}
export default utils
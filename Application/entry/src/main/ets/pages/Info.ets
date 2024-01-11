import router from '@ohos.router';
import { Constants } from '../common/Constants';
import { CommonActionButton } from '../components/CommonActionButton';
import { AGCAuth, AgUser } from '../services/Auth';
@Entry
@Component
struct Info {
  @StorageLink('user') currentUser: AgUser = AppStorage.Get<AgUser>('user');
  @State canLogOut: boolean = true;
  aboutToAppear() {
    this.currentUser = AppStorage.Get<AgUser>('user');
  }
  async logout() {
    this.canLogOut = false
    await new AGCAuth(getContext(this)).logout().then((res) => {
      if (res) {
        AppStorage.Set<AgUser>('user', new AgUser());
        this.canLogOut = true
      }
    })
    router.replaceUrl({url:"pages/Index"})
    router.clear()
  }

  async deleteUser() {
    this.canLogOut = false
    await new AGCAuth(getContext(this)).deleteUser().then((res) => {
      if (res) {
        AppStorage.Set<AgUser>('user', new AgUser());
        this.canLogOut = true
      }
    })
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    router.replaceUrl({url:"pages/Index"})
    router.clear()
  }
  getRandom(start, end, fixed = 0) {
    let differ = end - start
    let random = Math.random()
    return (start + differ * random).toFixed(fixed)
  }
  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      if (!this.currentUser?.getUid()) {

      } else {
        Column() {

          if (this.currentUser?.getPhotoUrl() !== null && this.currentUser?.getPhotoUrl() !== undefined && this.currentUser?.getPhotoUrl() !== '') {
            Image(this.currentUser?.getPhotoUrl().toString())
              .width(Constants.LENGTH_70_PX)
              .height(Constants.LENGTH_70_PX)
          } else {
            Image('image/header_'+String(this.getRandom(1,4))+'.png').width(80)
              .height(80)
              .borderRadius(40).margin({top:50})

            //Text('Hi, +19+13130790998').margin({top:20}).fontSize(20).fontWeight(FontWeight.Bolder).fontStyle(FontStyle.Italic)
            // Image('image/header_'+String(this.getRandom(1,8))+'.png').width(60)
            //   .height(60)
            //   .borderRadius(30)
            //   .position({x:'10%',y:'15%'})


            Text('Hi, '+this.currentUser?.getPhone()?.toString().substring(4)).margin({top:20}).fontSize(20).fontWeight(FontWeight.Bolder)//.fontStyle(FontStyle.Italic)//.fontWeight(FontWeight.Bolder)
            Text('注册时间：'+this.formatDate(this.currentUser?.getRegisterDate())).position({x:'5%',y:'75%'}).decoration({type: TextDecorationType.Underline,color:'#dfe5a4a4'}).fontStyle(FontStyle.Italic).fontColor('#dfc69b9b')
            Text('上次登录时间：'+this.formatDate(this.currentUser?.getLastLogin())).position({x:'5%',y:'85%'}).decoration({type: TextDecorationType.Underline,color:'#dfe5a4a4'}).fontStyle(FontStyle.Italic).fontColor('#dfc69b9b')




          }

          // Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          //   Text($r('app.string.auth_result_mobile_number')).fontSize($r('app.float.body_font_size'))
          //   Text(this.currentUser?.getPhone()?.toString()).fontSize($r('app.float.body_font_size'))
          // }
          // .margin({ top: Constants.LENGTH_10_PX, bottom: Constants.LENGTH_10_PX })
          //
          // Divider().color($r('app.color.placeholder_background'))
          //
          // Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          //   Text($r('app.string.auth_result_registered'))
          //     .fontSize($r('app.float.body_font_size'))
          //   if (this.currentUser?.getRegisterDate()) {
          //     Text(this.formatDate(this.currentUser?.getRegisterDate()))
          //       .fontSize($r('app.float.body_font_size'))
          //   }
          //  }
          // .margin({ top: Constants.LENGTH_10_PX, bottom: Constants.LENGTH_10_PX })
          //
          // Divider().color($r('app.color.placeholder_background'))
          //
          // Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          //   Text($r('app.string.auth_result_last_login'))
          //     .fontSize($r('app.float.body_font_size'))
          //   if (this.currentUser?.getLastLogin()) {
          //     Text(this.formatDate(this.currentUser?.getLastLogin()))
          //       .fontSize($r('app.float.body_font_size'))
          //   }
          // }
          // .margin({ top: Constants.LENGTH_10_PX, bottom: Constants.LENGTH_10_PX })
        }
        .width('100%')
        .height('50%')
        .backgroundImage('image/background_'+String(2)+'.png')
        .backgroundImageSize({ width: '100%', height: '100%'})



        Column() {
          Image('image/pho.png').position({x:'20%',y:'30%'})
          Button('注销用户')
            .width('60%')
            .margin({top:50})
            .borderRadius(20)
            .backgroundColor('#ffd79f9f')
            .enabled(this.canLogOut)
            .opacity(this.canLogOut ? 1 : 0.5)
            .height(40)
            .onClick(() => this.deleteUser())
          Button('登出账号')
            .width('60%')
            .margin({top:20})
            .borderRadius(20)
            .backgroundColor('#ffd79f9f')
            .enabled(this.canLogOut)
            .opacity(this.canLogOut ? 1 : 0.5)
            .height(40)
            .onClick(() => this.logout())

          //
          // CommonActionButton({
          //   title: $r('app.string.auth_service_delete_user_button_text'),
          //   color: $r('app.color.black'),
          //   backColor: $r('app.color.start_window_background'),
          //   borderW: Constants.LENGTH_1_PX,
          //   borderC: $r('app.color.black'),
          //   onAction: () => {
          //     this.deleteUser();
          //   },
          //   isEnabled: $canLogOut
          // }).margin({ top: Constants.LENGTH_10_PX })
          //
          // CommonActionButton({
          //   title: $r('app.string.auth_service_logout_button_text'),
          //   color: $r('app.color.black'),
          //   backColor: $r('app.color.start_window_background'),
          //   borderW: Constants.LENGTH_1_PX,
          //   borderC: $r('app.color.black'),
          //   onAction: () => {
          //     this.logout();
          //   },
          //   isEnabled: $canLogOut
          // }).margin({ top: Constants.LENGTH_10_PX })
        }.width('100%')
        .height('50%')
      }
    }
    //.height(Constants.PERCENT_90).backgroundColor('#ffecd4d4').width('100%').height('50%')
    .backgroundColor('#ffffffff')
    .height('100%')
    .width('100%')
  }
  formatDate(date: String): string {
    if (date) {
      let d = new Date(parseInt(date.toString()));

      let ymd = d
        .toISOString()
        .replace('-', '/')
        .split('T')[0]
        .replace('-', '/');

      let hours = d.getHours().toString().length < 2 ? "0" + d.getHours() : d.getHours();

      let minutes = d.getMinutes().toString().length < 2 ? "0" + d.getMinutes() : d.getMinutes();

      let seconds = d.getSeconds().toString().length < 2 ? "0" + d.getSeconds() : d.getSeconds();

      let hm = hours + ':' + minutes + ':' + seconds;

      return ymd + ' ' + hm;
    }
  }
}
import { HomeButton } from '../components/HomeButton';
import { Constants } from '../common/Constants';
import { AGCAuth, AgUser } from '../services/Auth';
import { AGConnectUser } from '@hw-agconnect/auth-ohos';
import { AuthResultView } from '../components/AuthResult';
import { AuthDialog } from '../components/AuthDialog';
import { mockData } from '../common/CountryViewModel';
import { Log } from '../common/Log';
import router from '@ohos.router';
const TAG = "[AuthPage]";


@Entry
@Component
struct Index {
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AuthDialog(),
    autoCancel: true,
  });
  @StorageLink('user') currentUser: AgUser = new AgUser();
  @State agcUser: AGConnectUser = null;
  @State countryCode: string = '+86';
  @State phoneNumber: string = '';
  @State verificationCode: string = '';
  @State intervalId: number = -123456;
  @State timer: number = 60;
  @State canLogin: boolean = true;

  agcAuth: AGCAuth;
  controller: CustomDialogController;

  async aboutToAppear() {
    this.agcAuth = new AGCAuth(getContext(this))
    // 杀掉进程重启情况
    this.agcUser = await this.agcAuth.getCurrentUser();
    // this.agcAuth = new AGCAuth(getContext(this))
    if (this.agcUser) {
      let agcUserExtra = await this.agcUser.getUserExtra();
      this.currentUser = new AgUser(
      this.agcUser.getUid(),
      this.agcUser.getPhotoUrl(),
      this.agcUser.getPhone(),
      this.agcUser.getDisplayName(),
      agcUserExtra.getCreateTime(),
      agcUserExtra.getLastSignInTime());
      AppStorage.Set<AgUser>('user', this.currentUser);
    }
  }

  canAuthorize(): boolean {
    return this.countryCode !== '' && this.phoneNumber !== '' && this.verificationCode !== '';
  }

  canGetCode(): boolean {
    return this.phoneNumber.length > 5 && this.phoneNumber.length <= 20;
  }

  startTimer(): void {
    this.timer = 60;
    this.intervalId = setInterval(() => {
      this.timer--;
      if (this.timer === 0) {
        clearInterval(this.intervalId);
        this.timer = 60;
      }
    }, 1000);
  }

  async onGetCodeButtonClicked() {
    if (this.phoneNumber !== '' && this.timer === 60) {
      this.startTimer();
      this.agcAuth.requestPhoneVerifyCode(this.countryCode, this.phoneNumber);
    }
  }

  onAuthButtonClicked() {
    this.canLogin = false;
    this.agcAuth.login(this.countryCode, this.phoneNumber, this.verificationCode).then(user => {
      AppStorage.Set<AgUser>('user', user);
      this.canLogin = true;
      router.replaceUrl(
        { url:"pages/Weather",
          params:{
            userId:this.currentUser.uid,
            phoneNumber:this.currentUser.phone
          }
        })
    }).catch((err) => {
      this.canLogin = true;
      Log.error(TAG, "Logged in failed " + JSON.stringify(err));
      AlertDialog.show({
        title: $r('app.string.common_prompt'),
        message: $r('app.string.common_login_fail'),
      });
    });
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }){
      Column(){

      }
      .height('30%')
      .width('100%')
      Column(){
        Text("Welcome Home")
          .fontSize(35)
          .fontColor('#ffeaa692')
          .fontWeight(FontWeight.Bold)
          .margin({top:20})
        Text("Login to your account")
          .margin({top:10})
          .fontColor("#ffa5a2a2")

        Flex({ direction: FlexDirection.Row }) {

          Select(mockData)
            .font({ size: $r('app.float.body_font_size') })
            .selectedOptionFont({ size: $r('app.float.body_font_size') })
            .optionFont({ size: $r('app.float.body_font_size') })
            .value(this.countryCode)
            .layoutWeight(Constants.LENGTH_1_PX)
            .backgroundColor($r('app.color.placeholder_background'))
            .borderRadius(20)
            .height(50)
            .onSelect((_, val) => {
              this.countryCode = val.substring(0, val.length - 4);
            })



          TextInput({ placeholder: $r('app.string.auth_dialog_number_placeholder') })
            .layoutWeight(Constants.LENGTH_3_PX)
            .margin({ left: Constants.LENGTH_5_PX })
            .borderRadius(20)
            .maxLength(Constants.LENGTH_20_PX)
            .height(50)
            .enabled(this.timer === 60)
            .onChange((val) => {
              this.phoneNumber = val;
            })
            .placeholderColor('#ffeaa692')
            .backgroundColor('#fffcf5f5')

        }
        .margin({ top:40 })
        .width("90%")

        Flex({ direction: FlexDirection.Row }) {
          TextInput({ placeholder: $r('app.string.auth_dialog_code_placeholder'), text: this.verificationCode })
            .layoutWeight(Constants.LENGTH_3_PX)
            .margin({ right: Constants.LENGTH_5_PX })
            .borderRadius(20)
            .maxLength(Constants.LENGTH_6_PX)
            .height(50)
            .onChange((val) => {
              this.verificationCode = val;
            })
            .placeholderColor('#ffeaa692')
            .backgroundColor('#fffcf5f5')

          Button(this.timer === 60 ? $r('app.string.auth_dialog_get_code_button_text') : this.timer.toString(), {
            type: ButtonType.Normal
          })
            .backgroundColor('#ffd79f9f')
            .layoutWeight(Constants.LENGTH_2_PX)
            .borderColor('#ffffff')
            .borderWidth(Constants.LENGTH_1_PX)
            .fontColor('#ffffff')
            .borderRadius(20)
            .margin({ left: Constants.LENGTH_5_PX })
            .height(50)
            .enabled(this.canGetCode() && this.timer === 60)
            .onClick(() => this.onGetCodeButtonClicked())
        }
        .margin({ top:20 })
        .width("90%")
        Button('登录', { type: ButtonType.Normal })
          .width('80%')
          .margin({top:100})
          .borderRadius(20)
          .backgroundColor('#ffd79f9f')
          .enabled(this.canAuthorize() && this.verificationCode.length > 5 && this.canLogin)
          .opacity(this.canLogin ? 1 : 0.5)
          .height(40)
          .onClick(() => this.onAuthButtonClicked())

      }
      .backgroundColor('#ffffff')
      .height("70%")
      .width('100%')
      // .border({style:})
      // .padding({left:10,right:10})
      .borderRadius(40)
      .shadow({
        radius:20,
        color:'#ff665a5a',
        offsetX:-15,
        offsetY:-15

      })
      .margin({top:10})

    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.background2'))
  }

}
import { LoginApi, ResManager, UserStore } from '@hm/basic/Index';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { Log } from '@abner/log';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct LoginPage {
  // 登录方法
  login() {
    // 创建授权请求，并设置参数
    let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    // 获取手机号需要传如下scope，传参数之前需要先申请对应scope权限,才能返回对应数据
    authRequest.scopes = ['phone'];
    // 获取code需传如下permission
    authRequest.permissions = ['serviceauthcode'];
    // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    authRequest.forceAuthorization = true;
    // 用于防跨站点请求伪造，非空字符串即可
    authRequest.state = util.generateRandomUUID();
    // 执行请求
    try {
      let controller = new authentication.AuthenticationController(getContext(this));
      controller.executeRequest(authRequest, async (err, data) => {
        if (err) {
          Log.error('auth fail,error: %{public}s' + JSON.stringify(err));
          return;
        }
        let authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
        let state = authorizationWithHuaweiIDResponse.state;
        if (state != undefined && authRequest.state != state) {
          Log.error('auth fail,The state is different: %{public}s' +
          JSON.stringify(authorizationWithHuaweiIDResponse));
          return;
        }
        Log.debug('auth success: %{public}s' +
        JSON.stringify(authorizationWithHuaweiIDResponse));
        let authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse.data!;
        let code = authorizationWithHuaweiIDCredential.authorizationCode;
        // 开发者处理code=> 获取一键登录的授权 code=>调用后台 api =》获取 token
        Log.warn(`华为授权码：${code}`)
        const token = await LoginApi({
          code: code!,
          clientId: '111308027',
          clientSecret: 'ff5ef45fb7a9ab815c1d1120f57c2d76ebedd370fb0f120489c4d7dc326823cd'
        })
        console.info('mix', token)
        // 持久化
        await UserStore.setUser({ token })
        router.replaceUrl({
          url: 'pages/Index'
        })
      });
    } catch (error) {
      Log.error('auth failed: %{public}s' + JSON.stringify(error));
    }
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        // app 信息
        Column() {
          Image($r("app.media.pic_login_icon"))
            .width(124)
            .height(76)
            .margin({ bottom: 20 })
          Text() {
            Span('翼康养老')
              .fontColor('#000')
              .fontSize(24)
              .fontWeight(700)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#fff')

        Button({ stateEffect: true }) {
          Row({ space: 6.5 }) {
            Image(ResManager.IC_HUAWEI)
              .width(24)
              .aspectRatio(1)
            Text('华为登录')
              .fontColor('#fff')
              .fontWeight(500)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
          }
        }
        .margin({ top: 150 })
        .width(250)
        .height(40)
        .backgroundColor(ResManager.EC_MAIN_COLOR)
        .onClick(() => {
          this.login()
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}
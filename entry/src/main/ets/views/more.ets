import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct More {
  login = () => {
    // 创建登录请求，并设置参数
    const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    // false表示当用户未登录华为账号时，不会拉起华为账号登录界面；直接返回1001502001错误码。
    loginRequest.forceLogin = false;
    // 用于防跨站点请求伪造。
    loginRequest.state = util.generateRandomUUID();

    // 执行登录请求
    try {
      const controller = new authentication.AuthenticationController();
      controller.executeRequest(loginRequest).then((response: authentication.LoginWithHuaweiIDResponse) => {
        const loginWithHuaweiIDResponse = response as authentication.LoginWithHuaweiIDResponse;
        const state = loginWithHuaweiIDResponse.state;
        if (state != undefined && loginRequest.state != state) {
          hilog.error(0x0000, 'testTag', `Failed to login. The state is different, response state: ${state}`);
          return;
        }
        hilog.info(0x0000, 'testTag', 'Succeeded in logging in.');
        const loginWithHuaweiIDCredential = loginWithHuaweiIDResponse.data!;
        if (loginWithHuaweiIDCredential) {
          const code = loginWithHuaweiIDCredential.authorizationCode;
          const idToken = loginWithHuaweiIDCredential.idToken;
          const openID = loginWithHuaweiIDCredential.openID;
          const unionID = loginWithHuaweiIDCredential.unionID;
          // 开发者处理code, idToken, openID, unionID
        }
      }).catch((error: BusinessError) => {
        this.dealAllError(error);
      })
    } catch (error) {
      this.dealAllError(error);
    }
  }

  // 错误处理
  dealAllError(error: BusinessError): void {
    hilog.error(0x0000, 'testTag', 'Failed to login, errorCode=%{public}d, errorMsg=%{public}s', error.code,
      error.message);
  }

  build() {
    Scroll() {
      Column({space: 8}) {
        Row() {
          Image($r('app.media.tab_home_active'))
            .height('256px')
        }
        Row() {
          Text('运动健康转换工具').fontSize(24).fontWeight(24)
        }
        Row() {
          Text('v1.0.0')
        }
        Row() {
          Text('任何使用反馈、功能建议或咨询问题均可前往官网留言或者发送邮件')
            .lineHeight(20)
        }
        Row() {
          Text('官网地址：https//www.FitConverter.com')
        }
        Row() {
          Text('联系邮箱：JustNotify@qq.com')
        }

        Button('登录').onClick(this.login)
      }
    }
    .padding(16)
  }
}
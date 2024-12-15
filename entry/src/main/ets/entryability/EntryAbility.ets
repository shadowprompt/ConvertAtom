import { AbilityConstant, Want } from '@kit.AbilityKit';
import { authentication } from '@kit.AccountKit';
import { pushService } from '@kit.PushKit';
import { util } from '@kit.ArkTS';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import hiAppEvent from '@ohos.hiviewdfx.hiAppEvent';
import EmbeddableUIAbility from '@ohos.app.ability.EmbeddableUIAbility';
import { BusinessError } from '@kit.BasicServicesKit';


export default class EntryAbility extends EmbeddableUIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    this.addEventWatcher();
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });

    this.getOpenId();
    this.getPushToken();
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  addEventWatcher() {
    hiAppEvent.addWatcher({
      // 开发者可以自定义观察者名称，系统会使用名称来标识不同的观察者
      name: "clickWatcher",
      // 开发者可以订阅感兴趣的应用事件，此处是订阅了按钮事件
      appEventFilters: [{ domain: "button" }],
      // 开发者可以设置订阅回调触发的条件，此处是设置为事件打点数量满足1个
      triggerCondition: { row: 1 },
      // 开发者可以自行实现订阅回调函数，以便对订阅获取到的事件打点数据进行自定义处理
      onTrigger: (curRow: number, curSize: number, holder: hiAppEvent.AppEventPackageHolder) => {
        // 返回的holder对象为null，表示订阅过程发生异常，因此在记录错误日志后直接返回
        if (holder == null) {
          hilog.error(0x0000, 'testTag', "HiAppEvent holder is null");
          return;
        }
        hilog.info(0x0000, 'testTag', `HiAppEvent onTrigger: curRow=%{public}d, curSize=%{public}d`, curRow, curSize);
        let eventPkg: hiAppEvent.AppEventPackage | null = null;
        // 根据设置阈值大小（默认为512KB）去获取订阅事件包，直到将订阅数据全部取出
        // 返回的事件包对象为null，表示当前订阅数据已被全部取出，此次订阅回调触发结束
        while ((eventPkg = holder.takeNext()) != null) {
          // 开发者可以对事件包中的事件打点数据进行自定义处理，此处是将事件打点数据打印在日志中
          hilog.info(0x0000, 'testTag', `HiAppEvent eventPkg.packageId=%{public}d`, eventPkg.packageId);
          hilog.info(0x0000, 'testTag', `HiAppEvent eventPkg.row=%{public}d`, eventPkg.row);
          hilog.info(0x0000, 'testTag', `HiAppEvent eventPkg.size=%{public}d`, eventPkg.size);
          for (const eventInfo of eventPkg.data) {
            hilog.info(0x0000, 'testTag', `HiAppEvent eventPkg.info=%{public}s`, eventInfo);
          }
        }
      }
    });
  }

  getOpenId = () => {
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

        globalThis.loginWithHuaweiIDCredential = loginWithHuaweiIDCredential;
        if (loginWithHuaweiIDCredential) {
          hilog.info(0x0000, 'testTag', 'Succeeded getting loginWithHuaweiIDCredential', loginWithHuaweiIDCredential);
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

  getPushToken = async () => {
    try {
      const pushToken: string = await pushService.getToken();
      hilog.info(0x0000, 'testTag', 'Succeeded in getting push token', pushToken);

      globalThis.pushToken = pushToken;
    } catch (err) {
      this.dealAllError(err);
    }
  }

  // 错误处理
  dealAllError(error: BusinessError): void {
    hilog.error(0x0000, 'testTag', 'Failed to login, errorCode=%{public}d, errorMsg=%{public}s', error.code,
      error.message);
  }
}

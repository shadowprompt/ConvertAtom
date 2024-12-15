import { ConvertItemType, ConvertSelected, RequestResult } from "../utils/interface"
import { CONVERT_DESTINATIONS, CONVERT_TYPES, URL_CONVERT_TYPES } from "../../ets/constants/Constants"
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction, UIContext } from '@kit.ArkUI'
import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import http from '@ohos.net.http';

let preferencesOptions: preferences.Options = { name: 'myStore' };


class MyRadioStyle implements ContentModifier<RadioConfiguration> {
  radioItem: ConvertItemType
  defaultType: string;
  group: string;
  callback: Function

  constructor(radioItem: ConvertItemType, group: string, defaultType: string, callback: Function) {
    this.radioItem = radioItem
    this.group = group
    this.defaultType = defaultType
    this.callback = callback
  }

  applyContent(): WrappedBuilder<[RadioConfiguration]> {
    return wrapBuilder(buildRadio)
  }
}

@Builder
function buildRadio(config: RadioConfiguration) {
  Row() {
    Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      Radio({ value: (config.contentModifier as MyRadioStyle).radioItem.type, group: (config.contentModifier as MyRadioStyle).group,
        indicatorType:RadioIndicatorType.TICK
      })
        .checked((config.contentModifier as MyRadioStyle).radioItem.type === (config.contentModifier as MyRadioStyle).defaultType ? true : false)
        .height(24)
        .width(20)
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            const myRadioStyle = config.contentModifier as MyRadioStyle
            myRadioStyle.callback(myRadioStyle.radioItem.type)
          }
        })
      Text((config.contentModifier as MyRadioStyle).radioItem.text)
    }
  }
}

@Component
export struct Convert {
  @State type: string = 'huawei'
  @State url: string = ''
  @State destination: string = 'coros'
  @State address: string = ''
  addressController: TextInputController = new TextInputController()

  aboutToAppear() {
    const dataPreferences = this.getDataPreferences();
    if (dataPreferences) {
      this.address =  dataPreferences.getSync('address', '').toString();
    }
  }

  // 选择指定类型的压缩包介绍
  @Builder
  targetTypeIntroduceRender(convertItem: ConvertItemType | undefined) {
    if (convertItem) {
      Column({space: 8}) {
        if (convertItem.fileList) {
          ForEach(convertItem.fileList, (item: string) => {
            Row() {
              Text(item)
                .width('100%')
                .fontSize(12)
                .fontWeight(600)
            }
          })
        }
        if (convertItem.fileImgUrl) {
          Row() {
            Image(convertItem.fileImgUrl)
              .width('100%')
          }
        }
      }
      .margin({
        top: 8
      })
    }
  }

  // 传入对象才会触发UI渲染
  @Builder
  typeIntroduceRender(convertSelected: ConvertSelected) {
    if (URL_CONVERT_TYPES.includes(convertSelected.type)) {
      Row() {
        Text('待上传压缩包说明')
          .fontSize(16)
          .width('100%')
          .lineHeight(24)
          .fontColor('#666666')
      }
      .margin({
        top: 16
      })

      Row() {
        Text('将官网导出数据解压（可能需要密码）后将以下文件放至一个文件夹内，打包成zip格式压缩包')
      }.width('100%')

      if (convertSelected.type === 'huawei') {
        this.targetTypeIntroduceRender(CONVERT_TYPES.find(item => item.type === 'huawei'))
      } else if (convertSelected.type === 'zepp') {
        this.targetTypeIntroduceRender(CONVERT_TYPES.find(item => item.type === 'zepp'))
      } else if (convertSelected.type === 'xiaomi') {
        this.targetTypeIntroduceRender(CONVERT_TYPES.find(item => item.type === 'xiaomi'))
      } else if (convertSelected.type === 'keep') {
        this.targetTypeIntroduceRender(CONVERT_TYPES.find(item => item.type === 'keep'))
      }
    }
  }

  // 新平台
  @Builder
  typeDestinationRender(convertSelected: ConvertSelected) {

  }
  // 生成的url
  @Builder
  typeUrlRender(convertSelected: ConvertSelected) {
    if (URL_CONVERT_TYPES.includes(convertSelected.type)) {
      Row() {
        Text('2.填写压缩包url')
          .fontSize(16)
          .width('100%')
          .lineHeight(24)
          .fontWeight(600)
      }
      .margin({
        top: 16
      })

      Row() {
        TextInput({
          text: this.url,
          placeholder: '粘贴运动健康转换工具官网生成的url',
        }).onChange((value) => {
          this.url = value;
        }).placeholderColor(Color.Grey)
      }
      .margin(
        {
          top: 8,
          bottom: 8,
        }
      )
      Column({space: 4}) {
        Text('目前本应用还不支持上传文件（努力研究中），请移步至官网上传zip压缩包生成url').fontSize(14)
        Image('https://wp-img.daozhao.com/fitconverter/20241214113002.png')
      }
    } else {
      Row() {
        Text('2.说明')
          .fontSize(16)
          .width('100%')
          .lineHeight(24)
          .fontWeight(600)
      }
      .margin({
        top: 16
      })

      Row() {
        Text('模拟登录相比官方导出数据拥有更多数据细节，转换效果更好！')
          .width('100%')
      }
      .margin(
        {
          top: 8,
          bottom: 8,
        }
      )
      Row() {
        Text('本应用暂不支持此类转换，请移步至运动健康转换工具官网（https://www.fitconverter.com）申请转换')
          .width('100%')
      }
      .margin(
        {
          top: 8,
          bottom: 8,
        }
      )
    }

    if (URL_CONVERT_TYPES.includes(convertSelected.type)) {
      Row() {
        Text('3.邮箱地址')
          .width('100%')
          .fontWeight(600)
      }
      .margin({
        top: 16
      })

      Row() {
        Column(){
          TextInput({
            text: this.address,
            placeholder: '转换结果将以邮件形式通知',
            // controller: this.addressController
          }).onChange((value) => {
            this.address = value;
          }).placeholderColor(Color.Grey)
        }
      }
      .margin(
        {
          top: 8,
          bottom: 8,
        }
      )
    }
  }

  resetInput() {
    this.url = ''
  }

  getDataPreferences = () => {
    const context = getContext(this) as common.UIAbilityContext;;
    return preferences.getPreferencesSync(context, preferencesOptions);
  }

  saveData =  () => {
    const dataPreferences = this.getDataPreferences();
    if (dataPreferences) {
      dataPreferences.putSync('address', this.address);
    }
  }

  afterRequestSuccess = () => {
    this.saveData();
    this.resetInput();
  }
  // 上传url
  uploadRequest = () => {
    const httpRequest = http.createHttp();

    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      "https://www.fitconverter.com/api/convertWebInvoke",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        },
        // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
        extraData: {
          type: this.type,
          destination: this.destination,
          url: this.url,
          address: this.address,
        },
        expectDataType: http.HttpDataType.STRING, // 可选，指定返回数据的类型
      }, (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          // data.result为HTTP响应内容，可根据业务需要进行解析
          console.info('Result:' + JSON.stringify(data.result));
          console.info('code:' + JSON.stringify(data.responseCode));
          // data.header为HTTP响应头，可根据业务需要进行解析
          console.info('header:' + JSON.stringify(data.header));
          console.info('cookies:' + JSON.stringify(data.cookies)); // 8+
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
          const jsonData: RequestResult = JSON.parse(data.result + "");

          if (jsonData.code === 1) {
            promptAction.showToast({
              message: '提交成功，转换结果随后将以邮件形式通知',
              duration: 2000
            });
            this.afterRequestSuccess();
          } else {
            promptAction.showToast({
              message: '提交失败',
              duration: 2000
            });
          }

        } else {
          console.error('error:' + JSON.stringify(err));
          // 取消订阅HTTP响应头事件
          httpRequest.off('headersReceive');
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
          promptAction.showToast({
            message: '其它异常',
            duration: 2000
          });
        }
      }
    );
  }

  onTypeChange = (value: string) => {
    this.type = value
    console.log('selected type is', this.type)
  }

  onDestinationChange = (value: string) => {
    this.destination = value
    console.log('selected destination is', this.destination)
  }

  build() {
    Scroll(){
      Column() {
        Row() {
          Text($r('app.string.convert_step_1_text'))
            .fontSize(16)
            .width('100%')
            .lineHeight(24)
        }
        .margin({
          top: 16
        })
        .padding(8)

        Flex({
          wrap: FlexWrap.Wrap
        }){
          ForEach(CONVERT_TYPES, (convertItem: ConvertItemType) => {
            Row() {
              Radio({ value: convertItem.type, group: 'type' })
                .contentModifier(new MyRadioStyle(convertItem, 'type', 'huawei', this.onTypeChange))
                .checked(false)
            }.width(convertItem.width)
          })
        }

        this.typeIntroduceRender({
          type: this.type
        })

        this.typeUrlRender({
          type: this.type
        })

        if (URL_CONVERT_TYPES.includes(this.type)) {
          Row() {
            Text('4.导入平台')
              .width('100%')
              .fontWeight(600)
          }
          .margin({
            top: 16
          })

          Flex({
            wrap: FlexWrap.Wrap
          }){
            ForEach(CONVERT_DESTINATIONS, (convertItem: ConvertItemType) => {
              Row() {
                Radio({ value: convertItem.type, group: 'destination' })
                  .contentModifier(new MyRadioStyle(convertItem, 'destination', 'coros', this.onDestinationChange))
                  .checked(false)
              }.width(convertItem.width)
            })
          }

          Row() {
            Button('开始转换')
              .enabled(this.url && this.address ? true: false)
              .onClick(() => {
              this.uploadRequest();
            })
          }.margin({
            top: 16
          })
        }
      }
    }
    .padding(16)
  }
}
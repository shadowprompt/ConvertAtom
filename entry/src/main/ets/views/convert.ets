import { ConvertItemType, ConvertSelected } from "../utils/interface"
import { CONVERT_TYPES, URL_CONVERT_TYPES } from "../../ets/constants/Constants"
import { BusinessError } from '@kit.BasicServicesKit';
import http from '@ohos.net.http';

class MyRadioStyle implements ContentModifier<RadioConfiguration> {
  type: string
  text: ResourceStr = ''
  selectedColor: ResourceColor = Color.Black
  callback: Function

  constructor(type: string, text: ResourceStr, callback: Function, colorType: ResourceColor) {
    this.type = type
    this.text = text
    this.selectedColor = colorType
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
      Radio({ value: 'Radio1', group: 'radioGroup',
        indicatorType:RadioIndicatorType.TICK
      }).checked((config.contentModifier as MyRadioStyle).type === 'huawei' ? true : false)
        .height(24)
        .width(20)
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            const myRadioStyle = config.contentModifier as MyRadioStyle
            myRadioStyle.callback(myRadioStyle.type)
          }
        })
      Text((config.contentModifier as MyRadioStyle).text)
    }
  }
}

@Component
export struct Convert {
  @State type: string = 'huawei'
  @State url: string = ''
  @State address: string = ''
  addressController: TextInputController = new TextInputController()

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
    }

    if (convertSelected.type === 'huawei') {
      Column({space: 8}) {
        Row() {
          Text('将官网导出数据解压（可能需要密码）后将以下文件')
        }.width('100%')
        Row() {
          Text('Motion path detail data & description/motion path detail data.json').fontWeight(800)
        }.width('100%')
        Row() {
          Text('放至一个文件夹内，打包成zip格式压缩包')
        }.width('100%')
      }
      .margin(
        {
          top: 8,
          bottom: 8,
        }
      )

      Row() {
        Image('https://wp-img.daozhao.com/fitconverter/zip-intro-huawei.png')
          .width('100%')
      }
    } else {
      Text(convertSelected.type)
    }
  }
  // 传入对象才会触发UI渲染
  @Builder
  typeConvertRender(convertSelected: ConvertSelected) {
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

      Row() {
        Button('开始转换').onClick(() => {
          this.uploadRequest();
        })
      }.margin({
        top: 16
      })
    }
  }
  // 上传url
  uploadRequest = () => {
    const httpRequest = http.createHttp();

    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      "http://127.0.0.1:3000/api/convertWebInvoke",
      {
        method: http.RequestMethod.POST, // 可选，默认为http.RequestMethod.GET
        // 开发者根据自身业务需要添加header字段
        header: {
          'Content-Type': 'application/json'
        },
        // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
        extraData: {
          url: "aabc"
        },
        expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
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
        } else {
          console.error('error:' + JSON.stringify(err));
          // 取消订阅HTTP响应头事件
          httpRequest.off('headersReceive');
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
        }
      }
    );
  }

  onTypeChange = (type: string) => {
    this.type = type
    console.log('selected type is', this.type)
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
              Radio({ value: convertItem.type, group: 'radioGroup' })
                .contentModifier(new MyRadioStyle(convertItem.type, convertItem.text,this.onTypeChange, '#004AAF'))
                .checked(false)
            }.width(convertItem.width)
          })
        }

        this.typeIntroduceRender({
          type: this.type
        })

        this.typeConvertRender({
          type: this.type
        })
      }
    }
  }
}
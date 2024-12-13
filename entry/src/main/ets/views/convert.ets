import { ConvertItemType, ConvertSelected, genConvertTypes } from "../utils"
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { picker } from "@kit.CoreFileKit"
import http from '@ohos.net.http';
import fs from '@ohos.file.fs';
import { uri } from "@kit.ArkTS";
import request from '@ohos.request';

const HEADER: Record<string, string> = { 'Content-Type': 'multipart/form-data' };

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
      Text((config.contentModifier as MyRadioStyle).text)
      Radio({ value: 'Radio1', group: 'radioGroup',
        indicatorType:RadioIndicatorType.TICK
      }).checked(false)
        .height(30)
        .width(20)
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            const myRadioStyle = config.contentModifier as MyRadioStyle
            myRadioStyle.callback(myRadioStyle.type)
          }
        })
    }
  }
}

@Component
export struct Convert {
  @State type: string = ''

  // 传入应用才会触发UI渲染
  @Builder
  typeIntroduceRender(convertSelected: ConvertSelected) {
    if (convertSelected.type === 'huawei') {
      Row() {
        Text('将华为官网导出数据解压（可能需要密码）至文件夹\n' +
          '\n' +
          '将该文件夹中的以下文件\n' +
          '\n' +
          'Motion path detail data & description/motion path detail data.json\n' +
          '\n' +
          '放至一个文件夹内，打包成zip压缩包上传')
      }
      Row() {
        Image('https://wp-img.daozhao.com/fitconverter/zip-intro-huawei.png')
          .width('100%')
      }
    } else {
      Text(convertSelected.type)
    }
  }
  // 上传url
  uploadRequest() {
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
  // 上传文件 此路不通。。。
  uploadFile(dataUri: string) {
    const context = globalThis.getContext() as common.UIAbilityContext
    let cacheDir = context.cacheDir;

    // let file = fs.openSync(dataUri, fs.OpenMode.CREATE);

    const newDataUri = cacheDir + '/test.txt'
    let file = fs.openSync(newDataUri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, 'upload file test by API9');
    fs.closeSync(file);
    // 复制文件到缓存目录下
    // fs.copyFileSync(file.fd, newDataUri);
    const result =  new uri.URI(newDataUri);




    console.info('path', result.path)
    let attachments: Array<request.agent.FormItem> = [{
      name: "test",
      value: [
        {
          filename: "test.txt",
          mimeType: 'application/octet-stream',
          path: result.path,
        },
      ]
    }];

    let config: request.agent.Config = {
      // headers: HEADER,
      action: request.agent.Action.UPLOAD,
      url: 'http://127.0.0.1:7788',
      // mode: request.agent.Mode.FOREGROUND,
      // overwrite: true,
      // method: "POST",
      data: attachments,
      // saveas: "./"
    };

    request.agent.create(context, config).then((task: request.agent.Task) => {
      task.start((err: BusinessError) => {
        if (err) {
          console.error(`Failed to start the upload task, Code: ${err.code}  message: ${err.message}`);
          return;
        }
      });
      task.on('progress', async(progress) => {
        console.warn(`/Request upload status ${progress.state}, uploaded ${progress.processed}`);
      })
      task.on('completed', async() => {
        console.warn(`/Request upload completed`);
      })
    }).catch((err: BusinessError) => {
      console.error(`Failed to create a upload task, Code: ${err.code}, message: ${err.message}`);
    });

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

        Flex({direction: FlexDirection.Column}) {
          ForEach(genConvertTypes(), (convertItem: ConvertItemType, index: number) => {
            Radio({ value: convertItem.type, group: 'radioGroup' })
              .contentModifier(new MyRadioStyle(convertItem.type, convertItem.text, (type: string) => {
                this.type = type
                console.log('selected type is', this.type)
              }, '#004AAF'))
              .checked(false)
          })
        }

        Row() {
          Text('待上传压缩包说明')
            .fontSize(16)
            .width('100%')
            .lineHeight(24)

        }
        .margin({
          top: 16
        })
        .padding(8)

        this.typeIntroduceRender({
          type: this.type
        })


        Row() {
          Button('上传文件').onClick(() => {
            let documentPicker = new picker.DocumentViewPicker();
            let documentSelectOptions = new picker.DocumentSelectOptions();

            this.uploadRequest();

            // this.uploadFile('abc')

            // documentPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
            //   console.info('DocumentViewPicker.select successfully, documentSelectResult uri: ' + JSON.stringify(documentSelectResult));
            //   this.uploadFile(documentSelectResult[0])
            // }).catch((err: BusinessError) => {
            //   console.error('DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
            // });
          })
        }

      }
    }
    // .backgroundColor('#ff0000')
  }
}
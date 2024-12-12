import { ConvertItemType, ConvertSelected, genConvertTypes } from "../utils"
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { picker } from "@kit.CoreFileKit"

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

            documentPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
              console.info('DocumentViewPicker.select successfully, documentSelectResult uri: ' + JSON.stringify(documentSelectResult));
            }).catch((err: BusinessError) => {
              console.error('DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
            });
          })
        }

      }
    }
    // .backgroundColor('#ff0000')
  }
}
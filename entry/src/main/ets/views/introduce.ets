import { PREVIEW_TYPES } from "../constants/Constants"
import { PreviewItemType } from "../utils/interface"

@Component
export struct Introduce {
  build() {
    Scroll(){
      Column() {
        Row() {
          Text($r('app.string.description'))
            .fontSize(16)
            .width('100%')
            .lineHeight(24)
            .textIndent(32)
        }
        .backgroundColor('#f9f9f9')
        .margin({
          top: 16
        })
        .padding(8)

        Row() {
          Image('https://wp-img.daozhao.com/fitconverter/tool-intro.png')
            .width('100%')
        }

        Row() {
          Text($r('app.string.app_preface'))
            .fontSize(20)
            .fontWeight(600)
        }
        .margin({
          top: 16
        })
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row() {
          Text($r('app.string.app_preface_text'))
            .fontSize(16)
            .textIndent(32)
            .lineHeight(24)
        }
        .margin(
          {
            top: 8,
            bottom: 8,
          }
        )
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row() {
          Text('转换效果预览')
            .width('100%')
            .fontWeight(600)
        }.margin({
          top: 16
        })

        ForEach(PREVIEW_TYPES, (previewItem: PreviewItemType) => {
          Row() {
            Text(previewItem.text + '导入高驰效果')
          }
          .margin({
            top: 8,
          })

          Row() {
            Image(previewItem.url)
              .width('100%')
          }
          .margin({
            top: 8,
          })
        })
      }
    }
  }
}
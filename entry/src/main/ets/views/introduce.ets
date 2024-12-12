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
            .fontWeight(500)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row() {
          Text($r('app.string.app_preface_text'))
            .fontSize(16)
            .textIndent(32)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
    }
    // .backgroundColor('#ffffff')
  }
}

@Component
export struct More {
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
      }
    }
    .padding(16)
  }
}
import { PREVIEW_TYPES } from "../constants/Constants"
import { PreviewItemType } from "../utils/interface"

@Component
export struct Discovery {
  build() {
    Scroll(){
      Column({space: 8}) {
        Row() {
          Text('转换结果说明').width('100%').fontWeight(600)
        }
        Row() {
          Text('转换成功后您会收到一封来自JustNotify@qq.com的邮件，该邮件会告知获取转换结果zip包的方式（具体以邮件内容或转换结果说明为准）。')
            .fontSize(16)
            .width('100%')
            .lineHeight(24)
        }
        Row() {
          Text('转换结果zip包内含有转换后的fit和tcx格式数据，每条运动记录对应一个文件。').width('100%')
        }

        Column({ space: 4 }) {
          Text('转换结果zip包结构').width('100%').fontWeight(600).fontSize(14)
          Row() {
            Text('一般会包含两个zip包，一个里面是fit格式（推荐使用）文件，另一个是tcx格式的。')
              .width('100%')
              .fontSize(14)
              .lineHeight(20)
          }
          Row() {
            Text('zip包解压后同一个文件夹内是同种运动类型的运动记录，每条运动记录对应一个文件，文件名中包含运动的开始时间。')
              .width('100%')
              .fontSize(14)
              .lineHeight(20)
          }
        }
        .margin({
          top: 8,
          bottom: 8
        })

        Divider().strokeWidth(8).color('#F1F3F5')

        Row() {
          Text('运动类型文件夹命名规则说明').width('100%').fontWeight(600)
        }

        Row() {
          Image('https://www.fitconverter.com/type-intro.png')
            .width('100%')
        }

        Row(){
          Text('华为、小米运动记录、tcx文件、fit文件中对本条运动记录是属于何种类型（跑步，步行，椭圆机？）的字段标识大多不一致，网上也没有文档可查询，运动类型全靠本人的摸索和搜集，对于一些小众运动（比如爬楼、羽毛球等）等信息更少，对于不知道在转换结果里面应该标成什么运动类型的，都会被标成通用的类型（比如综合运动、自由活动），这可能会与原记录中的运动类型不同，请知悉。')
            .fontSize(14)
            .lineHeight(20)
        }
      }
    }
    .padding(16)
  }
}
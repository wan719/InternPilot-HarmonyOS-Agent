import { HOME_CAPABILITIES, HOME_SUBTITLE, HOME_TITLE } from '../model/HomeContent';

@Entry
@Component
struct Index {
  @State hasStarted: boolean = false;

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Column({ space: 10 }) {
          Text(HOME_TITLE)
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor('#111827')
            .textAlign(TextAlign.Center)

          Text(HOME_SUBTITLE)
            .fontSize(16)
            .fontColor('#4B5563')
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .margin({ top: 48, bottom: 8 })

        Column({ space: 12 }) {
          ForEach(HOME_CAPABILITIES, (capability: string) => {
            Row() {
              Text(capability)
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor('#1F2937')
            }
            .width('100%')
            .padding(18)
            .borderRadius(12)
            .backgroundColor('#FFFFFF')
            .shadow({
              radius: 10,
              color: '#14000000',
              offsetX: 0,
              offsetY: 4
            })
          }, (capability: string) => capability)
        }
        .width('100%')

        Button('开始分析岗位')
          .width('100%')
          .height(48)
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .backgroundColor('#2563EB')
          .onClick(() => {
            this.hasStarted = true;
          })

        if (this.hasStarted) {
          Column({ space: 8 }) {
            Text('岗位分析占位页')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111827')

            Text('下一步将接入 JD 输入页、分析结果页和本地 mock JSON。')
              .fontSize(14)
              .fontColor('#4B5563')
              .lineHeight(22)
          }
          .width('100%')
          .padding(16)
          .borderRadius(12)
          .backgroundColor('#EAF2FF')
        }
      }
      .width('100%')
      .padding({ left: 24, right: 24, bottom: 32 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F5F7FB')
  }
}

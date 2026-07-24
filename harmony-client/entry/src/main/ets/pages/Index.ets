import { common } from '@kit.AbilityKit';
import { HOME_CAPABILITIES, HOME_SUBTITLE, HOME_TITLE } from '../model/HomeContent';
import {
  AnalyzeAction,
  AnalyzeReminder,
  AnalyzeResult,
  buildMockAnalyzeResult,
  DEFAULT_CANDIDATE_SUMMARY,
  DEFAULT_JOB_DESCRIPTION
} from '../model/AnalyzeMock';
import {
  publishReminderNotification,
  ReminderNotificationResult,
  ReminderNotificationStatus
} from '../service/ReminderNotificationService';

@Entry
@Component
struct Index {
  @State currentStep: string = 'home';
  @State jobTitle: string = '鸿蒙应用开发实习生';
  @State companyName: string = '示例科技公司';
  @State jobDescription: string = DEFAULT_JOB_DESCRIPTION;
  @State candidateSummary: string = DEFAULT_CANDIDATE_SUMMARY;
  @State result: AnalyzeResult = buildMockAnalyzeResult('鸿蒙应用开发实习生', DEFAULT_CANDIDATE_SUMMARY);
  @State reminderGenerated: boolean = false;
  @State notificationPublishing: boolean = false;
  @State notificationStatus: string = 'idle';
  @State notificationFeedback: string = '';
  private notificationRequestId: number = 0;

  private startAnalyze(): void {
    this.result = buildMockAnalyzeResult(this.jobTitle, this.candidateSummary);
    this.resetReminderState();
    this.currentStep = 'result';
  }

  private resetDemo(): void {
    this.currentStep = 'home';
    this.resetReminderState();
  }

  private resetReminderState(): void {
    this.notificationRequestId += 1;
    this.reminderGenerated = false;
    this.notificationPublishing = false;
    this.notificationStatus = 'idle';
    this.notificationFeedback = '';
  }

  private async generateReminder(): Promise<void> {
    if (this.notificationPublishing) {
      return;
    }

    this.reminderGenerated = true;
    this.notificationPublishing = true;
    this.notificationStatus = 'publishing';
    this.notificationFeedback = '页面内提醒已生成，正在尝试发布系统通知。';
    const requestId: number = this.notificationRequestId + 1;
    this.notificationRequestId = requestId;

    try {
      const hostContext = this.getUIContext().getHostContext();
      if (hostContext === undefined) {
        if (requestId === this.notificationRequestId) {
          this.notificationStatus = ReminderNotificationStatus.UNSUPPORTED;
          this.notificationFeedback = '当前运行环境不提供通知上下文，页面内提醒仍可正常使用。';
        }
        return;
      }
      const context: common.UIAbilityContext = hostContext as common.UIAbilityContext;
      const notificationResult: ReminderNotificationResult =
        await publishReminderNotification(context, this.result.reminders);
      if (requestId === this.notificationRequestId) {
        this.notificationStatus = notificationResult.status;
        this.notificationFeedback = notificationResult.message;
      }
    } catch (error) {
      if (requestId === this.notificationRequestId) {
        this.notificationStatus = ReminderNotificationStatus.FAILED;
        this.notificationFeedback = '系统通知发布失败，可稍后重试；页面内提醒不受影响。';
      }
    } finally {
      if (requestId === this.notificationRequestId) {
        this.notificationPublishing = false;
      }
    }
  }

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

          Text('C4 初赛最小 Demo：输入 JD → Mock 分析 → 生成提醒')
            .fontSize(13)
            .fontColor('#2563EB')
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .margin({ top: 44, bottom: 8 })

        if (this.currentStep === 'home') {
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
              this.currentStep = 'form';
            })

          Column({ space: 8 }) {
            Text('当前策略')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111827')

            Text('先不接真实后端，不做完整登录注册，只用本地 mock JSON 证明作品闭环。DevEco 能运行后，再接轻接口。')
              .fontSize(14)
              .fontColor('#4B5563')
              .lineHeight(22)
          }
          .width('100%')
          .padding(16)
          .borderRadius(12)
          .backgroundColor('#EAF2FF')
        }

        if (this.currentStep === 'form') {
          Column({ space: 14 }) {
            Text('1. 输入岗位信息')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111827')

            TextInput({ placeholder: '岗位名称', text: this.jobTitle })
              .width('100%')
              .height(46)
              .backgroundColor('#FFFFFF')
              .onChange((value: string) => {
                this.jobTitle = value;
              })

            TextInput({ placeholder: '公司名称，可选', text: this.companyName })
              .width('100%')
              .height(46)
              .backgroundColor('#FFFFFF')
              .onChange((value: string) => {
                this.companyName = value;
              })

            TextArea({ placeholder: '粘贴岗位 JD', text: this.jobDescription })
              .width('100%')
              .height(140)
              .backgroundColor('#FFFFFF')
              .onChange((value: string) => {
                this.jobDescription = value;
              })

            Text('2. 输入个人背景')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111827')
              .margin({ top: 8 })

            TextArea({ placeholder: '技能、项目、经历摘要', text: this.candidateSummary })
              .width('100%')
              .height(140)
              .backgroundColor('#FFFFFF')
              .onChange((value: string) => {
                this.candidateSummary = value;
              })

            Row({ space: 12 }) {
              Button('返回首页')
                .width('36%')
                .height(46)
                .fontSize(15)
                .backgroundColor('#6B7280')
                .onClick(() => {
                  this.currentStep = 'home';
                })

              Button('生成 Mock 分析')
                .width('60%')
                .height(46)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .backgroundColor('#2563EB')
                .onClick(() => {
                  this.startAnalyze();
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .borderRadius(16)
          .backgroundColor('#FFFFFF')
        }

        if (this.currentStep === 'result') {
          Column({ space: 16 }) {
            Row() {
              Column({ space: 4 }) {
                Text('3. 分析结果')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#111827')

                Text(`${this.companyName} · ${this.jobTitle}`)
                  .fontSize(13)
                  .fontColor('#6B7280')
              }
              .layoutWeight(1)

              Text(`${this.result.matchScore}`)
                .fontSize(34)
                .fontWeight(FontWeight.Bold)
                .fontColor('#2563EB')
            }
            .width('100%')

            Text(this.result.summary)
              .fontSize(15)
              .fontColor('#374151')
              .lineHeight(23)

            Column({ space: 8 }) {
              Text('匹配点')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor('#111827')

              ForEach(this.result.strengths, (item: string) => {
                Text(`✓ ${item}`)
                  .fontSize(14)
                  .fontColor('#166534')
                  .lineHeight(22)
              }, (item: string) => item)
            }
            .width('100%')
            .padding(14)
            .borderRadius(12)
            .backgroundColor('#ECFDF3')

            Column({ space: 8 }) {
              Text('能力缺口')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor('#111827')

              ForEach(this.result.gaps, (item: string) => {
                Text(`• ${item}`)
                  .fontSize(14)
                  .fontColor('#92400E')
                  .lineHeight(22)
              }, (item: string) => item)
            }
            .width('100%')
            .padding(14)
            .borderRadius(12)
            .backgroundColor('#FFFBEB')

            Column({ space: 8 }) {
              Text('今日任务')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor('#111827')

              ForEach(this.result.actions, (action: AnalyzeAction) => {
                Row() {
                  Column({ space: 4 }) {
                    Text(action.title)
                      .fontSize(14)
                      .fontColor('#1F2937')
                      .lineHeight(21)

                    Text(`${action.priority} · ${action.dueDate}`)
                      .fontSize(12)
                      .fontColor('#6B7280')
                  }
                  .layoutWeight(1)
                }
                .width('100%')
                .padding({ top: 8, bottom: 8 })
              }, (action: AnalyzeAction) => action.title)
            }
            .width('100%')
            .padding(14)
            .borderRadius(12)
            .backgroundColor('#F9FAFB')

            Column({ space: 10 }) {
              Text('面试建议')
                .fontSize(17)
                .fontWeight(FontWeight.Bold)
                .fontColor('#111827')

              Text('演示时重点讲：为什么先做本地 mock、如何保证后端/AI 不可用时不断链、后续如何替换成真实 POST /api/c4/analyze。')
                .fontSize(14)
                .fontColor('#374151')
                .lineHeight(22)
            }
            .width('100%')
            .padding(14)
            .borderRadius(12)
            .backgroundColor('#EEF2FF')

            Button(
              this.notificationPublishing
                ? '正在发布系统通知'
                : this.notificationStatus === ReminderNotificationStatus.SUCCESS
                  ? '系统通知已发布'
                  : this.reminderGenerated
                    ? '重试系统通知'
                    : '生成求职提醒'
            )
              .width('100%')
              .height(46)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .backgroundColor(
                this.notificationStatus === ReminderNotificationStatus.SUCCESS ? '#16A34A' : '#2563EB'
              )
              .enabled(
                !this.notificationPublishing &&
                  this.notificationStatus !== ReminderNotificationStatus.SUCCESS
              )
              .onClick(() => {
                this.generateReminder();
              })

            if (this.reminderGenerated) {
              Column({ space: 8 }) {
                Text('提醒列表')
                  .fontSize(17)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#111827')

                if (this.result.reminders.length > 0) {
                  ForEach(this.result.reminders, (reminder: AnalyzeReminder) => {
                    Text(`⏰ ${reminder.time}：${reminder.title}`)
                      .fontSize(14)
                      .fontColor('#166534')
                      .lineHeight(22)
                  }, (reminder: AnalyzeReminder) => reminder.title)
                } else {
                  Text('今日求职任务已生成，请按今日任务逐项执行。')
                    .fontSize(14)
                    .fontColor('#166534')
                    .lineHeight(22)
                }
              }
              .width('100%')
              .padding(14)
              .borderRadius(12)
              .backgroundColor('#ECFDF3')
            }

            if (this.notificationFeedback.length > 0) {
              Text(this.notificationFeedback)
                .width('100%')
                .fontSize(13)
                .fontColor(
                  this.notificationStatus === ReminderNotificationStatus.SUCCESS ? '#166534' : '#92400E'
                )
                .lineHeight(20)
            }

            Row({ space: 12 }) {
              Button('重新输入')
                .width('48%')
                .height(44)
                .fontSize(15)
                .backgroundColor('#6B7280')
                .onClick(() => {
                  this.resetReminderState();
                  this.currentStep = 'form';
                })

              Button('回到首页')
                .width('48%')
                .height(44)
                .fontSize(15)
                .backgroundColor('#111827')
                .onClick(() => {
                  this.resetDemo();
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .borderRadius(16)
          .backgroundColor('#FFFFFF')
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

import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { notificationManager } from '@kit.NotificationKit';
import { AnalyzeReminder } from '../model/AnalyzeMock';

export enum ReminderNotificationStatus {
  SUCCESS = 'success',
  PERMISSION_DENIED = 'permissionDenied',
  UNSUPPORTED = 'unsupported',
  FAILED = 'failed'
}

export interface ReminderNotificationResult {
  status: ReminderNotificationStatus;
  message: string;
}

const NOTIFICATION_ID: number = 1001;
const NOTIFICATION_TITLE: string = 'InternPilot 今日求职任务';
const EMPTY_REMINDER_TEXT: string = '今日求职任务已生成，请返回应用查看。';

export function buildReminderNotificationText(reminders: AnalyzeReminder[]): string {
  if (reminders.length === 0) {
    return EMPTY_REMINDER_TEXT;
  }

  const firstReminder: AnalyzeReminder = reminders[0];
  return `${firstReminder.time}：${firstReminder.title}`;
}

export function classifyNotificationErrorCode(code: number): ReminderNotificationStatus {
  if (code === 1600004 || code === 1600005 || code === 1600014 || code === 1600020) {
    return ReminderNotificationStatus.PERMISSION_DENIED;
  }

  if (code === 801 || code === 1600003) {
    return ReminderNotificationStatus.UNSUPPORTED;
  }

  return ReminderNotificationStatus.FAILED;
}

function buildFailureResult(error: BusinessError): ReminderNotificationResult {
  const code: number = typeof error.code === 'number' ? error.code : 0;
  const status: ReminderNotificationStatus = classifyNotificationErrorCode(code);

  if (status === ReminderNotificationStatus.PERMISSION_DENIED) {
    return {
      status: status,
      message: '系统通知未获授权，页面内提醒仍可正常使用。'
    };
  }

  if (status === ReminderNotificationStatus.UNSUPPORTED) {
    return {
      status: status,
      message: '当前运行环境不支持或无法连接通知服务，页面内提醒仍可正常使用。'
    };
  }

  return {
    status: status,
    message: '系统通知发布失败，可稍后重试；页面内提醒不受影响。'
  };
}

export async function publishReminderNotification(
  context: common.UIAbilityContext,
  reminders: AnalyzeReminder[]
): Promise<ReminderNotificationResult> {
  try {
    let notificationEnabled: boolean = await notificationManager.isNotificationEnabled();
    if (!notificationEnabled) {
      await notificationManager.requestEnableNotification(context);
      notificationEnabled = await notificationManager.isNotificationEnabled();
    }

    if (!notificationEnabled) {
      return {
        status: ReminderNotificationStatus.PERMISSION_DENIED,
        message: '系统通知未获授权，页面内提醒仍可正常使用。'
      };
    }

    const request: notificationManager.NotificationRequest = {
      id: NOTIFICATION_ID,
      notificationSlotType: notificationManager.SlotType.CONTENT_INFORMATION,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: NOTIFICATION_TITLE,
          text: buildReminderNotificationText(reminders)
        }
      }
    };

    await notificationManager.publish(request);
    return {
      status: ReminderNotificationStatus.SUCCESS,
      message: '页面内提醒已生成，系统摘要通知已发布。'
    };
  } catch (error) {
    return buildFailureResult(error as BusinessError);
  }
}

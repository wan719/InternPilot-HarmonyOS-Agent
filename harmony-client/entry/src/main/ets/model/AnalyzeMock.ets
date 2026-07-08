export interface AnalyzeAction {
  title: string;
  priority: string;
  dueDate: string;
}

export interface AnalyzeReminder {
  title: string;
  time: string;
}

export interface AnalyzeResult {
  matchScore: number;
  summary: string;
  strengths: string[];
  gaps: string[];
  actions: AnalyzeAction[];
  reminders: AnalyzeReminder[];
}

export const DEFAULT_JOB_DESCRIPTION: string = '岗位职责：参与鸿蒙/前端应用开发，完成页面实现、接口联调和基础性能优化。任职要求：熟悉 TypeScript 或 Java，有项目经验，具备良好的学习能力。';

export const DEFAULT_CANDIDATE_SUMMARY: string = '软件工程大二学生，做过 Spring Boot + Vue3 项目 InternPilot，了解 Java、前端基础、Docker 部署，正在补充 HarmonyOS / ArkTS 项目经验。';

export function buildMockAnalyzeResult(jobTitle: string, candidateSummary: string): AnalyzeResult {
  const normalizedJobTitle: string = jobTitle.trim().length > 0 ? jobTitle.trim() : '鸿蒙应用开发实习生';
  const normalizedCandidate: string = candidateSummary.trim().length > 0 ? candidateSummary.trim() : DEFAULT_CANDIDATE_SUMMARY;
  const hasHarmonyKeyword: boolean = normalizedJobTitle.indexOf('鸿蒙') >= 0 || normalizedJobTitle.indexOf('Harmony') >= 0 || normalizedJobTitle.indexOf('ArkTS') >= 0;
  const baseScore: number = hasHarmonyKeyword ? 82 : 76;

  return {
    matchScore: baseScore,
    summary: `你对「${normalizedJobTitle}」有一定匹配度。已有 Java / Web 项目基础，当前最需要补一段可运行的 HarmonyOS Demo 作为项目证明。`,
    strengths: [
      '已有完整 InternPilot 项目经历，可以讲清需求、后端、前端和部署闭环。',
      '具备 Java、Vue、接口联调和工程化基础，迁移到 ArkTS 学习成本较低。',
      `个人背景摘要较完整：${normalizedCandidate.length > 42 ? normalizedCandidate.slice(0, 42) + '…' : normalizedCandidate}`
    ],
    gaps: [
      'HarmonyOS / ArkTS 经验还需要用可运行页面证明。',
      '简历里需要把“AI 求职 Agent”包装成比赛作品，而不是普通课程项目。',
      '后端和 AI 能力初赛可先用 mock/fallback，避免现场网络影响演示。'
    ],
    actions: [
      {
        title: '今天跑通 DevEco Empty Ability，并截图保存首页',
        priority: 'high',
        dueDate: '今天'
      },
      {
        title: '补齐 JD 输入、分析结果和页面内提醒的最小闭环',
        priority: 'high',
        dueDate: '明天'
      },
      {
        title: '准备 3 分钟演示脚本：输入 JD → 生成建议 → 生成提醒',
        priority: 'medium',
        dueDate: '本周内'
      }
    ],
    reminders: [
      {
        title: '晚上复查 HarmonyOS 最小 Demo 是否能在 DevEco 运行',
        time: '今天 20:00'
      }
    ]
  };
}

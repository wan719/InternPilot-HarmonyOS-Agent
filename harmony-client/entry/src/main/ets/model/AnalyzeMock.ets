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

export interface AnalyzeRequest {
  jobTitle: string;
  companyName: string;
  jobDescription: string;
  candidateSummary: string;
}

export interface JobSkillProfile {
  type: string;
  displayName: string;
  keywords: string[];
  coreSkills: string[];
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

const HARMONY_PROFILE: JobSkillProfile = {
  type: 'harmony',
  displayName: '鸿蒙应用开发',
  keywords: ['HarmonyOS', '鸿蒙', 'ArkTS', 'ArkUI', 'DevEco', 'TypeScript'],
  coreSkills: ['HarmonyOS', 'ArkTS', 'ArkUI', 'DevEco Studio', 'TypeScript']
};

const JAVA_PROFILE: JobSkillProfile = {
  type: 'javaBackend',
  displayName: 'Java 后端开发',
  keywords: ['Java', 'Spring Boot', 'MySQL', 'Redis', 'Docker', '微服务', 'REST API'],
  coreSkills: ['Java', 'Spring Boot', 'MySQL', 'Redis', 'Docker', '微服务', 'REST API']
};

const WEB_PROFILE: JobSkillProfile = {
  type: 'webFrontend',
  displayName: 'Web 前端开发',
  keywords: ['Vue', 'Vue3', 'TypeScript', 'JavaScript', 'HTML', 'CSS', '组件化', '性能优化'],
  coreSkills: ['Vue3', 'TypeScript', 'JavaScript', 'HTML', 'CSS', '组件化', '性能优化']
};

const GENERAL_PROFILE: JobSkillProfile = {
  type: 'general',
  displayName: '通用软件开发',
  keywords: [],
  coreSkills: ['项目经验', '接口联调', '工程化', '沟通能力', '学习能力']
};

const JOB_PROFILES: JobSkillProfile[] = [
  HARMONY_PROFILE,
  JAVA_PROFILE,
  WEB_PROFILE
];

function normalizeText(value: string): string {
  return value.trim().toLowerCase();
}

function containsKeyword(text: string, keyword: string): boolean {
  return text.indexOf(keyword.toLowerCase()) >= 0;
}

function containsSkill(text: string, skill: string): boolean {
  if (skill === 'HarmonyOS') {
    return containsKeyword(text, 'HarmonyOS') || containsKeyword(text, '鸿蒙');
  }
  if (skill === 'DevEco Studio') {
    return containsKeyword(text, 'DevEco');
  }
  if (skill === 'Vue3') {
    return containsKeyword(text, 'Vue3') || containsKeyword(text, 'Vue 3');
  }
  if (skill === 'REST API') {
    return containsKeyword(text, 'REST API') || containsKeyword(text, 'RESTful');
  }
  return containsKeyword(text, skill);
}

function profileScore(profile: JobSkillProfile, jobTitle: string, jobDescription: string): number {
  let score: number = 0;
  profile.keywords.forEach((keyword: string) => {
    if (containsKeyword(jobTitle, keyword)) {
      score += 2;
    }
    if (containsKeyword(jobDescription, keyword)) {
      score += 1;
    }
  });
  return score;
}

function detectJobProfile(jobTitle: string, jobDescription: string): JobSkillProfile {
  let selectedProfile: JobSkillProfile = GENERAL_PROFILE;
  let selectedScore: number = 0;

  JOB_PROFILES.forEach((profile: JobSkillProfile) => {
    const score: number = profileScore(profile, jobTitle, jobDescription);
    if (score > selectedScore) {
      selectedProfile = profile;
      selectedScore = score;
    }
  });

  return selectedProfile;
}

function collectRequiredSkills(profile: JobSkillProfile, jobText: string): string[] {
  const requiredSkills: string[] = [];
  profile.coreSkills.forEach((skill: string) => {
    if (containsSkill(jobText, skill)) {
      requiredSkills.push(skill);
    }
  });

  if (requiredSkills.length > 0) {
    return requiredSkills;
  }
  return profile.coreSkills.slice();
}

function collectMatchedSkills(requiredSkills: string[], candidateText: string): string[] {
  const matchedSkills: string[] = [];
  requiredSkills.forEach((skill: string) => {
    if (containsSkill(candidateText, skill)) {
      matchedSkills.push(skill);
    }
  });
  return matchedSkills;
}

function collectMissingSkills(requiredSkills: string[], matchedSkills: string[]): string[] {
  const missingSkills: string[] = [];
  requiredSkills.forEach((skill: string) => {
    if (matchedSkills.indexOf(skill) < 0) {
      missingSkills.push(skill);
    }
  });
  return missingSkills;
}

function calculateMatchScore(requiredCount: number, matchedCount: number): number {
  const ratio: number = requiredCount > 0 ? matchedCount / requiredCount : 0;
  const score: number = 55 + Math.round(ratio * 40);
  return Math.max(0, Math.min(100, score));
}

function buildStrengths(
  profile: JobSkillProfile,
  matchedSkills: string[],
  candidateSummary: string
): string[] {
  const strengths: string[] = [];
  matchedSkills.slice(0, 3).forEach((skill: string) => {
    strengths.push(`已具备 ${skill}，与${profile.displayName}岗位要求直接匹配。`);
  });

  if (strengths.length === 0) {
    strengths.push('当前背景信息可用于建立补强计划，建议继续补充可验证的项目经历。');
  }
  if (candidateSummary.length > 0 && strengths.length < 3) {
    const excerpt: string = candidateSummary.length > 42 ?
      candidateSummary.slice(0, 42) + '…' : candidateSummary;
    strengths.push(`个人背景摘要：${excerpt}`);
  }
  return strengths;
}

function buildGaps(profile: JobSkillProfile, missingSkills: string[]): string[] {
  if (missingSkills.length === 0) {
    return [`${profile.displayName}关键词匹配较完整，仍需补充可运行项目和结果证据。`];
  }

  const gaps: string[] = [];
  missingSkills.slice(0, 3).forEach((skill: string) => {
    gaps.push(`岗位要求包含 ${skill}，当前个人背景中尚未识别到对应证据。`);
  });
  return gaps;
}

function buildActions(profile: JobSkillProfile, missingSkills: string[]): AnalyzeAction[] {
  const focusSkills: string[] = missingSkills.length > 0 ?
    missingSkills.slice(0, 2) : profile.coreSkills.slice(0, 2);
  const firstSkill: string = focusSkills.length > 0 ? focusSkills[0] : profile.displayName;
  const secondSkill: string = focusSkills.length > 1 ? focusSkills[1] : firstSkill;

  return [
    {
      title: `完成一个包含 ${firstSkill} 的${profile.displayName}最小案例`,
      priority: 'high',
      dueDate: '今天'
    },
    {
      title: `把 ${secondSkill} 相关经历整理为简历中的可验证证据`,
      priority: 'high',
      dueDate: '明天'
    },
    {
      title: `准备 ${profile.displayName}岗位的 3 分钟项目讲解`,
      priority: 'medium',
      dueDate: '本周内'
    }
  ];
}

export function buildRuleBasedAnalyzeResult(request: AnalyzeRequest): AnalyzeResult {
  let fallbackJobTitle: string = '';
  let fallbackCandidateSummary: string = '';

  try {
    fallbackJobTitle = typeof request.jobTitle === 'string' ? request.jobTitle : '';
    fallbackCandidateSummary = typeof request.candidateSummary === 'string' ?
      request.candidateSummary : '';
    const rawCompanyName: string = typeof request.companyName === 'string' ?
      request.companyName : '';
    const rawJobDescription: string = typeof request.jobDescription === 'string' ?
      request.jobDescription : '';

    const jobTitle: string = fallbackJobTitle.trim().length > 0 ?
      fallbackJobTitle.trim() : '未命名岗位';
    const companyName: string = rawCompanyName.trim().length > 0 ?
      rawCompanyName.trim() : '目标公司';
    const jobDescription: string = rawJobDescription.trim();
    const candidateSummary: string = fallbackCandidateSummary.trim();
    const normalizedJobTitle: string = normalizeText(jobTitle);
    const normalizedJobDescription: string = normalizeText(jobDescription);
    const jobText: string = `${normalizedJobTitle} ${normalizedJobDescription}`;
    const candidateText: string = normalizeText(candidateSummary);
    const profile: JobSkillProfile = detectJobProfile(normalizedJobTitle, normalizedJobDescription);
    const requiredSkills: string[] = collectRequiredSkills(profile, jobText);
    const matchedSkills: string[] = collectMatchedSkills(requiredSkills, candidateText);
    const missingSkills: string[] = collectMissingSkills(requiredSkills, matchedSkills);
    const matchScore: number = calculateMatchScore(requiredSkills.length, matchedSkills.length);
    const strengths: string[] = buildStrengths(profile, matchedSkills, candidateSummary);
    const gaps: string[] = buildGaps(profile, missingSkills);
    const actions: AnalyzeAction[] = buildActions(profile, missingSkills);

    return {
      matchScore: matchScore,
      summary: `已将「${companyName} · ${jobTitle}」识别为${profile.displayName}方向；岗位命中 ${requiredSkills.length} 个技能关键词，你的背景匹配 ${matchedSkills.length} 个。结果来自本地规则化演示，不代表真实 AI 评价。`,
      strengths: strengths,
      gaps: gaps,
      actions: actions,
      reminders: [
        {
          title: actions[0].title,
          time: '今天 20:00'
        }
      ]
    };
  } catch (error) {
    return buildMockAnalyzeResult(fallbackJobTitle, fallbackCandidateSummary);
  }
}

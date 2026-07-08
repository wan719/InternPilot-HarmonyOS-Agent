# InternPilot 架构草案

## HarmonyOS 客户端模块

- `JobInputPage`：输入岗位名称、公司名称、岗位 JD。
- `ProfileInputPage`：输入技能、经历、求职目标。
- `AnalyzeResultPage`：展示匹配分、优势、短板、行动建议和提醒。
- `ReminderService`：根据分析结果创建本地通知或演示用 mock 提醒。
- `AnalyzeApiClient`：封装后端请求和 fallback mock。

## 后端轻接口

### `POST /api/c4/analyze`

请求示例：

```json
{
  "job": {
    "title": "前端实习生",
    "company": "示例公司",
    "description": "岗位 JD 文本"
  },
  "candidate": {
    "target": "鸿蒙应用开发实习",
    "skills": ["ArkTS", "TypeScript", "前端基础"],
    "experience": "课程项目和个人作品摘要"
  }
}
```

响应示例：

```json
{
  "matchScore": 78,
  "summary": "整体匹配度较高，但需要补充项目表达和岗位关键词。",
  "strengths": ["具备前端基础", "目标方向明确"],
  "gaps": ["缺少鸿蒙端项目证明", "简历中量化结果不足"],
  "actions": [
    {
      "title": "补充 ArkTS 项目描述",
      "priority": "high",
      "dueDate": "2026-07-12"
    }
  ],
  "reminders": [
    {
      "title": "完善简历项目经历",
      "time": "2026-07-12T20:00:00+08:00"
    }
  ]
}
```

## AI 分析返回 JSON 结构

- `matchScore`：0 到 100 的岗位匹配分。
- `summary`：一句话分析结论。
- `strengths`：候选人优势列表。
- `gaps`：当前短板或风险点。
- `actions`：下一步行动建议，包含标题、优先级和建议截止日期。
- `reminders`：提醒标题和时间，用于客户端通知。

## 通知提醒能力

初赛阶段优先验证本地提醒流程：

- 用户点击“生成提醒”。
- 客户端读取 `reminders`。
- 若系统通知权限可用，则创建本地通知。
- 若权限不可用，则在页面内展示提醒列表，保证演示可继续。

## fallback mock 策略

- 客户端内置一份固定 mock JSON。
- 后端不可用时，`AnalyzeApiClient` 返回本地 mock。
- AI 服务不可用时，后端返回固定 mock。
- 演示视频优先展示真实调用路径，同时保留 mock 路径防止现场网络问题。

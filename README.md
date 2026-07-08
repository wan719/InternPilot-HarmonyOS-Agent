# InternPilot HarmonyOS Agent

InternPilot 鸿蒙求职 Agent 是一个面向高校学生的求职准备助手。当前仓库处于第 1 阶段：只验证“鸿蒙客户端 + 本地 mock 分析 JSON + 页面内提醒兜底”的最小可行闭环。

## 当前阶段

- 目标：完成 2026 C4 鸿蒙高校创新赛初赛前的可运行最小 Demo。
- 范围：HarmonyOS Empty Ability、首页、JD 输入、本地 mock 分析结果、页面内提醒兜底。
- 不包含：真实账号体系、真实招聘平台接入、真实 API Key、生产部署密码或敏感凭据。

## 目录

```text
docs/
  product-brief.md
  architecture.md
  submission-checklist.md
demo/
  run-guide.md
harmony-client/
backend-c4/
README.md
```

## 当前可运行状态

- DevEco Studio 已在 `harmony-client/` 下创建 HarmonyOS Empty Ability 项目。
- 当前项目入口为 ArkTS 页面 `entry/src/main/ets/pages/Index.ets`。
- 当前已实现单页最小闭环：

```text
首页
→ 点击开始分析岗位
→ 输入岗位 JD 与个人背景
→ 生成本地 mock 分析结果
→ 展示匹配点、能力缺口、今日任务、面试建议
→ 生成页面内提醒
```

## 本地运行

1. 打开 DevEco Studio。
2. 选择 `Open Project`。
3. 打开本仓库下的 `harmony-client/` 目录。
4. 等待 Sync 完成。
5. 运行 `entry` 模块。
6. 按页面流程验证最小闭环。

更详细步骤见：`demo/run-guide.md`。

## 推荐下一步

先在 DevEco Studio 确认可运行，然后保存首页、输入页、结果页截图。确认稳定后，再接后端轻接口 `POST /api/c4/analyze` 或系统通知能力。

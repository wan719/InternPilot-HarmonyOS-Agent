# InternPilot HarmonyOS Agent

InternPilot 鸿蒙求职 Agent 是一个面向高校学生的求职准备助手。当前仓库处于第 1 阶段：只验证“鸿蒙客户端 + 后端轻接口 + AI 分析 JSON + 通知提醒”的最小可行闭环。

## 当前阶段

- 目标：完成 2026 C4 鸿蒙高校创新赛初赛前的可行性验证材料与技术骨架。
- 范围：文档、基础目录、MVP 架构草案。
- 不包含：真实账号体系、真实招聘平台接入、真实 API Key、生产部署密码或敏感凭据。

## 目录

```text
docs/
  product-brief.md
  architecture.md
  submission-checklist.md
harmony-client/
backend-c4/
README.md
```

## 推荐下一步

先在 DevEco Studio 跑通一个最小 ArkTS 示例：创建 `Empty Ability` 工程，验证页面渲染、按钮点击、HTTP 请求、系统通知权限与本地 mock 数据展示。

## 当前可运行状态

- DevEco Studio 已在 `harmony-client/` 下创建 HarmonyOS Empty Ability 项目。
- 当前项目入口为 ArkTS 页面 `entry/src/main/ets/pages/Index.ets`，页面路由配置为 `entry/src/main/resources/base/profile/main_pages.json`。
- 从工程结构看，当前可以作为 Empty Ability 基础项目在 DevEco Studio 中运行；实际运行状态以 DevEco Studio 本地预览器、模拟器或真机运行结果为准。
- 下一步优先实现 JD 输入页、分析结果页和本地 mock JSON，先打通“输入岗位信息 -> 展示分析结果”的演示闭环。

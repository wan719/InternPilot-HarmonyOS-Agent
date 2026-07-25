# InternPilot HarmonyOS Agent

InternPilot 鸿蒙求职 Agent 是一个面向高校学生的求职准备助手。当前仓库处于第 1 阶段：只验证“鸿蒙客户端 + 本地 mock 分析 JSON + 页面内提醒兜底 + 系统摘要通知”的最小可行闭环。

## 当前阶段

- 目标：完成 2026 C4 鸿蒙高校创新赛初赛前的可运行最小 Demo。
- 范围：HarmonyOS Empty Ability、首页、JD 输入、本地 mock 分析结果、页面内提醒兜底、HarmonyOS 本地系统通知。
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
→ 生成页面内提醒，并尝试发布系统摘要通知
```

页面内提醒会先显示且始终保留。通知权限被拒绝、运行环境不支持或系统通知发布失败时，页面会显示简洁状态反馈，主流程仍可继续使用并允许重试。通知实现基于项目当前 HarmonyOS API 21 SDK 的 `@kit.NotificationKit`。

## 本地运行

1. 打开 DevEco Studio。
2. 选择 `Open Project`。
3. 打开本仓库下的 `harmony-client/` 目录。
4. 等待 Sync 完成。
5. 运行 `entry` 模块。
6. 按页面流程验证最小闭环。Previewer 可检查页面 fallback；系统通知建议在支持通知服务的本地模拟器或真机上验证。

更详细步骤见：`demo/run-guide.md`。

## 推荐下一步

先在 DevEco Studio 中验证 entry 构建和页面 fallback，再用模拟器或真机检查通知授权、发布成功和拒绝权限三种情况。验证完成后保存真实截图，再考虑接后端轻接口 `POST /api/c4/analyze`。

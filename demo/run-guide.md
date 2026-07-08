# InternPilot 鸿蒙求职 Agent 最小 Demo 运行指南

## 目标

先在 DevEco Studio 中跑通 HarmonyOS 客户端最小闭环：

```text
首页
→ 点击开始分析岗位
→ 输入岗位 JD 与个人背景
→ 生成本地 mock 分析结果
→ 展示匹配点、能力缺口、今日任务、面试建议
→ 生成页面内提醒
```

本阶段不接真实后端、不接真实 AI Key、不做登录注册。

## 本地运行步骤

1. 打开 DevEco Studio。
2. 选择 `Open Project`。
3. 打开仓库中的 `harmony-client/` 目录，而不是仓库根目录。
4. 等待工程同步完成。
5. 选择 `entry` 模块。
6. 使用 Previewer、模拟器或真机运行。
7. 进入首页后按下面路径验证：

```text
开始分析岗位
→ 保留或修改默认岗位信息
→ 生成 Mock 分析
→ 生成页面内提醒
```

## 预期效果

- 首页显示作品名称：`InternPilot 鸿蒙求职 Agent`。
- 首页显示当前是 C4 初赛最小 Demo。
- 表单页能输入岗位名称、公司名称、岗位 JD、个人背景。
- 结果页能展示匹配分、总结、匹配点、能力缺口、今日任务和面试建议。
- 点击“生成页面内提醒”后出现提醒列表。

## 失败时优先检查

### 1. 打开目录错误

如果 DevEco 识别不到 HarmonyOS 工程，确认打开的是：

```text
InternPilot-HarmonyOS-Agent/harmony-client
```

不是：

```text
InternPilot-HarmonyOS-Agent
```

### 2. 依赖同步失败

优先检查网络、DevEco SDK 是否已安装，以及 `build-profile.json5` 中的 SDK 版本是否与本机 DevEco 支持版本一致。

### 3. 页面没有变化

确认当前分支为：

```bash
git checkout feature/minimal-mock-demo
```

并重新 Sync / Rebuild。

### 4. ArkTS 编译报错

先不要扩展后端和通知 API。当前最小 Demo 只依赖 ArkUI 基础组件和本地 mock 数据，目标是先让页面能运行。

## 下一步

最小 Demo 能运行后，再做三件事：

1. 保存首页、输入页、结果页截图。
2. 录一段 1 分钟本地演示视频，验证闭环能完整走通。
3. 再考虑接入 `POST /api/c4/analyze` 轻接口或系统通知能力。

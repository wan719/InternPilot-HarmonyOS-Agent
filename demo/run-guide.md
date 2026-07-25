# InternPilot 鸿蒙求职 Agent 最小 Demo 运行指南

## 目标

先在 DevEco Studio 中跑通 HarmonyOS 客户端最小闭环：

```text
首页
→ 点击开始分析岗位
→ 输入岗位 JD 与个人背景
→ 生成本地 mock 分析结果
→ 展示匹配点、能力缺口、今日任务、面试建议
→ 生成页面内提醒，并尝试发布系统摘要通知
```

本阶段不接真实后端、不接真实 AI Key、不做登录注册。

## 本地运行步骤

1. 打开 DevEco Studio。
2. 选择 `Open Project`。
3. 打开仓库中的 `harmony-client/` 目录，而不是仓库根目录。
4. 等待工程同步完成。
5. 选择 `entry` 模块。
6. 页面流程可先使用 Previewer 检查；系统通知请优先使用支持通知服务的本地模拟器或真机。
7. 进入首页后按下面路径验证：

```text
开始分析岗位
→ 保留或修改默认岗位信息
→ 生成 Mock 分析
→ 生成求职提醒
```

## 预期效果

- 首页显示作品名称：`InternPilot 鸿蒙求职 Agent`。
- 首页显示当前是 C4 初赛最小 Demo。
- 表单页能输入岗位名称、公司名称、岗位 JD、个人背景。
- 结果页能展示匹配分、总结、匹配点、能力缺口、今日任务和面试建议。
- 点击“生成求职提醒”后，页面内提醒立即出现。
- 应用随后检查通知开关；未授权时请求用户授权，再尝试发布标题为 `InternPilot 今日求职任务` 的摘要通知。
- 通知发布成功时页面显示成功反馈；拒绝权限、环境不支持或发布失败时，页面内提醒保持可用，页面显示原因并允许重试。

## 运行环境差异

- Previewer：适合验证单页交互、页面内提醒和失败 fallback，不保证提供完整系统通知服务。
- 本地模拟器：适合验证通知授权弹窗和通知中心展示，具体能力取决于镜像与系统版本。
- 真机：最接近最终演示环境，需要确认调试签名、设备连接和通知设置。

首次点击可能出现通知授权弹窗。拒绝授权是正常验收分支，应用不应崩溃，页面内提醒也不应消失。

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
git checkout feature/system-notification-fallback
```

并重新 Sync / Rebuild。

### 4. ArkTS 编译报错

当前通知代码按项目安装的 HarmonyOS API 21 SDK 编写。先查看第一条 ArkTS 编译错误，不要同时扩展后端或真实 AI。

### 5. 没有出现系统通知

先确认页面内提醒已经显示，再检查：

1. 当前是否使用支持通知服务的模拟器或真机，而不是只在 Previewer 中验证。
2. 系统设置中是否允许 InternPilot 发送通知。
3. 页面反馈是 `permissionDenied`、`unsupported` 还是 `failed` 对应的中文说明。

即使系统通知不可用，页面内提醒仍是本轮 Demo 的可靠 fallback。

## 下一步

最小 Demo 能运行后，再做三件事：

1. 保存首页、输入页、结果页、页面内提醒与真实系统通知截图；无法发布通知时保存页面 fallback 的真实状态。
2. 录一段 1 分钟本地演示视频，验证闭环能完整走通。
3. 再考虑接入 `POST /api/c4/analyze` 轻接口。

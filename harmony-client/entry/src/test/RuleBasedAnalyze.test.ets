import { describe, it, expect } from '@ohos/hypium';
import {
  AnalyzeRequest,
  AnalyzeResult,
  buildRuleBasedAnalyzeResult
} from '../main/ets/model/AnalyzeMock';

const HARMONY_REQUEST: AnalyzeRequest = {
  jobTitle: 'HarmonyOS 应用开发实习生',
  companyName: '示例终端科技',
  jobDescription: '使用 ArkTS、ArkUI 和 DevEco Studio 开发鸿蒙应用，要求掌握 TypeScript。',
  candidateSummary: '做过 HarmonyOS 页面 Demo，熟悉 ArkTS 和 TypeScript。'
};

const JAVA_REQUEST: AnalyzeRequest = {
  jobTitle: 'Java 后端开发实习生',
  companyName: '示例云服务公司',
  jobDescription: '负责 Spring Boot、MySQL、Redis 和 REST API 开发，了解 Docker 与微服务。',
  candidateSummary: '完成过 Java、Spring Boot、MySQL 和 Docker 项目。'
};

const WEB_REQUEST: AnalyzeRequest = {
  jobTitle: 'Vue 前端开发实习生',
  companyName: '示例互联网公司',
  jobDescription: '使用 Vue3、TypeScript、HTML 和 CSS 开发组件，关注性能优化。',
  candidateSummary: '做过 Vue3、JavaScript、HTML 和 CSS 项目。'
};

export default function ruleBasedAnalyzeTest() {
  describe('ruleBasedAnalyzeTest', () => {
    it('recognizesHarmonyJob', 0, () => {
      const result: AnalyzeResult = buildRuleBasedAnalyzeResult(HARMONY_REQUEST);
      expect(result.summary).assertContain('鸿蒙应用开发');
    });

    it('recognizesJavaBackendJob', 0, () => {
      const result: AnalyzeResult = buildRuleBasedAnalyzeResult(JAVA_REQUEST);
      expect(result.summary).assertContain('Java 后端开发');
    });

    it('recognizesVueFrontendJob', 0, () => {
      const result: AnalyzeResult = buildRuleBasedAnalyzeResult(WEB_REQUEST);
      expect(result.summary).assertContain('Web 前端开发');
    });

    it('producesDifferentGapsAndActionsByJobType', 0, () => {
      const harmonyResult: AnalyzeResult = buildRuleBasedAnalyzeResult(HARMONY_REQUEST);
      const javaResult: AnalyzeResult = buildRuleBasedAnalyzeResult(JAVA_REQUEST);
      const webResult: AnalyzeResult = buildRuleBasedAnalyzeResult(WEB_REQUEST);

      expect(harmonyResult.gaps[0] === javaResult.gaps[0]).assertEqual(false);
      expect(javaResult.actions[0].title === webResult.actions[0].title).assertEqual(false);
      expect(webResult.actions[0].title === harmonyResult.actions[0].title).assertEqual(false);
    });

    it('keepsScoresInsideValidRange', 0, () => {
      const results: AnalyzeResult[] = [
        buildRuleBasedAnalyzeResult(HARMONY_REQUEST),
        buildRuleBasedAnalyzeResult(JAVA_REQUEST),
        buildRuleBasedAnalyzeResult(WEB_REQUEST)
      ];

      results.forEach((result: AnalyzeResult) => {
        expect(result.matchScore >= 0).assertEqual(true);
        expect(result.matchScore <= 100).assertEqual(true);
      });
    });

    it('returnsDeterministicResultForSameInput', 0, () => {
      const first: AnalyzeResult = buildRuleBasedAnalyzeResult(JAVA_REQUEST);
      const second: AnalyzeResult = buildRuleBasedAnalyzeResult(JAVA_REQUEST);
      expect(JSON.stringify(first)).assertEqual(JSON.stringify(second));
    });

    it('handlesEmptyInputWithoutThrowing', 0, () => {
      const emptyRequest: AnalyzeRequest = {
        jobTitle: '',
        companyName: '',
        jobDescription: '',
        candidateSummary: ''
      };
      const result: AnalyzeResult = buildRuleBasedAnalyzeResult(emptyRequest);

      expect(result.matchScore >= 0).assertEqual(true);
      expect(result.matchScore <= 100).assertEqual(true);
      expect(result.summary.length > 0).assertEqual(true);
      expect(result.gaps.length > 0).assertEqual(true);
      expect(result.actions.length > 0).assertEqual(true);
      expect(result.reminders.length > 0).assertEqual(true);
    });
  });
}

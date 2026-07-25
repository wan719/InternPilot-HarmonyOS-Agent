import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { HOME_CAPABILITIES, HOME_SUBTITLE, HOME_TITLE } from '../main/ets/model/HomeContent';

export default function localUnitTest() {
  describe('localUnitTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('assertContain', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'abc';
      let b = 'b';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    });
    it('homeContentMatchesInternPilotMvp', 0, () => {
      expect(HOME_TITLE).assertEqual('InternPilot 鸿蒙求职 Agent');
      expect(HOME_SUBTITLE).assertEqual('面向大学生实习求职的 AI 助理');
      expect(HOME_CAPABILITIES.length).assertEqual(4);
      expect(HOME_CAPABILITIES[0]).assertEqual('岗位 JD 分析');
      expect(HOME_CAPABILITIES[1]).assertEqual('能力缺口识别');
      expect(HOME_CAPABILITIES[2]).assertEqual('今日求职任务');
      expect(HOME_CAPABILITIES[3]).assertEqual('页面内提醒兜底');
    });
  });
}

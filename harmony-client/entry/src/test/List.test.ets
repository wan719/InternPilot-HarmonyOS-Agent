import localUnitTest from './LocalUnit.test';
import ruleBasedAnalyzeTest from './RuleBasedAnalyze.test';

export default function testsuite() {
  localUnitTest();
  ruleBasedAnalyzeTest();
}

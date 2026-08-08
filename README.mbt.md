# moonbit-neuroscore

面向神经外科、神经重症与急诊流程的 MoonBit 评分基础设施。它把公开临床量表表达为类型安全、可测试、可解释的纯函数；库只负责结构化计算与记录，不提供诊断或治疗建议。

## 已实现

- GCS、mRS、Hunt–Hess、WFNS、modified Fisher、ICH Score、ASPECTS 记录模型
- 统一 `ScoreResult`：总分、风险带、缺失字段和解释文本
- JSON 输出函数与最小 CLI：`calc gcs`、`explain ich-score`
- 非法范围显式返回 `NotApplicable`，避免把坏输入伪装成临床结果

```bash
moon run cmd/main -- calc gcs 3 4 5
# {"name":"GCS","total":12,"band":"high",...}
```

## 开发与验证

需要 MoonBit 0.10.3 或更新版本：

```bash
moon check --deny-warn
moon test
moon fmt --check
moon info
```

## 设计边界

量表计算的输入语义、分界点与临床场景必须由专业人员核对。本项目不是医疗器械、诊断系统或患者个体化建议工具；真实应用必须由具备资质的医护人员依据当地指南、原始病历和机构流程复核。

公式与范围说明见 [`SOURCES.md`](SOURCES.md)，开发规划见 [`PROPOSAL.md`](PROPOSAL.md)。本项目刻意保持领域模型与 I/O 适配解耦，后续可增加 CSV、FHIR Observation/QuestionnaireResponse、批处理和更多公开量表，而不破坏评分核心 API。

## 许可证

MIT License。详见 [`LICENSE`](LICENSE)。

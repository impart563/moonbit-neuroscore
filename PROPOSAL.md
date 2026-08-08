# moonbit-neuroscore：神经外科围手术期风险与量表工具包

代码仓库：

- GitHub：https://github.com/impart563/moonbit-neuroscore
- GitLink：https://gitlink.org.cn/wjhppo/moonbit-neuroscore

## 目标与用户

面向神经外科、神经重症和急诊软件开发者，提供可复用、可测试、可解释的 MoonBit 医学计算基础设施。项目不做诊断建议，只把公开量表的字段、范围、分数、缺失值和解释组织成稳定 API，便于教学、科研原型、数据清洗与临床软件集成。

## 交付范围

核心库实现 GCS、mRS、Hunt–Hess、WFNS、modified Fisher、ICH Score、ASPECTS；统一返回 `ScoreResult`，包含总分、`RiskBand`、缺失字段和证据说明。CLI 提供单病例计算和 JSON 输出；后续迭代增加 CSV 批处理、FHIR Observation/QuestionnaireResponse 轻量适配、量表注册表和版本化来源记录。

## 技术路线与可行性

MoonBit 的代数数据类型和穷举匹配适合表达有限等级，纯函数便于跨后端复现，`moon test`、`moon fmt`、`moon info` 与 GitHub Actions 固化质量门槛。每个评分器只接受结构化整数或枚举，非法范围返回 `NotApplicable`，不把缺失数据默认为正常值。库、序列化和 CLI 分包，保持未来扩展不污染核心算法。

## 工程计划

第一阶段完成核心类型和 GCS；第二阶段完成常用神经外科量表与边界测试；第三阶段完成 JSON/CSV/FHIR 适配与 CLI；第四阶段补齐来源、示例、覆盖率、CI、CHANGELOG 和 API 接口摘要。每项功能以公开提交、测试和文档同步推进。

## 验收与维护

仓库提供 MIT 许可证、完整 README、来源说明、临床免责声明、可复现命令和 GitHub Actions。验收重点是可构建、可运行、同输入同输出、边界值明确、无警告检查通过，以及后续添加量表时不破坏已有 API。长期方向是形成 MoonBit 生态中可复用的评分模型与互操作层，而不是封闭的单病种应用。

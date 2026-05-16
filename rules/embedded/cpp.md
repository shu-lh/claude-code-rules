<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: 嵌入式 C++ 项目
过期条件: none
-->

# Embedded C++ Conventions [SHOULD]

扩展 `rules/core.md`。仅包含改变行为的规则——不重复已知正确的事。

## 1. Language Features [SHOULD]

- 不使用 RTTI（运行时类型识别）
- 不使用 C++ 异常
- C++17 标准

## 2. Memory Management [SHOULD]

- 优先静态分配（编译期确定大小）
- 动态内存仅用于 FreeRTOS 对象创建（由 RTOS heap 管理）
- 不在 ISR 或硬实时任务中使用 new/delete
- 使用 `constexpr` 和 `static_assert` 在编译期捕获错误

## 3. ISR Safety [MUST]

- ISR 中可用的 FreeRTOS API：仅 `...FromISR` 后缀的函数
- ISR 中不使用 `printf` 或复杂格式化（用轻量环形缓冲替代）
- `volatile` 仅用于真正的硬件寄存器访问，不滥用

## 4. HAL Pattern [SHOULD]

- 外设驱动通过抽象接口与上层解耦
- BSP 驱动继承 HAL 接口，便于测试时注入 mock
- 全局唯一外设可使用 Singleton 或依赖注入

<!--
生效日期: 2026-05-17
最后触发: 2026-05-17
适用条件: 嵌入式项目
过期条件: none
-->

# Embedded Systems Hard Constraints [MUST]

## 1. Memory Budget [MUST]

所有动态分配必须有预算上限。堆 + 栈 + 静态数据 < 总 SRAM。

- 不在 ISR 中动态分配内存
- 不在硬实时任务中使用 malloc/new
- 静态分配优先于动态分配

### Project Instantiation
从项目中提取的具体参数：
- MCU SRAM 总量（从 linker script 或 datasheet 获取）
- RTOS heap 大小（从 RTOS 配置文件获取）
- 各任务栈大小（从任务创建代码获取）
- 写入项目 .claude/rules/ 中的具体数值

## 2. Real-Time Constraints [MUST]

- ISR 中禁止阻塞操作（信号量获取、队列接收、延时）
- 控制任务中禁止长时间操作（> 任务周期的 50%）
- 中断优先级严格遵从 RTOS 定义的最大系统调用中断优先级

### Project Instantiation
从项目中提取：
- 控制任务周期及超时阈值
- ISR 允许的最大执行时间
- 中断优先级分配表
- 写入项目 .claude/rules/ 中的实时约束文件

## 3. Peripheral Access [MUST]

- 外设寄存器操作必须通过 BSP 层，不允许上层直接访问
- 修改外设配置前确认不影响其他使用者
- 引脚复用变更必须与硬件原理图核对

### Project Instantiation
- 列出项目外设引脚分配（来自项目硬件文档）
- 标注共享外设
- 写入项目 .claude/rules/ 中的硬件约束文件

## 4. Flash Storage [MUST]

- Flash 写入前必须擦除
- 不在中断中操作 Flash
- 考虑写入寿命（避免频繁写入同一位置）

## 5. Generated/Vendor Code [MUST]

厂商 SDK、RTOS 内核源码、中间件库等第三方代码禁止修改。
仅可修改项目自行维护的配置文件和移植代码。

### Project Instantiation
在项目规则中列出所有 generated/vendor code 的具体路径和例外项。

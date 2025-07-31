# ProcessHandler 类文档

> `ProcessHandler` 是一个用于管理进程状态的工具类，主要用于跟踪和控制进程的繁忙与空闲状态。它提供了一种简单的方式，通过添加和移除进程符号来动态管理进程状态，并通过信号通知外部状态的变化。

## 类结构

```gdscript
extends Node
class_name ProcessHandler
```

## 功能描述

### 静态方法

- **`init()`**
  - **功能**：初始化 `ProcessHandler` 实例。
  - **返回值**：返回一个 `ProcessHandler` 实例。
  - **示例**：
    ```gdscript
    var handler = ProcessHandler.init()
    ```

- **`add(process_symbol: String)`**
  - **功能**：将一个进程符号添加到管理列表中。
  - **参数**：
    - `process_symbol`：要添加的进程符号（字符串类型）。
  - **注意事项**：
    - 如果 `ProcessHandler` 未初始化，会抛出错误。
    - 如果进程符号已存在，会抛出错误。
  - **示例**：
    ```gdscript
    ProcessHandler.add("my_process")
    ```

- **`remove(process_symbol: String)`**
  - **功能**：从管理列表中移除一个进程符号。
  - **参数**：
    - `process_symbol`：要移除的进程符号（字符串类型）。
  - **注意事项**：
    - 如果 `ProcessHandler` 未初始化，会抛出错误。
    - 如果进程符号不存在，会抛出错误。
  - **示例**：
    ```gdscript
    ProcessHandler.remove("my_process")
    ```

### 信号

- **`on_buzy`**
  - **触发条件**：当进程状态变为繁忙时触发。
  - **用途**：可用于通知外部系统进程已进入繁忙状态。

- **`on_normal`**
  - **触发条件**：当进程状态变为正常时触发。
  - **用途**：可用于通知外部系统进程已恢复到正常状态。

### 常量

- **`BUZY`**
  - **值**：`0`
  - **含义**：表示进程处于繁忙状态。

- **`NORMAL`**
  - **值**：`1`
  - **含义**：表示进程处于正常状态。

### 实例变量

- **`list`**
  - **类型**：`Array`
  - **用途**：存储当前管理的进程符号列表。

- **`state`**
  - **类型**：`int`
  - **用途**：表示当前的进程状态（`BUZY` 或 `NORMAL`）。

## 内部方法

- **`_handle_to_buzy()`**
  - **功能**：当进程列表非空且当前状态为正常时，将状态切换为繁忙，并触发 `on_buzy` 信号。

- **`_handle_to_normal()`**
  - **功能**：当进程列表为空且当前状态为繁忙时，将状态切换为正常，并触发 `on_normal` 信号。

## 使用示例

### 初始化管理器

```gdscript
var handler = ProcessHandler.init()
```

### 添加进程

```gdscript
ProcessHandler.add("process_1")
ProcessHandler.add("process_2")
```

### 移除进程

```gdscript
ProcessHandler.remove("process_1")
```

### 监听信号

```gdscript
func _ready():
    ProcessHandler.connect("on_buzy", self, "_on_buzy")
    ProcessHandler.connect("on_normal", self, "_on_normal")

func _on_buzy():
    print("进程状态变为繁忙")

func _on_normal():
    print("进程状态变为正常")
```

## 注意事项

1. **初始化**：在使用 `ProcessHandler` 的任何功能之前，必须先调用 `init()` 方法进行初始化。
2. **重复添加**：不允许添加重复的进程符号，否则会抛出错误。
3. **移除不存在的进程**：尝试移除不存在的进程符号时，会抛出错误。
4. **状态切换**：只有在进程列表为空时，状态才会切换为正常；只有在进程列表非空时，状态才会切换为繁忙。

## 贡献

欢迎提交问题和改进意见，帮助我们不断完善 `ProcessHandler` 类。

---

希望这个 `README` 文档对你有帮助！如果有其他需求或需要进一步调整，请随时告诉我。

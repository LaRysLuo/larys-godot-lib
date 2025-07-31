# StringUtils 使用说明

## 说明
提供一组常用的字符串处理静态函数，便于在游戏或工具中快速调用。

---


## 静态类方法

### `random_string(length: int = 4) -> String`

生成由大写英文字母和数字组成的随机字符串，默认长度为 `4`。

### `is_blank(text: String) -> bool`

判断字符串是否为空或只包含空白字符（如空格、换行、制表符等）。
---

## 💡 示例

```gdscript
var code = StringUtils.random_string()        # 如 "A9K2"

if StringUtils.is_blank("   \t\n"):           # 返回 true
    print("字符串为空或仅有空格")
```

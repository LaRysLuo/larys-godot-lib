extends Node
class_name StringUtils

## 随机生成4位字符串
static func random_string(length: int = 4) -> String:
    const charset := "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var rng := RandomNumberGenerator.new()
    rng.randomize()
    
    var result := ""
    for i in length:
        var idx = rng.randi_range(0, charset.length() - 1)
        result += charset[idx]
    return result

## 判断字符串是否为空
static func is_blank(text: String) -> bool:
    return text.strip_edges() == ""

 
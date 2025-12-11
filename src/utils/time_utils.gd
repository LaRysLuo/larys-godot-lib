extends Node
class_name TimeUtils

## 将秒转为特定的时间格式返回
static  func format_seconds_to_hms(total_seconds:int) -> Dictionary:
    var h = total_seconds / 3600
    var m = (total_seconds % 3600) / 60
    var s = total_seconds % 60
    return {"h": h, "m": m, "s": s}
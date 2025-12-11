# ArrayUtils.gd
class_name ArrayUtils

## 找出符合
static func find_key(dict:Array,key_name:String,key_value:String):
    var filters = dict.filter(func(i): return i.get(key_name) == key_value)
    if filters.is_empty(): return {}
    return filters.front()

## 尝试获取数组中对应索引的值
static func try_get(arr: Array, index: int, default_value = null):
    if index < 0 or index >= arr.size():
        return default_value
    return arr[index]

## 从数组中提取指定键的值，返回一个新数组
static func pluck(arr:Array,key:String) -> Array:
    var result = []
    for item in arr:
        if item.has(key):
            result.append(item[key])
    return result

## 将字符串切割成数组
static func split(str:String,char:String) -> Array:
    var arr = str.split(char)
    var result = []
    for item in arr:
        if not item : continue
        result.append(item)
    return result


static func map(arr:Array, call:Callable) -> Array:
    var result = []
    for item in arr:
        result.append(call.call(item))
    return result
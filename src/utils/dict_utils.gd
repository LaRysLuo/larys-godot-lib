extends Node
class_name DictUtils

## 获取字典对应键的值，同时将空字符转回null，为了转换JSON文件里的数据
static func v_get(d:Dictionary,key:String,default_value = null):
    var value = d.get(key,null)
    if not value or str(value) == "": 
        return default_value
    return value

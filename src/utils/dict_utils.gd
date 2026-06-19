extends Node
class_name DictUtils

## 获取字典对应键的值，同时将空字符转回null，为了转换JSON文件里的数据
static func v_get(d:Dictionary,key:String,default_value = null):
	var value = d.get(key,null)
	if (not value or str(value) == "") and not typeof(value) == TYPE_BOOL: 
		return default_value
	return value

## 自动适配对应的属性类型，包含整型、枚举、字符串等
static func v_set(source:Object,key:String,value):
	var type = typeof(source.get(key))
	match type:
		TYPE_INT:
			source.set(key, int(value))

		TYPE_FLOAT:
			source.set(key, float(value))

		TYPE_STRING:
			source.set(key, str(value))

		TYPE_BOOL:
			source.set(key, bool(value))

		TYPE_ARRAY:
			source.set(key, value as Array)

		TYPE_DICTIONARY:
			source.set(key, value as Dictionary)

		_: source.set(key, value)
	return source


static func resource_to_dict(res: Resource) -> Dictionary:
	var d = {}
	for p in res.get_property_list():
		if p.usage & PROPERTY_USAGE_STORAGE:
			d[p.name] = res.get(p.name)
	return d

static func dump_resource(res: Resource, indent: int = 0):
	var pad = "  ".repeat(indent)

	if res == null:
		print(pad, "null")
		return

	print(pad, "[", res.get_class(), "]")

	for p in res.get_property_list():
		if p.usage & PROPERTY_USAGE_STORAGE:
			var value = res.get(p.name)

			if value is Resource:
				print(pad, p.name, " = Resource ->")
				dump_resource(value, indent + 1)

			elif value is Array:
				print(pad, p.name, " = Array:")
				for i in value:
					if i is Resource:
						dump_resource(i, indent + 2)
					else:
						print(pad, "  - ", i)

			else:
				print(pad, p.name, " = ", value)
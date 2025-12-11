extends SelectableSceneV2
class_name List

const default_item_template:PackedScene = preload("res://component/lbutton_v2/lbutton_v2.tscn")

## 单列表的组件
# 1. 数据源
var data_source:Array = []
# 2. 渲染的单元的预制体: 如果没有的话采用默认的
@export var item_template:PackedScene


## 设置数据源
func set_value(data:Array,to_active:bool = true,default_index:int = 0) -> void:
	data_source = data
	await _update_list()
	select(default_index,true)
	if to_active: activate()

func add(data:Dictionary) -> void:
	data_source.append(data)
	await _update_list()

func is_empty() -> bool:
	return data_source.is_empty()

func refresh() -> void:
	await _update_list()
	select(_select_index,true)

func contain(symbol:String) -> bool:
	for item in data_source:
		if item.get("symbol") == symbol:
			return true
	return false

## 特殊效果：移出某个列表项
func remove(_item_id:String) -> void:
	## 列表项闪烁
	## 列表项隐藏
	var find:LbuttonV2
	for item:LbuttonV2 in item_entity_children:
		if item.symbol == _item_id:
			find = item
			break
	await find.twinkle_and_disappear()



## 当前第一个元素的索引
var first_index: int = 0

## 一次性渲染的行数
@export var col_count: int = 10


# ========================
# 信号
# ========================

signal on_item_confirm()

# ========================
# 内部方法
# ========================

## 列表的父类
var item_grid: Control:
	get: return get_node("VBoxContainer")

var item_entity_children:Array[Node]:
	get: return item_grid.get_children()

func _ready() -> void:
	super._ready()
	set_handler("ok",_handle_confirm)

## [重写] 获取可选择的节点列表
func _get_item_list() -> Array[Node]:
	return item_entity_children

## [重写]当光标到达顶部：更新first_index并刷新列表
func _cursor_reached_top():
	if first_index == 0 : return false
	first_index -= 1
	await _update_list()
	select(0,true)
	return true

## [重写]当光标到达底部：更新first_index并刷新列表
func _cursor_reached_bottom(): 
	if first_index + col_count >= data_source.size(): return false
	first_index += 1
	await  _update_list()
	select(col_count - 1,true)
	return true

## 获取列表项的预制体
func _get_item_template() -> PackedScene:
	if item_template:
		return item_template
	return default_item_template

## 刷新列表
func _update_list() -> void:
	await _clear_list()
	if data_source.is_empty(): 
		_render_empty()
		return
	var new_list = data_source.slice(first_index, first_index + col_count)
	if new_list.is_empty():return
	for data:Dictionary in new_list:
		var item:ListItemBase = _get_item_template().instantiate()
		item.set_data(data)
		item_grid.add_child(item)

## 清空渲染列表
func _clear_list():
	for ent in item_entity_children:
		item_grid.remove_child(ent)
		ent.queue_free()
	await Engine.get_main_loop().process_frame

## 渲染空位
func _render_empty():
	if !_list.is_empty():return
	var item:ListItemBase = _get_item_template().instantiate()
	item.set_data({})
	item_grid.add_child(item)
	_list.append("")


## 处理确认
func _handle_confirm():
	# 处理确定事件
	var target = ArrayUtils.try_get(data_source, self._select_index)
	if !target or !target.has("usable") or !target.get("usable").call(): return false
	if target.has("callback"):
		# shut_ui为true是，会关闭该窗口，但是合成时不能这样关闭
		# if target.get("shut_ui",true):
		# 	on_item_confirm.emit()
		# 	await GameManager.get_tree().create_timer(0.4).timeout
		var r = await target.get("callback").call(on_item_confirm)
		if r: return
		else: return r

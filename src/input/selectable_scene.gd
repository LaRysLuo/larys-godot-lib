extends InputableSceneV2
class_name SelectableSceneV2

# ==============================
# 常量
# ==============================
## 横向布局
const TYPE_HORIZONTAL = 1
## 竖向布局
const TYPE_VERTICAL = 2
## 网格布局
const TYPE_GRID = 3

# ===============================
# 内部变量
# ===============================
var _select_index:int = -1
var _last_index:int = -1

## 可选择的实例（只读）
var _list:Array: 
	get: return _get_item_list()

# ==============================
# 外部调用函数
# ==============================

## 选择:变更新的选项，并将原选项变为正常
func select(index:int,reset_last:bool = false) -> void:
	if _list.is_empty():
		print("list是空的退出了")
		return
	if reset_last: self._last_index = -1
	else:
		if self._select_index != index: 
			self._last_index = self._select_index
	self._select_index = index
	print("完成选择：",self._select_index)
	_handle_select_changed(self._select_index,self._last_index,_get_symbol(self._select_index))
	on_select_changed.emit(self._select_index,self._last_index,_get_symbol(self._select_index))



# =============================
# 信号
# =============================

## [信号]当选择变更了
signal on_select_changed(index:int,last:int,symbol:String)

# ==============================
# 可重写回调函数
# ==============================

## [回调]获取可选择的节点列表 
func _get_item_list() -> Array[Node]:
	push_error("未实现_get_item_list")
	return []

## [回调]光标触及顶部
func _cursor_reached_top(): pass
## [回调]光标触及底部
func _cursor_reached_bottom(): pass

## [回调]定义列数（仅 TYPE_GRID 使用）
func _get_column_count() -> int:
	return 2

## [回调]获取选择模式
func _get_selection_mode() -> int:
	return TYPE_VERTICAL

# ==============================
# 重写生命周期函数
# ==============================

func _ready() -> void:
	_init_base_handlers()

# ==============================
# 内部函数
# ==============================

## 初始化基础输入器
func _init_base_handlers():
	print("初始化基础输入器成功")
	set_handler("cursor_move",_handle_cursor)
	pass

## 光标移动
func _handle_cursor(key:int):
	print("检测到输入:",key)
	if _list.is_empty():
		push_error("出错了，_list配置为空")
		return
	match key:
		UP: return await _cursor_up()
		DOWN: return await _cursor_down()
		LEFT: return await  _cursor_left()
		RIGHT: return await _cursor_right()


## 光标上移
func _cursor_up(): 
	if not _get_selection_mode() in [TYPE_VERTICAL,TYPE_GRID]: return
	if _select_index == 0 or (_get_selection_mode() == TYPE_GRID and _select_index < _get_column_count()): 
		return await _cursor_reached_top()

	if _get_selection_mode() == TYPE_GRID:
		select(_select_index - _get_column_count())
	else:
		select(_select_index - 1)
	return true

## 光标下移
func _cursor_down():
	if not _get_selection_mode() in [TYPE_VERTICAL,TYPE_GRID]: return
	
	if _get_selection_mode() == TYPE_GRID:
		var next_index = _select_index + _get_column_count()
		if next_index >= _list.size():
			return await _cursor_reached_bottom()
		select(next_index)
	else:
		if self._select_index >= _list.size() - 1: 
			return await  _cursor_reached_bottom()
			
		select(_select_index + 1)
	return true

func _cursor_left():
	if not _get_selection_mode() in [TYPE_HORIZONTAL, TYPE_GRID]:
		return
	# TYPE_GRID 特殊判断：最左边
	if _get_selection_mode() == TYPE_GRID and _select_index % _get_column_count() == 0:
		return 
	if _select_index == 0:
		return await _cursor_reached_top()  # 左边界也可以视作“到顶”
	select(_select_index - 1)
	return true


func _cursor_right():
	if not _get_selection_mode() in [TYPE_HORIZONTAL, TYPE_GRID]:
		return
	# TYPE_GRID 特殊判断：最右边
	if _get_selection_mode() == TYPE_GRID and _select_index % _get_column_count() == _get_column_count() - 1:
		return
	var next_index = _select_index + 1
	if next_index >= _list.size():
		return await  _cursor_reached_bottom()  # 右边界也可以视作“到底”
	select(next_index)
	return true

func _get_symbol(_index:int) -> String:
	return self._list[_index].symbol

## 处理选择变更
func _handle_select_changed(index:int,last:int,symbol:String):
	if index == -1:
		var lasted = _get_item_list()[last]
		lasted.unfocus()
		return
	var selected = _get_item_list()[index]
	selected.focus()
	if last != -1:
		var lasted = _get_item_list()[last]
		lasted.unfocus()
	return selected

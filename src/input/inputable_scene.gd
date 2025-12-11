extends Control
class_name InputableSceneV2

#region README
"""
# 简介
InputableScene是一个用于接收玩家输入的 UI 场景基类，适合用于菜单、弹窗等需要响应方向键和确认/取消输入的场景。

# 依赖
必须继承自 Control 节点，并依赖于一个全局输入管理器 InputManager配套使用。

# 功能概述
Ⅰ - 提供 set_handler() 方法注册各种输入事件
1. cursor_move 光标移动：上下左右的四方向的移动，会返回一个Int类型的key
2. ok 确认
3. cancel 返回

Ⅱ - 可见性控制：只有可见的节点才会触发输入事件

# 使用方法：

继承该基类后，可使用set_handler来添加输入事件
func _ready():
	set_handler("cursor_move", _on_cursor_move)
	set_handler("ok", _on_ok)
	set_handler("cancel", _on_cancel)
你只需注册你关心的事件，其它输入会被自动忽略。

# 高阶使用：功能型菜单扩展
在菜单中使用 "ok" 键选择按钮后，通过 symbol 来分发功能行为，实现一个简洁而可扩展的菜单系统。

set_handler("ok",_confirm_handle)
————————————————————————————————————

func _confirm_handle():
	var btn:LbuttonV2 = active_btns[selected]
	var symbol:String = btn.symbol
	if _handlers.has(symbol): _handlers.get(symbol).call()

————————————————————————————————————
每个按钮拥有一个唯一的 symbol 字符串，例如 "start_game"、"settings"、"exit"
_handlers 是一个 Dictionary，key 为 symbol，value 为回调函数
用户按下确认键时，会自动调用该按钮的对应函数

—————————————————————————————————————
set_handler("new_game",_handler_new_game)

"""
#endregion


#region 子类可调用函数

const DOWN = 0
const LEFT = 1
const RIGHT = 2
const UP = 3

## 添加输入事件
func set_handler(symbol:String,callback:Callable):
	_handlers[symbol] = callback

func toggle_disabled_handler(symbol: String, enabled: bool):  _handlers_disabled[symbol] = enabled
	   


## 移出指定输入事件
func remove_handler(symbol:String):
	_handlers.erase(symbol)

## 激活
func activate(): 
	_active = true

## 冻结
func deactivate():
	_active = false

#endregion


#region 可在子类重写的函数

## 音效的回调函数

# 光标移动
func _audio_cursor_move():
	Interpreter.play_se("select03")
	pass

# 确认
func _audio_ok():
	Interpreter.play_se("confirm")
	pass

# 取消
func _audio_cancel():
	Interpreter.play_se("cancel")
	pass

# 错误
func _audio_error():
	Interpreter.play_se("blip03")
	pass

#endregion


var _active:bool = false

var _is_running:bool = false

## 这是储存按键回调的
var _handlers = {}

## 这是禁用的按键回调
var _handlers_disabled = {}

var is_joypad := false:
	set(v):
		is_joypad = v
		_on_joypad_changed(v)

func _enter_tree() -> void:
	InputManager.on_action_pressed.connect(_handler_action_input)
	InputManager.on_joypad_input.connect(func(v:bool):is_joypad = v )

func _exit_tree() -> void:
	InputManager.on_action_pressed.disconnect(_handler_action_input)
	InputManager.on_joypad_input.disconnect(func(v:bool):is_joypad = v )

## [可重写] 当输入手柄状态变更了
func _on_joypad_changed(v:bool) -> void:
	pass

## 输入的处理
func _handler_action_input(key:int): 
	if not _active or _is_running: return
	if !visible || !self.is_visible_in_tree(): return # 如果不可见，不处理
	_is_running = true
	if key <= 3: await  __handler_cursor_move(key)
	else:
		match key:
			InputManager.KEY_A: await  __handle_ok()
			InputManager.KEY_B: await  __handle_cancel()
			InputManager.KEY_X: await  __handle_special()
			InputManager.KEY_Y: await  __handle_extra()
	_is_running = false

## 光标移动时
func __handler_cursor_move(key:int):
	if _handlers.has("cursor_move"):
		var disabled = _handlers_disabled.get("cursor_move", false)
		if disabled: 
			_audio_error()
			return
		print("触发")
		var result = await _handlers.get("cursor_move").call(key)
		if result: _audio_cursor_move()
	# else: push_error("没有注册cursor_move输入器")


## 确定时
func __handle_ok():
	if _handlers.has("ok"):
		var disabled = _handlers_disabled.get("ok", false)
		if disabled: 
			_audio_error()
			return
		var result = await _handlers.get("ok").call()
		if result == true: _audio_ok()
		elif result == false:_audio_error()


## 取消时
func __handle_cancel(): 
	if _handlers.has("cancel"): 
		var disabled = _handlers_disabled.get("cancel", false)
		if disabled: 
			_audio_error()
			return
		var res = await  _handlers.get("cancel").call()
		if res: _audio_cancel()


func __handle_special():
	if _handlers.has("special"):
		var disabled = _handlers_disabled.get("special", false)
		if disabled: 
			_audio_error()
			return
		var res = await  _handlers.get("special").call()
		if res == true:_audio_ok()
		elif res == false:_audio_error()


func __handle_extra():
	if _handlers.has("extra"):
		var disabled = _handlers_disabled.get("extra", false)
		if disabled: 
			_audio_error()
			return
		var res = await  _handlers.get("extra").call()

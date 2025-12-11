extends Node
class_name ProcessHandler
## 进程管理器

# ----------------------------------
# 对外开放的方法
# ----------------------------------
## 初始化管理器：一般需要在GM初始化
static  func init() -> ProcessHandler:
	_instance = ProcessHandler.new()
	return _instance

## 开始新的进程
static func start_new():
	if not _instance:
		push_error("ProcessHandler没有初始化")
		return
	var symbol = StringUtils.random_string(4)
	_instance._add(symbol)
	return symbol

## 移除进程
static func remove(process_symbol:String):
	if not _instance:
		push_error("ProcessHandler没有初始化")
		return
	if not _instance.list.has(process_symbol):
		push_error("不存在这样的进程")
		return
	_instance.list.erase(process_symbol)
	print("进程：%s被移出,忙碌列表中还有%s进程" % [process_symbol,_instance.list.size()])
	_instance._handle_to_normal()

static  func clear():
	if not _instance:
		push_error("ProcessHandler没有初始化")
		return
	_instance.list = []

## 是否已生成
static func is_exist():
	return _instance != null

## 判断进程处理器是否在忙碌
static func is_buzy() -> bool:
	return get_state() == BUZY

## 获取正常的信号
static var get_normal_signal:Signal:
	get: return _instance.on_normal

static func get_state() -> int:
	if not _instance: return BUZY
	return _instance.state

# --------------------------
# 信号
# --------------------------
signal on_buzy ##当进程变为繁忙
signal on_normal ## 当进程状态变为正常


const BUZY = 0 ## 忙碌

const NORMAL = 1 ## 空闲

## 管理器实例：在初始化的时候新建
static var _instance

## 储存进程的列表
var list = []

## 当前的空闲状态
var state := NORMAL


## 添加进程到列表
func _add(process_symbol:String):
	if self.list.has(process_symbol):
		push_error("错误添加了一个重复的进程")
		return
	self.list.append(process_symbol)
	self._handle_to_buzy()
	print("新进程进入:%s,忙碌列表中还有%s进程" % [process_symbol,self.list.size()])


func _handle_to_buzy():
	if not list.is_empty() && state == NORMAL:
		state =BUZY
		on_buzy.emit()

func _handle_to_normal():
	if list.is_empty() && state == BUZY:
		state = NORMAL
		on_normal.emit()

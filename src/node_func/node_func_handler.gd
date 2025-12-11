extends Node
class_name NodeFuncHandler

## 节点功能处理器
## 该类用于处理节点功能的执行和管理

static var _instance:NodeFuncHandler = null # 单例实例

var node_funcs:Dictionary = {} # 存储节点功能的字典

var node_signals:Dictionary  = {} # 存储节点信号的字典

func _enter_tree() -> void:
	# 初始化或准备工作
	_register_all_node_func()

func _exit_tree() -> void:
	# 清理工作
	_instance.queue_free()
	_instance = null

func _register_all_node_func() -> void:
	_instance = self
	# 注册所有节点功能
	for node in get_children():
		if node is NodeFuncBase:
			if node.get_name() in node_funcs:
				# 确保节点名称唯一
				push_error("节点功能名称重复：%s" % node.get_name())
				continue
				# 将节点功能添加到字典中
			node_funcs[node.get_name()] = node
			var signals = node._signals_register()
			for key in signals: if not node_signals.has(key): node_signals[key] = signals[key]




## 执行指定名称的节点功能
static func callf(func_name:String) -> void:
	# 调用指定名称的节点功能
	if not _instance:
		push_error("NodeFuncHandler instance is not initialized.")
		return
	if _instance.node_funcs.has(func_name):
		var node_func = _instance.node_funcs[func_name]
		if node_func:
			print("正在执行节点方法")
			await node_func._execute()
		else:
			push_error("NodeFunc not found: %s" % func_name)
	else:
		push_error("NodeFunc name not registered: %s" % func_name)

## 信号
static func signalf(signal_name:String):
	if not _instance:
		push_error("NodeFuncHandler instance is not initialized.")
		return null
	if _instance.node_signals.has(signal_name):
		var signalf = _instance.node_signals.get(signal_name)
		if not signalf is Signal:
			push_error("NodeFunc signal is not initialized: %s" % signal_name)
			return null
		return signalf

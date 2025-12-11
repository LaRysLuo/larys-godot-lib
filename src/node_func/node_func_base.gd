extends Node
class_name NodeFuncBase


## 节点功能基类

func _signals_register() -> Dictionary:
    return {}

## 该类提供了一个基本的接口，供其他节点功能类继承和实现
func _execute() -> void:
    # 该方法在子类中实现具体的功能
    assert(false, "This method should be overridden in a subclass.")


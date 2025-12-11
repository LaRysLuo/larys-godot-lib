extends Node
class_name Vector2iUtils

const DIRS = {
    0:Vector2i.DOWN,
    1:Vector2i.LEFT,
    2:Vector2i.RIGHT,
    3:Vector2i.UP,
    4:Vector2i.ZERO
}

## 将按逗号分隔的数字转为Vector2i
static  func split(str:String) -> Vector2i:
    var arr := str.split(",")
    if arr.size() != 2: 
        push_error("Vector2iUtils.split转换失败，传入的参数不对")
    return Vector2i(int(arr[0]),int(arr[1]))

## 计算出两个点的朝向
static func direction_to(from_pos:Vector2i, to_pos:Vector2i) -> Vector2i:
    var delta:Vector2i = to_pos - from_pos
    var dir:Vector2i = Vector2i.ZERO
    if abs(delta.x) > abs(delta.y):
        dir = Vector2i.RIGHT if delta.x > 0 else Vector2i.LEFT
    elif delta.y != 0:
        dir = Vector2i.DOWN if delta.y > 0 else Vector2i.UP
    return dir

static func get_direction(dir:int) -> Vector2i:
    return DIRS.get(dir,Vector2i.ZERO)
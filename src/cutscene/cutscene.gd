@icon("res://addons/lariklib/src/cutscene/cutscene.png")
extends CanvasLayer
class_name Cutscene

## 演出场景
# 在这个场景下必须要有一个AnimationPlayer，添加节点的时候会自动添加一个AnimationPlayer
@export_enum("普通模式:0", "动画播放器模式:1") var play_mode:int = 0 ## 0:普通模式，1:动画播放器模式

var event_loader:EventLoader:
	get:
		for item in get_children():
			if item is EventLoader:
				return item as EventLoader 
		return null


@export_category("动画播放模式参数")
## 在场景中必须得要有一个AnimationPlayer才能运行
@export var animation_player:AnimationPlayer

var fadeout_timing_callback:Callable

# ========================
# 信号
# ========================

## 已结束
signal finished

# =======================
# 生命周期重写
# =======================
func _ready() -> void: _trigger()

## 触发
func _trigger(): 
	if play_mode == 0: await event_loader.finished
	else:
		try_get_animation_player()
		for anim in animation_player.get_animation_list():
			animation_player.current_animation = anim
			animation_player.play()
			await  animation_player.animation_finished
	# 场景开始 - > 场景结束（淡出淡入) 返回到上一层OK 
	await SceneManager.backto(self.fadeout_timing_callback)
	finished.emit() #发送结束的信号

func set_fadeout_callback(callback:Callable) -> void:
	self.fadeout_timing_callback = callback

	
## 尝试获取子节点的动画播放器
func try_get_animation_player():
	if animation_player: return
	var filters = get_children().filter(func(item):return item is AnimationPlayer)
	assert(!filters.is_empty(), "Cutscene组件没有找到animation_player")
	animation_player = filters[0]

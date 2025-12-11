extends  Node
class_name EngineUtils

## 等待x帧
static func wait_frames(n:int) -> void:
	var loop = Engine.get_main_loop()
	for i in range(n):
		await loop.process_frame

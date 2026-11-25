extends Node3D

class ExplorerAvatar extends TextureRect:
	var facing := 1.0

const GOLD := Color("#ffd77a")
const INK := Color("#10273a")
const CREAM := Color("#fff7e5")
const MUTED := Color("#b5c7cb")
const FONT_PATH := "res://assets/fonts/NotoSansTC-VF.ttf"
const ROOM_PATH := "res://assets/pixel_dream_shop.svg"
const MORNING_ROUTE_PATH := "res://assets/morning_school_route.svg"
const CLASSROOM_PATH := "res://assets/school_classroom.svg"

var font: Font
var ui: CanvasLayer
var panel: PanelContainer
var content: VBoxContainer
var key_badge: Label
var score_badge: Label
var room_background: TextureRect
var level := 0
var scores := [0, 0]
var keys := 0
var view := "welcome"
var difficulty := "easy"
var day := 1
var savings := 80
var happiness := 18
var daily_allowance := 24
var toy_goal := 260
var selected_choice := -1
var pending_events: Array = []
var daily_log: Array[String] = []
var phase_points := 0
var last_delta := 0
var last_feedback := ""
var history: Array[Dictionary] = []
var game_over := false
var key_model: Node3D
var reward_spin := 0.0
var character_viewport: SubViewport
var character_model_root: Node3D
var explorer_root: Control
var avatar: ExplorerAvatar
var mission_marker: PanelContainer
var explorer_hint: Label
var mission_position := Vector2.ZERO
var touch_pad: GridContainer
var touch_action := ""

func _ready() -> void:
	font = load(FONT_PATH)
	_make_world()
	_make_ui()
	_show_welcome()

func _process(delta: float) -> void:
	if view == "explore": _move_explorer(delta)
	if is_instance_valid(key_model) and key_model.visible:
		reward_spin += delta
		key_model.rotation.y = reward_spin * 0.08

func _input(event: InputEvent) -> void:
	if view != "explore" or not event is InputEventKey or not event.pressed or event.echo:
		return
	if is_instance_valid(avatar):
		var step := Vector2.ZERO
		if event.keycode in [KEY_LEFT, KEY_A]: step.x -= 1
		if event.keycode in [KEY_RIGHT, KEY_D]: step.x += 1
		if event.keycode in [KEY_UP, KEY_W]: step.y -= 1
		if event.keycode in [KEY_DOWN, KEY_S]: step.y += 1
		_step_explorer(step)
	if event.keycode in [KEY_E, KEY_ENTER, KEY_SPACE]: try_interact()

func _step_explorer(direction: Vector2) -> void:
	if direction == Vector2.ZERO or not is_instance_valid(avatar): return
	var size := get_viewport().get_visible_rect().size
	avatar.position += direction.normalized() * 38.0
	avatar.position.x = clampf(avatar.position.x, 28, size.x - avatar.size.x - 28)
	avatar.position.y = clampf(avatar.position.y, size.y * 0.40, size.y - avatar.size.y - 12)
	if direction.x != 0: _face_explorer(signf(direction.x))
	avatar.queue_redraw()
	_update_interaction_hint()

func _move_explorer(delta: float) -> void:
	if not is_instance_valid(avatar): return
	var direction := Vector2.ZERO
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A): direction.x -= 1
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D): direction.x += 1
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W): direction.y -= 1
	if Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S): direction.y += 1
	match touch_action:
		"left": direction.x -= 1
		"right": direction.x += 1
		"up": direction.y -= 1
		"down": direction.y += 1
	if direction.length() > 0:
		direction = direction.normalized()
		if direction.x != 0: _face_explorer(signf(direction.x))
		var size := get_viewport().get_visible_rect().size
		avatar.position += direction * 250.0 * delta
		avatar.position.x = clampf(avatar.position.x, 28, size.x - avatar.size.x - 28)
		avatar.position.y = clampf(avatar.position.y, size.y * 0.40, size.y - avatar.size.y - 12)
		avatar.queue_redraw()
	_update_interaction_hint()

func _face_explorer(horizontal_direction: float) -> void:
	if not is_instance_valid(avatar): return
	avatar.facing = horizontal_direction
	if is_instance_valid(character_model_root):
		character_model_root.rotation.y = -PI * 0.5 if horizontal_direction > 0 else PI * 0.5

func _explorer_point() -> Vector2:
	if not is_instance_valid(avatar): return Vector2.ZERO
	return avatar.position + Vector2(avatar.size.x * 0.5, avatar.size.y * 0.90)

func try_interact() -> void:
	if view != "explore" or not is_instance_valid(avatar): return
	if _explorer_point().distance_to(mission_position) > 92.0:
		explorer_hint.text = "再靠近一點，才能和任務人物說話喔！"
		return
	panel.visible = true
	_show_day_mission()

func _update_interaction_hint() -> void:
	if view != "explore" or not is_instance_valid(avatar): return
	var near := _explorer_point().distance_to(mission_position) <= 92.0
	explorer_hint.text = ("點任務牌或按 E／Enter，開始第 %d 天任務！" % day) if near else "用方向鍵走到發亮的任務地點。"
	if is_instance_valid(mission_marker): mission_marker.modulate = Color.WHITE if near else Color(0.83, 0.83, 0.83, 0.94)

func _create_touch_button(caption: String, action_name: String) -> Button:
	var step := Vector2.LEFT if action_name == "left" else Vector2.RIGHT if action_name == "right" else Vector2.UP if action_name == "up" else Vector2.DOWN
	var button := _button(caption, func(): _step_explorer(step))
	button.custom_minimum_size = Vector2(48, 42)
	button.button_down.connect(func(): touch_action = action_name)
	button.button_up.connect(func(): if touch_action == action_name: touch_action = "")
	return button

func _show_exploration() -> void:
	view = "explore"
	panel.visible = false
	_clear()
	var at_school := day == 5 or day >= 8
	room_background.texture = load(CLASSROOM_PATH if at_school else MORNING_ROUTE_PATH)
	room_background.visible = true
	var size := get_viewport().get_visible_rect().size
	avatar = ExplorerAvatar.new()
	avatar.name = "PlayerExplorer"
	avatar.texture = character_viewport.get_texture()
	avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	avatar.custom_minimum_size = Vector2(104, 136)
	avatar.size = Vector2(104, 136)
	avatar.position = Vector2(size.x * 0.16 - 52, size.y * 0.76 - 122)
	avatar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	avatar.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	explorer_root.add_child(avatar)
	if is_instance_valid(character_model_root): character_model_root.rotation.y = 0.0
	mission_position = Vector2(size.x * (0.73 if at_school else 0.51), size.y * 0.62)
	mission_marker = _panel(Color("#fff0ba"), 0.98)
	mission_marker.position = mission_position - Vector2(70, 43)
	mission_marker.custom_minimum_size = Vector2(140, 86)
	explorer_root.add_child(mission_marker)
	var marker_button := _button("✦ %s ✦\n點我互動" % _location_name(), try_interact, true)
	marker_button.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mission_marker.add_child(marker_button)
	var banner := _label("第 %d 關・第 %d 天　%s" % [level, day, "校園・教室" if at_school else "上學路與生活任務"], 19, CREAM)
	banner.position = Vector2(30, 82)
	banner.size = Vector2(380, 42)
	explorer_root.add_child(banner)
	explorer_hint = _label("用方向鍵走到發亮的任務地點。", 16, GOLD)
	explorer_hint.position = Vector2(30, 122)
	explorer_hint.size = Vector2(570, 42)
	explorer_root.add_child(explorer_hint)
	var interact := _button("互動 E", try_interact, true)
	interact.anchor_left = 1
	interact.anchor_right = 1
	interact.anchor_top = 1
	interact.anchor_bottom = 1
	interact.offset_left = -174
	interact.offset_right = -26
	interact.offset_top = -90
	interact.offset_bottom = -34
	explorer_root.add_child(interact)
	touch_pad = GridContainer.new()
	touch_pad.columns = 3
	touch_pad.anchor_top = 1
	touch_pad.anchor_bottom = 1
	touch_pad.offset_left = 24
	touch_pad.offset_top = -156
	touch_pad.offset_bottom = -16
	touch_pad.add_child(Control.new())
	touch_pad.add_child(_create_touch_button("▲", "up"))
	touch_pad.add_child(Control.new())
	touch_pad.add_child(_create_touch_button("◀", "left"))
	touch_pad.add_child(_create_touch_button("▼", "down"))
	touch_pad.add_child(_create_touch_button("▶", "right"))
	explorer_root.add_child(touch_pad)
	_update_badge()

func _location_name() -> String:
	if day == 1: return "早餐店"
	if day == 8: return "橡皮擦任務"
	if day == 9: return "班級花園"
	if day == 10: return "早餐店與玩具目標"
	return "今日任務"

func _resume_exploration() -> void:
	_show_exploration()

func _make_world() -> void:
	var env := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#c6a47c")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#fff0d2")
	environment.ambient_light_energy = 0.8
	env.environment = environment
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-60, -24, 0)
	sun.light_color = Color("#ffe3b4")
	sun.light_energy = 0.65
	add_child(sun)
	var camera := Camera3D.new()
	camera.position = Vector3(-5.3, 2.2, 6.5)
	camera.rotation_degrees = Vector3(-8, 0, 0)
	camera.fov = 35
	camera.current = true
	add_child(camera)
	var key_scene: PackedScene = load("res://assets/dream_key.glb")
	if key_scene:
		key_model = key_scene.instantiate()
		key_model.position = Vector3(-6.6, 1.15, 1.6)
		key_model.scale = Vector3.ONE * 0.35
		key_model.visible = false
		add_child(key_model)
	_make_character_preview()

func _make_character_preview() -> void:
	character_viewport = SubViewport.new()
	character_viewport.name = "DreamExplorer3DViewport"
	character_viewport.size = Vector2i(256, 320)
	character_viewport.transparent_bg = true
	character_viewport.own_world_3d = true
	character_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(character_viewport)
	var stage := Node3D.new()
	stage.name = "ExplorerStudio"
	character_viewport.add_child(stage)
	var environment_node := WorldEnvironment.new()
	var studio_environment := Environment.new()
	studio_environment.background_mode = Environment.BG_COLOR
	studio_environment.background_color = Color(0, 0, 0, 0)
	studio_environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	studio_environment.ambient_light_color = Color("#ffe7c2")
	studio_environment.ambient_light_energy = 0.62
	studio_environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment_node.environment = studio_environment
	stage.add_child(environment_node)
	var key_light := DirectionalLight3D.new()
	key_light.rotation_degrees = Vector3(-25, -25, 0)
	key_light.light_color = Color("#fff0d7")
	key_light.light_energy = 1.15
	stage.add_child(key_light)
	var fill_light := OmniLight3D.new()
	fill_light.position = Vector3(1.4, 1.8, 2.4)
	fill_light.light_color = Color("#a6d6d3")
	fill_light.light_energy = 0.35
	fill_light.omni_range = 5.0
	stage.add_child(fill_light)
	var character_camera := Camera3D.new()
	character_camera.position = Vector3(0, 1.05, 4.0)
	character_camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	character_camera.size = 2.05
	character_camera.current = true
	stage.add_child(character_camera)
	character_camera.look_at(Vector3(0, 0.93, 0), Vector3.UP)
	var character_scene: PackedScene = load("res://assets/dream_explorer.glb")
	if character_scene:
		character_model_root = character_scene.instantiate()
		character_model_root.name = "BlenderDreamExplorer"
		character_model_root.scale = Vector3.ONE * 0.96
		character_model_root.rotation.y = 0.0
		stage.add_child(character_model_root)

func _add_box(label: String, pos: Vector3, size: Vector3, color: Color, metallic: float) -> void:
	var mesh := BoxMesh.new()
	mesh.size = size
	var body := MeshInstance3D.new()
	body.name = label
	body.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = metallic
	material.roughness = 0.42
	body.material_override = material
	body.position = pos
	add_child(body)

func _add_sphere(label: String, pos: Vector3, radius: float, color: Color, metallic: float) -> void:
	var body := MeshInstance3D.new()
	body.name = label
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2
	mesh.radial_segments = 12
	mesh.rings = 8
	body.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = metallic
	material.roughness = 0.3
	body.material_override = material
	body.position = pos
	add_child(body)

func _add_cylinder(label: String, pos: Vector3, radius: float, height: float, color: Color) -> void:
	var body := MeshInstance3D.new()
	body.name = label
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius * 1.15
	mesh.height = height
	mesh.radial_segments = 8
	body.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	body.material_override = material
	body.position = pos
	add_child(body)

func _make_ui() -> void:
	ui = CanvasLayer.new()
	add_child(ui)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_PASS
	ui.add_child(root)
	room_background = TextureRect.new()
	room_background.name = "PixelArtDreamShop"
	room_background.texture = load(ROOM_PATH)
	room_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	room_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	room_background.stretch_mode = TextureRect.STRETCH_SCALE
	room_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(room_background)
	explorer_root = Control.new()
	explorer_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	explorer_root.mouse_filter = Control.MOUSE_FILTER_PASS
	root.add_child(explorer_root)
	var title := _label("小小夢魔  ｜  星夜上學路", 25, GOLD)
	title.position = Vector2(34, 22)
	title.size = Vector2(520, 42)
	root.add_child(title)
	var scorebar := _panel(Color("#f4e6ca"), 0.97)
	scorebar.anchor_left = 1
	scorebar.anchor_right = 1
	scorebar.offset_left = -390
	scorebar.offset_right = -30
	scorebar.offset_top = 20
	scorebar.offset_bottom = 68
	root.add_child(scorebar)
	var badge_row := HBoxContainer.new()
	badge_row.alignment = BoxContainer.ALIGNMENT_CENTER
	badge_row.add_theme_constant_override("separation", 18)
	scorebar.add_child(badge_row)
	key_badge = _label("鑰匙 %d / 2" % keys, 17, CREAM)
	key_badge.custom_minimum_size = Vector2(132, 36)
	key_badge.autowrap_mode = TextServer.AUTOWRAP_OFF
	key_badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	score_badge = _label("得分 %d" % (scores[0] + scores[1]), 17, CREAM)
	score_badge.custom_minimum_size = Vector2(110, 36)
	score_badge.autowrap_mode = TextServer.AUTOWRAP_OFF
	score_badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	badge_row.add_child(key_badge)
	badge_row.add_child(score_badge)
	panel = _panel(Color("#f4e6ca"), 0.97)
	panel.anchor_left = 0.52
	panel.anchor_right = 0.96
	panel.anchor_top = 0.13
	panel.anchor_bottom = 0.91
	panel.offset_left = 0
	panel.offset_right = 0
	panel.offset_top = 0
	panel.offset_bottom = 0
	root.add_child(panel)
	_layout_ui()
	get_viewport().size_changed.connect(_layout_ui)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 30)
	margin.add_theme_constant_override("margin_right", 30)
	margin.add_theme_constant_override("margin_top", 26)
	margin.add_theme_constant_override("margin_bottom", 24)
	panel.add_child(margin)
	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 13)
	margin.add_child(content)

func _panel(color: Color, alpha: float) -> PanelContainer:
	var p := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(color.r, color.g, color.b, alpha)
	style.border_color = Color("#8f6848")
	style.set_border_width_all(4)
	style.set_corner_radius_all(0)
	p.add_theme_stylebox_override("panel", style)
	return p

func _label(text_value: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color("#3d3027") if color == CREAM or color == MUTED else Color("#76502d") if color == GOLD else Color("#3e674b"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _clear() -> void:
	if is_instance_valid(avatar): avatar.queue_free()
	if is_instance_valid(mission_marker): mission_marker.queue_free()
	if is_instance_valid(touch_pad): touch_pad.queue_free()
	avatar = null
	mission_marker = null
	touch_pad = null
	if is_instance_valid(explorer_hint): explorer_hint.queue_free()
	explorer_hint = null
	for child in explorer_root.get_children():
		explorer_root.remove_child(child)
		child.queue_free()
	if is_instance_valid(room_background): room_background.visible = true
	for child in content.get_children():
		content.remove_child(child)
		child.queue_free()
	if is_instance_valid(key_model):
		key_model.visible = false

func _heading(kicker: String, title_text: String, body: String) -> void:
	content.add_child(_label(kicker, 14, Color("#64805f")))
	content.add_child(_label(title_text, 28, CREAM))
	content.add_child(_label(body, 16, MUTED))

func _button(caption: String, callback: Callable, primary := false) -> Button:
	var b := Button.new()
	b.text = caption
	b.custom_minimum_size = Vector2(150, 48)
	b.add_theme_font_override("font", font)
	b.add_theme_font_size_override("font_size", 17)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("#d28b4f") if primary else Color("#66816b")
	normal.border_color = Color("#8c5839") if primary else Color("#465f4c")
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(0)
	b.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate()
	hover.bg_color = Color("#e2a46b") if primary else Color("#82977a")
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_color_override("font_color", Color("#fff7e5"))
	b.pressed.connect(callback)
	return b

func _row() -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 9)
	content.add_child(row)
	return row

func _show_welcome() -> void:
	view = "welcome"
	_clear()
	room_background.texture = load(MORNING_ROUTE_PATH)
	room_background.visible = true
	_heading("星夜校園・十天存錢挑戰", "從家裡走到學校", "連續十天安排零用錢與快樂值，朝玩具存錢目標前進。每天先走到場景任務點，再選擇並確認方案。")
	content.add_child(_label("早餐店、遺失的橡皮擦、雨天和班級花園都會帶來不同選擇；有些決定隔天才會有結果。", 15, Color("#f4d99c")))
	content.add_child(_label("選擇難度", 17, CREAM))
	var row := _row()
	row.add_child(_button("簡單・目標 260 元", _start_game.bind("easy"), true))
	row.add_child(_button("普通・目標 174 元", _start_game.bind("medium")))
	row.add_child(_button("挑戰・目標 60 元", _start_game.bind("hard")))
	content.add_child(_label("方向鍵／WASD 移動，到發亮任務牌附近按 E 或點擊。手機可用畫面上的方向鈕。遊戲幣與星種都是虛構的。", 14, MUTED))

func _start_game(mode: String) -> void:
	difficulty = mode
	var settings := {"easy":{"money":80,"joy":18,"goal":260,"allowances":[24,25,24,25,24,10,10,25,24,25]},"medium":{"money":40,"joy":12,"goal":174,"allowances":[18,18,18,18,18,8,8,18,18,18]},"hard":{"money":20,"joy":6,"goal":60,"allowances":[22,22,22,22,22,10,10,22,22,22]}}
	var config: Dictionary = settings[mode]
	savings = config.money
	happiness = config.joy
	toy_goal = config.goal
	allowances = config.allowances
	day = 1
	level = 1
	keys = 0
	scores = [0,0]
	phase_points = 0
	history.clear()
	daily_log.clear()
	pending_events.clear()
	game_over = false
	_begin_day()

var allowances: Array = [24,25,24,25,24,10,10,25,24,25]

func _scenario() -> Dictionary:
	var titles := ["早餐店・選擇早餐", "文具店・鉛筆快用完", "上學路・突然下雨", "午餐時間・同學邀買點心", "教室・橡皮擦不見了！", "週末・幫家人跑差事", "玩具店・存錢目標還差多少", "教室・還是找不到橡皮擦", "班級花園・星種放在哪裡", "最後一天・早餐與玩具目標"]
	var bodies := ["從家裡出發，早餐店就在路上。", "上課需要寫字。", "今天可以準備雨具，或把錢留下。", "午餐已準備好，選擇一份點心。", "作業快開始了，今天有 %d 元。先比較需要與價格。" % daily_allowance, "週末不用買早餐。", "玩具目標 %d 元，目前存款 %d 元。" % [toy_goal,savings], "先找失物箱，再想想是否購買。", "用虛構星種做分散風險的小實驗。", "看看最後存款是否達到 %d 元。" % toy_goal]
	var options := [
		[["豆漿和小饅頭",8,0,16,"簡單早餐滿足需要，今天能存下更多。"],["飯糰和豆漿",14,1,18,"有飽足感，也留下一些錢。"],["再加買甜點",28,2,8,"今天很開心，但甜點讓可存的錢變少。"]],
		[["普通鉛筆",8,0,18,"鉛筆解決寫字需要，價格也在預算內。"],["喜歡的多色筆",16,1,13,"多色筆較有趣，也比普通鉛筆多花一些。"],["先借同學的",0,0,14,"借用能暫時省錢，記得下課歸還。"]],
		[["買耐用雨衣",15,0,17,"雨衣先花一些錢，能減少淋雨機會。"],["買便宜雨傘",8,0,15,"便宜雨傘能遮雨，但大風時可能損壞。"],["淋雨跑去學校",0,-1,8,"省下雨具錢，但淋雨讓心情不太好。"]],
		[["帶水壺，只買水果",6,1,18,"水果是點心，也避免重複買飲料。"],["和同學分享小點心",12,2,16,"分享讓人開心，記得留在預算內。"],["買最大份套餐",20,2,9,"份量很多，也花掉較多零用錢。"]],
		[["借同學並下課歸還",0,0,16,"借用暫時解決作業需要，記得歸還。"],["買普通橡皮擦",6,0,18,"普通橡皮擦足以完成作業，價格也實在。"],["買造型橡皮擦組",16,2,10,"造型很可愛，但功能相同而且花得更多。"]],
		[["先存起來，陪家人散步",0,1,18,"沒有額外花費，也安排免費休閒。"],["買二手故事書",7,2,16,"故事書帶來樂趣，二手選擇也省錢。"],["買遊戲小物和零食",14,2,10,"買之前記得看看存錢目標還差多少。"]],
		[["記下目標價，今天不買",0,0,18,"記住目標價格，幫助比較存款距離。"],["買小貼紙當獎勵",5,1,15,"小獎勵也能列進預算。"],["先買昂貴玩具",20,2,6,"現在很開心，但離原本目標更遠了。"]],
		[["找失物箱，再借同學",0,0,18,"先找找看，需要時借用，不急著花錢。"],["買普通橡皮擦",6,0,16,"普通橡皮擦能完成作業，價格較低。"],["買造型橡皮擦組",16,2,10,"造型組吸引人，但完成作業不需要多買。"]],
		[["平均放進三座花園",2,1,18,"分散能降低單一地點的影響，但不能保證不損失。"],["全放月亮花園",0,0,10,"集中很簡單，但單一地點出問題會影響全部。"],["全放雲朵花園",0,0,6,"全部集中一處，遇到變化就沒有其他花園分擔。"]],
		[["簡單早餐，把錢留給目標",6,0,18,"先安排早餐需要，再把錢留給目標。"],["喜歡的早餐和水果",17,2,14,"早餐水果讓人開心，也要看看存款能否達標。"],["大份早餐加甜點",25,2,8,"今天吃得豐盛，但目標可能還差一段距離。"]]
	]
	var allowance_note := "今天有 %d 元零用錢。" % daily_allowance
	if day == 6: allowance_note = "今天是週末，不用買早餐；零用錢 %d 元。" % daily_allowance
	return {"title":titles[day-1],"body":bodies[day-1] + " " + allowance_note,"choices":options[day-1]}

func _begin_day() -> void:
	daily_allowance = int(allowances[day-1])
	if not pending_events.is_empty():
		var event: Dictionary = pending_events.pop_front()
		savings = max(0,savings-int(event.cost))
		daily_log.append("延遲結果：" + event.text)
	_show_exploration()

func _show_day_mission() -> void:
	view = "mission"
	_clear()
	var data := _scenario()
	_heading("第 %d 天・%s" % [day,data.title], "%s\n存款 %d 元／快樂值 %d / 20" % [data.body,savings,happiness], "選擇方案先預覽結果，再按確認套用。難度：%s" % {"easy":"簡單","medium":"普通","hard":"挑戰"}[difficulty])
	if not daily_log.is_empty(): content.add_child(_label(daily_log[-1],14,Color("#64805f")))
	for i in range(data.choices.size()):
		var option: Array = data.choices[i]
		content.add_child(_button("%s　花費 %d 元" % [option[0],option[1]],_preview_choice.bind(i),selected_choice==i))
	if selected_choice >= 0:
		var chosen: Array = data.choices[selected_choice]
		var new_joy := int(chosen[2])
		if happiness > 15 and new_joy > 0: new_joy = int(ceil(new_joy/2.0))
		if happiness <= 5 and new_joy < 0: new_joy = int(floor(new_joy*1.5))
		if (day == 1 or day == 10) and happiness <= 5 and new_joy <= 0: new_joy -= 1
		content.add_child(_label("確認預覽：存款 %d 元；快樂值變化 %s%d。%s" % [savings+daily_allowance-int(chosen[1]),"+" if new_joy>0 else "",new_joy,chosen[4]],15,Color("#f4d99c")))
		var row := _row()
		row.add_child(_button("確認今天的選擇",_confirm_choice,true))
		row.add_child(_button("返回場景",_resume_exploration))

func _preview_choice(index: int) -> void:
	selected_choice = index
	_show_day_mission()

func _confirm_choice() -> void:
	var choice: Array = _scenario().choices[selected_choice]
	var new_money := savings + daily_allowance - int(choice[1])
	if new_money < 0:
		last_feedback = "錢不夠支付，請挑選預算內的方案。"
		selected_choice = -1
		_show_day_mission()
		return
	savings = new_money
	var joy_change := int(choice[2])
	if happiness > 15 and joy_change > 0: joy_change = int(ceil(joy_change/2.0))
	if happiness <= 5 and joy_change < 0: joy_change = int(floor(joy_change*1.5))
	if (day == 1 or day == 10) and happiness <= 5 and joy_change <= 0: joy_change -= 1
	happiness = clampi(happiness+joy_change,0,20)
	phase_points += int(choice[3])
	var note := "第 %d 天：%s 存款 %d 元，快樂值 %d。" % [day,choice[4],savings,happiness]
	daily_log.append(note)
	history.append({"day":day,"score":choice[3],"money":savings,"happiness":happiness,"choice":choice[0]})
	if day == 3 and selected_choice == 1: pending_events.append({"cost":5,"text":"大風弄壞雨傘，修補花了 5 元。"})
	if day == 3 and selected_choice == 2: pending_events.append({"cost":3,"text":"衣服淋濕，洗曬多花 3 元。"})
	if day == 9: pending_events.append({"cost":0,"text":"夜風吹過花園；分散星種降低集中風險，但仍可能有變化。"})
	selected_choice = -1
	if happiness <= 0:
		game_over = true
		scores[0 if day<=5 else 1] = phase_points
		_show_summary(false,"快樂值用完，挑戰提早結束。下次試著平衡花費與休息。")
		return
	if day == 5 or day == 10:
		var phase := 0 if day == 5 else 1
		scores[phase] = phase_points
		level = phase + 1
		if day == 5: keys = 1
		elif savings >= toy_goal: keys = 2
		_update_badge()
		var result := "完成前五天，取得第一把鑰匙。" if day == 5 else ("存款達標，取得第二把鑰匙！" if savings>=toy_goal else "存款還差 %d 元才達到玩具目標。" % (toy_goal-savings))
		_show_reward("第 %d 關結算" % (phase+1),result,scores[phase],day==10)
		return
	day += 1
	_begin_day()

func _show_reward(title_text: String, explanation: String, earned: int, final := false) -> void:
	view = "reward"
	_clear()
	room_background.visible = false
	if is_instance_valid(key_model): key_model.visible = day == 5 or (day == 10 and savings >= toy_goal)
	_heading("月光鑰匙・關卡完成",title_text,explanation)
	content.add_child(_label("本關得分 %d / 90" % earned,23,GOLD))
	content.add_child(_label("存款 %d / %d 元　快樂值 %d / 20　鑰匙 %d / 2" % [savings,toy_goal,happiness,keys],16,CREAM))
	var row := _row()
	if final: row.add_child(_button("看看我的進步",_show_summary.bind(savings>=toy_goal)))
	else: row.add_child(_button("繼續下一天",_continue_challenge,true))

func _continue_challenge() -> void:
	if day == 5:
		day = 6
		level = 2
		phase_points = 0
	_begin_day()

func _show_summary(won: bool = true, note: String = "") -> void:
	view = "summary"
	_clear()
	_heading("探險完成・我的學習成果","十天存錢挑戰回顧","分數用來回顧練習，不代表能力高低。")
	content.add_child(_label("第一關・家到學校（第 1–5 天）　%d / 90 分" % scores[0],19,GOLD))
	content.add_child(_label("第二關・校園與存錢目標（第 6–10 天）　%d / 90 分" % scores[1],19,GOLD))
	content.add_child(_label("總分 %d / 180　存款 %d / %d 元" % [scores[0]+scores[1],savings,toy_goal],23,CREAM))
	content.add_child(_label("快樂值 %d / 20　月光鑰匙 %d / 2" % [happiness,keys],17,CREAM))
	content.add_child(_label("學到：分辨需要和想要、設定存錢目標、留意延遲花費；分散投資能降低集中風險，但不能保證不損失。",16,MUTED))
	content.add_child(_label(note if note!="" else ("太棒了，存款達到玩具目標！" if won else "再試一次，調整每天的花費安排。"),15,Color("#9cd9ce")))
	var row := _row()
	row.add_child(_button("重新挑戰",_show_welcome,true))
	_update_badge()

func _layout_ui() -> void:
	if not is_instance_valid(panel): return
	var narrow := get_viewport().get_visible_rect().size.x < 900
	panel.anchor_left = 0.06 if narrow else 0.45
	panel.anchor_right = 0.96
	panel.anchor_top = 0.15 if narrow else 0.13
	panel.anchor_bottom = 0.95 if narrow else 0.91
	panel.offset_left = 0
	panel.offset_right = 0
	panel.offset_top = 0
	panel.offset_bottom = 0

func _update_badge() -> void:
	if is_instance_valid(key_badge):
		key_badge.text = "鑰匙 %d / 2" % keys
	if is_instance_valid(score_badge):
		score_badge.text = "得分 %d" % (scores[0] + scores[1])

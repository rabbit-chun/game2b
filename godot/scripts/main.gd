extends Node3D

class ExplorerAvatar extends Control:
	var facing := 1.0
	func _draw() -> void:
		draw_rect(Rect2(11, 1, 18, 13), Color("#f0c69a"))
		draw_rect(Rect2(7, 0, 25, 7), Color("#d59a45"))
		draw_rect(Rect2(10, 14, 21, 19), Color("#e9bd48"))
		draw_rect(Rect2(13, 20, 4, 3), Color("#312b36"))
		draw_rect(Rect2(24, 20, 4, 3), Color("#312b36"))
		draw_rect(Rect2(13, 33, 7, 6), Color("#47364a"))
		draw_rect(Rect2(23, 33, 7, 6), Color("#47364a"))
		draw_rect(Rect2(12 if facing > 0 else 25, 7, 3, 3), Color("#322b35"))

const GOLD := Color("#ffd77a")
const INK := Color("#10273a")
const CREAM := Color("#fff7e5")
const MUTED := Color("#b5c7cb")
const FONT_PATH := "res://assets/fonts/NotoSansTC-VF.ttf"
const ROOM_PATH := "res://assets/pixel_dream_shop.svg"

var font: Font
var ui: CanvasLayer
var panel: PanelContainer
var content: VBoxContainer
var key_badge: Label
var score_badge: Label
var room_background: TextureRect
var level := 0
var counts := [0, 0, 0]
var scores := [0, 0]
var keys := 0
var view := "welcome"
var key_model: Node3D
var reward_spin := 0.0
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
	avatar.position.x = clampf(avatar.position.x, 28, size.x - 48)
	avatar.position.y = clampf(avatar.position.y, size.y * 0.40, size.y - 70)
	if direction.x != 0: avatar.facing = signf(direction.x)
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
		if direction.x != 0: avatar.facing = signf(direction.x)
		var size := get_viewport().get_visible_rect().size
		avatar.position += direction * 250.0 * delta
		avatar.position.x = clampf(avatar.position.x, 28, size.x - 48)
		avatar.position.y = clampf(avatar.position.y, size.y * 0.40, size.y - 70)
		avatar.queue_redraw()
	_update_interaction_hint()

func try_interact() -> void:
	if view != "explore" or not is_instance_valid(avatar): return
	if avatar.position.distance_to(mission_position) > 92.0:
		explorer_hint.text = "再靠近一點，才能和任務人物說話喔！"
		return
	panel.visible = true
	if level == 1: _show_shop()
	else: _show_gardens()

func _update_interaction_hint() -> void:
	if view != "explore" or not is_instance_valid(avatar): return
	var near := avatar.position.distance_to(mission_position) <= 92.0
	explorer_hint.text = "按 E／Enter 或下方互動鈕，開始任務！" if near else "用方向鍵走到發亮的任務地點。"
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
	room_background.visible = true
	var size := get_viewport().get_visible_rect().size
	avatar = ExplorerAvatar.new()
	avatar.name = "PlayerExplorer"
	avatar.custom_minimum_size = Vector2(38, 40)
	avatar.position = Vector2(size.x * 0.16, size.y * 0.76)
	explorer_root.add_child(avatar)
	mission_position = Vector2(size.x * 0.73, size.y * 0.62)
	mission_marker = _panel(Color("#fff0ba"), 0.98)
	mission_marker.position = mission_position - Vector2(70, 43)
	mission_marker.custom_minimum_size = Vector2(140, 86)
	explorer_root.add_child(mission_marker)
	var marker_text := _label("✦ 任務 ✦\n%s" % ("月光雜貨店" if level == 1 else "星苗花園"), 17, GOLD)
	marker_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	marker_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mission_marker.add_child(marker_text)
	var banner := _label("第 %d 關　%s" % [level, "月光雜貨店" if level == 1 else "星苗花園"], 19, CREAM)
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
	var title := _label("小小夢魔  ｜  月光玩具盒", 25, GOLD)
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
	_heading("星夜校園・理財小任務", "替願望留一把鑰匙", "在月光雜貨店練習分配小小預算，再到星苗花園認識分散風險。每關一把鑰匙，做完看看自己學會了什麼。")
	content.add_child(_label("沒有真實金錢，也沒有投資商品；可以慢慢試，答錯也能再來。", 15, Color("#f4d99c")))
	var row := _row()
	row.add_child(_button("開始探險", _start_level_one, true))
	content.add_child(_label("操作：使用方向鍵移動，走近發亮的任務地點後按 E。手機可用畫面上的方向鈕。", 14, MUTED))

func _start_level_one() -> void:
	level = 1
	counts = [0, 0, 0]
	_show_game()

func _start_level_two() -> void:
	level = 2
	counts = [0, 0, 0]
	_show_game()

func _show_game(message := "") -> void:
	if view == "game":
		if level == 1: _show_shop(message)
		else: _show_gardens(message)
	else:
		_show_exploration()

func _counter_row(index: int, title_text: String, detail: String) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	content.add_child(row)
	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_child(_label(title_text, 17, CREAM))
	info.add_child(_label(detail, 13, MUTED))
	row.add_child(info)
	var minus := _button("−", func(): _change_count(index, -1), false)
	minus.custom_minimum_size = Vector2(54, 48)
	row.add_child(minus)
	var count_label := _label(str(counts[index]), 20, GOLD)
	count_label.custom_minimum_size = Vector2(34, 48)
	count_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	count_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(count_label)
	var plus := _button("＋", func(): _change_count(index, 1), false)
	plus.custom_minimum_size = Vector2(54, 48)
	row.add_child(plus)

func _change_count(index: int, amount: int) -> void:
	var cap := 10 if level == 1 else 6
	var total: int = counts[0] + counts[1] + counts[2]
	if amount > 0 and total >= cap:
		return
	counts[index] = max(0, int(counts[index]) + amount)
	_show_game()

func _show_shop(message: String = "") -> void:
	view = "game"
	_clear()
	_heading("第一關・月光雜貨店　｜　每關最高 90 分", "10 枚月光幣，怎麼安排？", "先照顧需要，也替一個重要願望存一點；剩下的再選喜歡的小物。把 10 枚都分完就能送出。")
	_counter_row(0, "生活需要・雨衣", "下雨時能保護自己；雨衣需要 4 枚")
	_counter_row(1, "存錢目標・星象望遠鏡", "願望可以慢慢存；投入 1 枚就開始")
	_counter_row(2, "想要的小物・星星貼紙", "喜歡的東西也可以留一點預算")
	content.add_child(_label("已分配 %d / 10 枚　　需要 %d　・　存錢 %d　・　想要 %d" % [counts[0]+counts[1]+counts[2], counts[0], counts[1], counts[2]], 15, Color("#f4d99c")))
	if message != "": content.add_child(_label(message, 14, Color("#a8dfbd")))
	var row := _row()
	row.add_child(_button("送出分配", _submit_shop, true))
	row.add_child(_button("重新分配", func(): counts = [0,0,0]; _show_game()))

func _submit_shop() -> void:
	if counts[0] + counts[1] + counts[2] != 10:
		_show_game("再分完剩下的月光幣，就能檢查看看！")
		return
	if counts[0] < 4 or counts[1] < 1:
		_show_game("小提醒：雨衣需要 4 枚，存錢目標至少放 1 枚。你可以重新安排。")
		return
	scores[0] = 30 + (30 if counts[0] >= 4 else 0) + (30 if counts[1] >= 2 else 0)
	keys = max(keys, 1)
	_update_badge()
	_show_reward("第一把鑰匙到手！", "你先照顧了需要，也讓存錢目標開始前進。選擇貼紙的數量由你決定。", scores[0], false)

func _show_gardens(message: String = "") -> void:
	view = "game"
	_clear()
	_heading("第二關・星苗花園　｜　每關最高 90 分", "6 顆星種，放進哪幾座花園？", "雲朵花園遇到夜風會少 1 顆。把種子放在不同花園，能減少集中在一處的風險；分散也不代表一定不會損失。")
	_counter_row(0, "月亮花園", "安穩的月光苗圃")
	_counter_row(1, "雲朵花園", "今晚的夜風會吹走 1 顆")
	_counter_row(2, "玻璃花園", "明亮、需要細心照看")
	content.add_child(_label("已放置 %d / 6 顆　　月亮 %d　・　雲朵 %d　・　玻璃 %d" % [counts[0]+counts[1]+counts[2], counts[0], counts[1], counts[2]], 15, Color("#f4d99c")))
	if message != "": content.add_child(_label(message, 14, Color("#a8dfbd")))
	var row := _row()
	row.add_child(_button("送出星種", _submit_gardens, true))
	row.add_child(_button("重新安排", func(): counts = [0,0,0]; _show_game()))

func _submit_gardens() -> void:
	if counts[0] + counts[1] + counts[2] != 6:
		_show_game("再放置剩下的星種，就能觀察夜風的結果。")
		return
	var occupied := 0
	for n in counts:
		if n > 0: occupied += 1
	if occupied < 2:
		_show_game("想想看：如果只放在一座花園，遇到變化時會如何？試著分到至少兩座。")
		return
	var wind_loss := 1 if counts[1] > 0 else 0
	scores[1] = 30 + 30 + (30 if occupied == 3 else 0)
	keys = 2
	_update_badge()
	_show_reward("第二把鑰匙找到啦！", "夜風帶走了雲朵花園的 %d 顆。把星種分到 %d 座花園，降低了只押一處的集中風險；分散仍不能保證不損失。" % [wind_loss, occupied], scores[1], true)

func _show_reward(title_text: String, explanation: String, earned: int, final := false) -> void:
	view = "reward"
	_clear()
	if is_instance_valid(room_background): room_background.visible = false
	if is_instance_valid(key_model): key_model.visible = true
	_heading("月光鑰匙・關卡完成", title_text, explanation)
	content.add_child(_label("本關得分　%d / 90" % earned, 23, GOLD))
	content.add_child(_label("目前累積　%d / 180　　鑰匙　%d / 2" % [scores[0]+scores[1], keys], 16, CREAM))
	var row := _row()
	if final:
		row.add_child(_button("看看我的進步", _show_summary, true))
	else:
		row.add_child(_button("走向星苗花園", _start_level_two, true))
		row.add_child(_button("再玩第一關", _start_level_one))

func _show_summary() -> void:
	view = "summary"
	_clear()
	_heading("探險完成・我的學習成果", "兩把月光鑰匙都收集完成", "你的分數反映這次任務中的選擇，不代表能力高低。每一次重新安排，都是一次練習。")
	content.add_child(_label("月光雜貨店　%d / 90　　星苗花園　%d / 90" % [scores[0], scores[1]], 19, GOLD))
	content.add_child(_label("總分　%d / 180" % (scores[0] + scores[1]), 25, CREAM))
	content.add_child(_label("我學會：先分清需要與想要，並替目標預留存款。", 16, MUTED))
	content.add_child(_label("我也學會：把資源分散可降低集中風險，但結果仍不確定。", 16, MUTED))
	content.add_child(_label("這次得分只記在目前遊戲頁面；沒有收集個人資料。", 14, Color("#9cd9ce")))
	var row := _row()
	row.add_child(_button("重新探險", func(): scores = [0,0]; keys = 0; _show_welcome(), true))
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


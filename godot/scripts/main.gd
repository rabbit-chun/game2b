extends Node3D

const GOLD := Color("#ffd77a")
const INK := Color("#10273a")
const CREAM := Color("#fff7e5")
const MUTED := Color("#b5c7cb")
const FONT_PATH := "res://assets/fonts/NotoSansTC-VF.ttf"

var font: Font
var ui: CanvasLayer
var panel: PanelContainer
var content: VBoxContainer
var score_badge: Label
var level := 0
var counts := [0, 0, 0]
var scores := [0, 0]
var keys := 0
var view := "welcome"
var key_model: Node3D
var reward_spin := 0.0

func _ready() -> void:
	font = load(FONT_PATH)
	_make_world()
	_make_ui()
	_show_welcome()

func _process(delta: float) -> void:
	if is_instance_valid(key_model) and key_model.visible:
		reward_spin += delta
		key_model.rotation.y = reward_spin * 0.7

func _make_world() -> void:
	var env := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#08172b")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#92b9d0")
	environment.ambient_light_energy = 0.55
	env.environment = environment
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-52, -28, 0)
	sun.light_color = Color("#ffd99a")
	sun.light_energy = 0.9
	add_child(sun)
	var camera := Camera3D.new()
	camera.position = Vector3(0, 7.8, 12.5)
	camera.rotation_degrees = Vector3(-27, 0, 0)
	camera.current = true
	add_child(camera)
	_add_box("Moonstone courtyard", Vector3(0, -0.5, 0), Vector3(24, 0.8, 22), Color("#315b62"), 0.15)
	_add_box("Shop base", Vector3(-3.2, 1.0, -1.7), Vector3(7, 3, 4.6), Color("#244458"), 0.2)
	_add_box("Shop roof", Vector3(-3.2, 2.8, -1.7), Vector3(7.5, 0.4, 5), Color("#507b79"), 0.28)
	_add_box("Door", Vector3(-3.2, 0.3, 0.66), Vector3(1.15, 1.9, 0.16), Color("#d99855"), 0.2)
	_add_box("Window left", Vector3(-5.3, 1.35, 0.67), Vector3(1.2, 1.1, 0.14), Color("#9bd6d0"), 0.65)
	_add_box("Window right", Vector3(-1.05, 1.35, 0.67), Vector3(1.2, 1.1, 0.14), Color("#9bd6d0"), 0.65)
	_add_sphere("Moon", Vector3(-8, 5.7, -4), 1.25, Color("#f5d895"), 0.0)
	for i in range(3):
		var x := 2.0 + i * 2.3
		_add_box("Garden %d" % i, Vector3(x, -0.02, -2.3), Vector3(1.7, 0.28, 2.4), [Color("#4d8178"), Color("#53788c"), Color("#668b79")][i], 0.16)
		_add_box("Garden sign %d" % i, Vector3(x, 0.55, -3.5), Vector3(1.45, 0.42, 0.12), Color("#d4c18f"), 0.15)
		for j in range(3):
			_add_sphere("Seed light %d %d" % [i, j], Vector3(x - 0.42 + j * 0.42, 0.34, -2.25), 0.13, [Color("#d8e9a3"), Color("#c9e7ff"), Color("#ffdda5")][i], 0.3)
	# Low-poly landmark trees and lamp posts make the page feel like a quiet miniature campus.
	for x in [-8.0, 7.8]:
		_add_cylinder("Tree trunk", Vector3(x, 0.6, 2.5), 0.15, 1.2, Color("#72573c"))
		_add_sphere("Tree crown", Vector3(x, 1.65, 2.5), 0.75, Color("#79a58a"), 0.0)
	for x in [-6.1, 0.0, 8.5]:
		_add_cylinder("Moon lamp", Vector3(x, 1.15, 4.0), 0.07, 2.3, Color("#3d5661"))
		_add_sphere("Lamp glow", Vector3(x, 2.35, 4.0), 0.2, Color("#ffe5a9"), 1.2)
	var key_scene: PackedScene = load("res://assets/dream_key.glb")
	if key_scene:
		key_model = key_scene.instantiate()
		key_model.position = Vector3(-5.3, 1.15, 1.6)
		key_model.scale = Vector3.ONE * 0.95
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
	var title := _label("小小夢魔  ｜  月光玩具盒", 25, GOLD)
	title.position = Vector2(34, 22)
	title.size = Vector2(520, 42)
	root.add_child(title)
	var scorebar := _panel(Color("#10273a"), 0.82)
	scorebar.anchor_left = 1
	scorebar.anchor_right = 1
	scorebar.offset_left = -250
	scorebar.offset_right = -30
	scorebar.offset_top = 20
	scorebar.offset_bottom = 68
	root.add_child(scorebar)
	score_badge = _label("鑰匙:%d/2 得分:%d" % [keys, scores[0] + scores[1]], 17, CREAM)
	score_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	scorebar.add_child(score_badge)
	panel = _panel(Color("#10283a"), 0.92)
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
	style.border_color = Color("#78b9b0")
	style.set_border_width_all(1)
	style.set_corner_radius_all(16)
	p.add_theme_stylebox_override("panel", style)
	return p

func _label(text_value: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _clear() -> void:
	for child in content.get_children():
		content.remove_child(child)
		child.queue_free()
	if is_instance_valid(key_model):
		key_model.visible = false

func _heading(kicker: String, title_text: String, body: String) -> void:
	content.add_child(_label(kicker, 14, Color("#9cd9ce")))
	content.add_child(_label(title_text, 28, CREAM))
	content.add_child(_label(body, 16, MUTED))

func _button(caption: String, callback: Callable, primary := false) -> Button:
	var b := Button.new()
	b.text = caption
	b.custom_minimum_size = Vector2(150, 48)
	b.add_theme_font_override("font", font)
	b.add_theme_font_size_override("font_size", 17)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("#e9bb68") if primary else Color("#24475a")
	normal.border_color = Color("#ffe4a4") if primary else Color("#74a9a8")
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(12)
	b.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate()
	hover.bg_color = Color("#f5d58e") if primary else Color("#315d6d")
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_color_override("font_color", INK if primary else CREAM)
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
	content.add_child(_label("操作：點按加減按鈕分配月光幣與星種。", 14, MUTED))

func _start_level_one() -> void:
	level = 1
	counts = [0, 0, 0]
	_show_game()

func _start_level_two() -> void:
	level = 2
	counts = [0, 0, 0]
	_show_game()

func _show_game(message := "") -> void:
	view = "game"
	if level == 1:
		_show_shop(message)
	else:
		_show_gardens(message)

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

func _show_shop(message: String) -> void:
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

func _show_gardens(message: String) -> void:
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
	if is_instance_valid(key_model): key_model.visible = true
	_heading("月光鑰匙・關卡完成", title_text, explanation)
	content.add_child(_label("本關得分　%d / 90" % earned, 23, GOLD))
	content.add_child(_label("目前累積　%d / 180　　鑰匙　%d / 2" % [scores[0]+scores[1], keys], 16, CREAM))
	var row := _row()
	if final:
		row.add_child(_button("看看我的進步", _show_summary, true))
	else:
		row.add_child(_button("前往星苗花園", _start_level_two, true))
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
	if is_instance_valid(score_badge):
		score_badge.text = "鑰匙:%d/2 得分:%d" % [keys, scores[0] + scores[1]]


class_name ActionButton extends PanelContainer

# TODO: gotta give this an appearance when pressed but not activated
# TODO: the hover_texture texture is _mostly_ good - want to quickly ease it in and out rather than making it appear/not

@export var shortcut_key: String:
	set(new_key):
		shortcut_key = new_key
		if not is_node_ready(): await ready
		button.shortcut = Shortcut.new()
		button.shortcut.events = InputMap.action_get_events(shortcut_key)
		if button.shortcut.events.size() > 0:
			var input_key: InputEventKey = button.shortcut.events[0]
			keybind_label.text = input_key.as_text_physical_keycode()
@export var hover_texture: Texture2D:
	set(texture):
		hover_texture = texture
@export var action: _ActionProvider:
	set(value):
		action = value
		_setup_action()

@onready var button: TextureButton = $Button
@onready var hover_layer: TextureRect = $Button/HoverTexture
@onready var progress_bar: TextureProgressBar = $Button/TextureProgressBar
@onready var timer: Timer = $Button/Timer
@onready var time: Label = $Button/Time
@onready var keybind_label: Label = $Button/Keybind
@onready var tooltip: ActionTooltip = $Button/ActionTooltip # if Control components eventually have better control of their tooltip property, we could use that but until then - manually

func _ready() -> void:
	hover_layer.texture = hover_texture
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.pressed.connect(_on_pressed)
	progress_bar.max_value = timer.wait_time

func _setup_action () -> void:
	if not is_node_ready(): await ready
	button.texture_normal = action.get_icon()
	tooltip.set_title(action.get_tooltip_title())
	tooltip.set_description(action.get_tooltip_description())
	action.on_timer_set.connect(_on_timer_set)
	action.on_timer_update.connect(_on_timer_update)

func _process(_delta: float) -> void:
	if timer.time_left > 0:
		time.text = "%3.1f" % timer.time_left
		progress_bar.value = timer.time_left

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and tooltip.visible:
		tooltip.global_position = event.position + Vector2(0, -tooltip.size.y - 1) 

func _on_pressed() -> void:
	if action: action.activate()

func _on_timer_timeout() -> void:
	time.text = ""
	progress_bar.visible = false

func _on_mouse_entered() -> void:
	hover_layer.visible = true
	if action and action.has_tooltip(): tooltip.visible = true

func _on_mouse_exited() -> void:
	hover_layer.visible = false
	tooltip.visible = false

func _on_timer_set (duration: float) -> void:
	if duration > timer.time_left: 
		progress_bar.visible = true
		progress_bar.max_value = duration
		timer.wait_time = duration
		timer.start()

func _on_timer_update (remaining: float) -> void:
	if remaining > progress_bar.max_value:
		progress_bar.max_value = remaining

	if remaining == 0:
		# the timer doesn't like being set to 0; so set it to something close to 0
		timer.wait_time = 1.0 / 60.0
		timer.start()
	else:
		timer.wait_time = remaining
		timer.start()

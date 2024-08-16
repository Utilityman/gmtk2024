class_name MultiplayerUser extends Node

# TODO: I was thinking that I'd add a multiplayer sychronizer to synch the state across the wire but something went horrible wrong. FIXME

signal on_user_state_change

@export var id: int
@export var hero_data: HeroData
@export_enum("connected", "in_world") var state: String = "connected":
    set(value):
        # TODO: why is this being called infinitely???
        # Logger.info("Multiplayer State Changed to " + state + " for:" + self.name)
        state = value
        on_user_state_change.emit(state)

# TODO: roles? what other data would go here?
# TODO: another piece of data here could be its state - whether or not it is loaded into the world or not? Could maybe be useful?
# 1. Connect to Server
# 2. Could load this hero data with various heroes before choosing which one to actually use
# 3. joins the world - we could have a signal that emits when its state is changed
# (in this process where is it decided where the player is placed into the world???)

# TODO: should this multiplayer user node have a NetworkedPlayer/Entity scene child???
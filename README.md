
- Free UI Assets: https://pixelfrog-assets.itch.io/tiny-swords for stuff?

### Assets

Check out this target dummy to take a stab at adding models into the game:

- https://assetstore.unity.com/packages/3d/props/lowpoly-training-dummy-202311#publisher

### Godot AssetLib

- "SceneSafeMultiplayer" -  to safely load scenes?
- "MultiPlay Core - Multiplayer Framework" - looks definitely WIP but theoretically 
- "netfox" - looks like this would be a great tool to use to help sychronize players better + eventually NAT punchthrough

### Tuneups

- Right click to rotate player model 
- Get someone to review code? 

- So many components should have better options for debug verbosity

### Ideas

All entities will have a large Area3d around them that scans for other entities and will then listen to these entitys' events - to then be able to add events to chat, combat log, etc.

class_name HeroData extends RpgData
# TODO: I'm thinking that the cookie cutter "warrior_hero_definition.tres" and such 
#       files are going to be extraneous because during character creation each person
#       is going to want to be filling out a form that creates a new HeroData instance
#       
#       When you click "Warrior" it will pull spells from the "warrior_starting_spellbook.tres"
#       but it shouldn't actually be a reference to this file by any means. 
#       (I _could_ be wrong about this )

# TODO: a field to just hold what type of hero it is (sure we have a spellbook but we do need to know 
#       for class specific quests, etc. "Hail, $PlayerClass")

@export_category("Inventory")
@export var bag0: ItemContainer
@export var bag0Items: Array[ItemStack]

@export var bag1: ItemContainer
@export var bag1Items: Array[ItemStack]

@export var bag2: ItemContainer
@export var bag2Items: Array[ItemStack]

@export var bag3: ItemContainer
@export var bag3Items: Array[ItemStack]

@export_category("Hero Attributes")
# @export var background: HeroBackground
# @export var featureTree: FeatureTreeResource

# @export var experience: ExperienceResource
# TODO: equipment might go into entity mayyybe?
# @export var equipment: EquipmentResource

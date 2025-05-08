enum CARD_INFO { DISPLAY_NAME, CARD_TYPE, CAST_TIME, SUMMON_ATTACK, SUMMON_HEALTH, DIRECT_DAMAGE, DAMAGE_TYPE, DIRECT_BLOCK, CARD_TEXT, ANIMATION}
const ICE = "ICE"
const FIRE = "FIRE"
const SHIELD = "SHIELD"
const CARDS = {
	"Firebolt": ["Firebolt", "spell", 1, 0, 0, 4, FIRE, 0, "Deal 4 " + FIRE + " damage", ""],
	"Arcane Barrier": ["Arcane Barrier", "spell", 1, 0, 0, 0, "", 4, "Gain 4 " + SHIELD, ""],
	"Icebolt": ["Icebolt", "spell", 1, 0, 0, 4, ICE, 0, "Deal 4 " + ICE +  " damage", ""],
	"Blank Spell": ["", "spell", 0, 0, 0, 0, "", 0, "", ""],
	"Blank Summon": ["", "summon", 0, 0, 1, 1, "", 0, "", ""]
}

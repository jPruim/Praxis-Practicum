enum CARD_INFO { DISPLAY_NAME, CARD_TYPE, CAST_TIME, SUMMON_ATTACK, SUMMON_HEALTH, DIRECT_DAMAGE, DAMAGE_TYPE, DIRECT_BLOCK, CARD_TEXT, ANIMATION, STACKABLE}
const ICE = "ICE"
const FIRE = "FIRE"
const SHIELD = "SHIELD"
const NEUTRAL = ""
const CARDS = {
	"Firebolt": ["Firebolt", "spell", 1, 0, 0, 4, FIRE, 0, "Deal 4 " + FIRE + " damage", "", false],
	"Arcane Barrier": ["Arcane", "spell", 1, 0, 0, 4, "", 0, "Gain 4 " + SHIELD + " damage", "", false],
	"Icebolt": ["Icebolt", "spell", 1, 0, 0, 4, ICE, 0, "Deal 4 " + ICE +  " damage", "", false],
	"Blank Spell": ["", "spell", 0, 0, 0, 0, "", 0, "", "", false],
	"Blank Summon": ["", "summon", 0, 1, 1, 0, "", 0, "", "", false],
	"Fire Fox": ["Fire Fox", "summon", 1, 3, 4, 0, FIRE, 0, "Stackable", "", true],
	"Bee": ["Bee", "summon", 0, 1, 1, 0, NEUTRAL, 0, "Attack matches Health. Stackable", "", true],
	"Snowy Owl": ["Snowy Owl", "summon", 0, 2, 4, 0, ICE, 2, "Also gains 2 shield. Stackable", "", true],
}

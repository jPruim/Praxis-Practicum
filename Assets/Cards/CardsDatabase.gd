
# Unitinfo = [Type, Attack, Retaliation, Health, Cost, Name, Melee or Ranged, Special Text]
# Eventinfo = [Type, Cost, Effect]
enum {Footman, Archer, SquadLeader, Warrior, Guardian, Knight, Mercenary, Spearman, Mentor, Trebuchet}
enum {CARDTYPE, CARDATTACK, CARDHEALTH, CARDCOST, CARDNAME, CARDTEXT}


const DATA = {
	Footman : 
		["Units", 1, 2, 1, "Footman", ""],
	Archer :
		["Units", 2, 3, 2, "Archer", "\nImmune to\nRetaliation"],
	SquadLeader :
		["Units", 2, 3, 3, "Squad Leader", "Melee,\nGive all friendly\n+1 Attack and \nRetaliation"],
	Warrior :
		["Units", 4, 2, 3, "Rogue", "\nImmune to\nRetaliation"],
	Guardian :
		["Units", 1, 6, 3, "Guardian", "\nProtector - stops the unit\nbehind it\nbeing attacked"],
	Knight : 
		["Units", 2,  6, 4, "Knight", "Melee"],
	Mercenary :
		["Units", 2,  0, 2, "Mercenary", "\nAlways Retaliates\nReturn to Supply when damaged\nor at start of next turn\nAfter played, increase\ncost by 1"],
	Spearman :
		["Units", 2,  5, 3, "Spearman", "Melee or Ranged"],
	Mentor :
		["Units", 3 , 1, 2, "Mentor", "\nWhen played give\nfriendly unit +2 Attack\nand Retaliation"],
	Trebuchet :
		["Events", 4, "Deal 6 damage\nto a unit"],
	}

-- ReplicatedStorage/Modules/WeaponData
-- Sistema completo de armas

local WeaponData = {}

WeaponData.Weapons = {
	-- COMUM
	{
		ID = "rusty_sword",
		Name = "Espada Enferrujada",
		Rarity = "Comum",
		Damage = 30,
		AttackSpeed = 1.0,
		Range = 8,
		Weight = 5,
		Sellable = true,
		SellPrice = 50,
		Description = "Uma espada velha e enferrujada"
	},
	-- RARO
	{
		ID = "steel_blade",
		Name = "Lâmina de Aço",
		Rarity = "Raro",
		Damage = 75,
		AttackSpeed = 1.2,
		Range = 9,
		Weight = 8,
		Sellable = true,
		SellPrice = 500,
		Description = "Lâmina forjada em aço puro"
	},
	-- ÉPICO
	{
		ID = "shadow_katana",
		Name = "Katana das Sombras",
		Rarity = "Épico",
		Damage = 150,
		AttackSpeed = 1.5,
		Range = 10,
		Weight = 10,
		Sellable = true,
		SellPrice = 2500,
		Description = "Katana imbuída com poder sombrio",
		SpecialEffect = "ShadowSlash"
	},
	-- LENDÁRIO
	{
		ID = "demon_blade",
		Name = "Lâmina Demoníaca",
		Rarity = "Lendário",
		Damage = 350,
		AttackSpeed = 1.8,
		Range = 12,
		Weight = 15,
		Sellable = true,
		SellPrice = 10000,
		Description = "Espada forjada no inferno",
		SpecialEffect = "Inferno"
	},
	-- MÍTICO
	{
		ID = "god_slayer",
		Name = "Mata-Deuses",
		Rarity = "Mítico",
		Damage = 800,
		AttackSpeed = 2.0,
		Range = 15,
		Weight = 20,
		Sellable = false,
		SellPrice = 0,
		Description = "Lâmina capaz de matar divindades",
		SpecialEffect = "DivineWrath"
	}
}

function WeaponData:GetWeaponByID(weaponID)
	for _, weapon in ipairs(self.Weapons) do
		if weapon.ID == weaponID then
			return weapon
		end
	end
	return nil
end

return WeaponData

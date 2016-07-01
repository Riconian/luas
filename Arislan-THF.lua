-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

--[[
	Custom commands:

	gs c cycle treasuremode (set on ctrl-= by default): Cycles through the available treasure hunter modes.
	
	Treasure hunter modes:
		None - Will never equip TH gear
		Tag - Will equip TH gear sufficient for initial contact with a mob (either melee, ranged hit, or Aeolian Edge AOE)
		SATA - Will equip TH gear sufficient for initial contact with a mob, and when using SATA
		Fulltime - Will keep TH gear equipped fulltime

--]]

-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2
	
	-- Load and initialize the include file.
	include('Mote-Include.lua')
end

-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
	state.Buff['Sneak Attack'] = buffactive['sneak attack'] or false
	state.Buff['Trick Attack'] = buffactive['trick attack'] or false
	state.Buff['Feint'] = buffactive['feint'] or false
	
	include('Mote-TreasureHunter')

	-- For th_action_check():
	-- JA IDs for actions that always have TH: Provoke, Animated Flourish
	info.default_ja_ids = S{35, 204}
	-- Unblinkable JA IDs for actions that always have TH: Quick/Box/Stutter Step, Desperate/Violent Flourish
	info.default_u_ja_ids = S{201, 202, 203, 205, 207}

	determine_haste_group()

end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	state.OffenseMode:options('Normal', 'LowAcc', 'MidAcc', 'HighAcc', 'Fodder')
	state.HybridMode:options('Normal')
	state.RangedMode:options('Normal', 'Acc')
	state.WeaponskillMode:options('Normal', 'Acc')
	state.PhysicalDefenseMode:options('Evasion', 'PDT', 'MDT')


	gear.default.weaponskill_neck = "Asperity Necklace"
	gear.default.weaponskill_waist = gear.ElementalBelt

	-- Additional local binds
	send_command('bind ^` gs c cycle treasuremode')
	send_command('bind !` input /ja "Flee" <me>')
	send_command('bind ^, input /ja "Spectral Jig" <me>')

	select_default_macro_book()
end

-- Called when this job file is unloaded (eg: job change)
function user_unload()
	send_command('unbind ^`')
	send_command('unbind !`')
	send_command('unbind ^,')
end

-- Define sets and vars used by this job file.
function init_gear_sets()
	--------------------------------------
	-- Special sets (required by rules)
	--------------------------------------

	sets.TreasureHunter = {
		hands="Plunderer's Armlets +1",
		feet="Skulk. Poulaines +1",
		waist="Chaac Belt",
		}
		
	sets.ExtraRegen = {}
	
	sets.Kiting = {
		feet="Jute Boots +1",
		}

	sets.buff['Sneak Attack'] = {
		ammo="Expeditious Pinion",
		head="Dampening Tam",
		body="Adhemar Jacket", 
		hands="Adhemar Wristbands",
		legs="Lustratio Subligar",
		feet="Lustratio Leggings",
		neck="Caro Necklace",
		ear1="Dominance Earring",
		ear2="Heartseeker Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Bleating Mantle",
		}

	sets.buff['Trick Attack'] = {
		ammo="Expeditious Pinion",
		head="Pillager's Bonnet +1",
		body="Adhemar Jacket", 
		hands="Pillager's Armlets +1",
		legs="Pillager's Culottes +1",
		feet="Skulk. Poulaines +1",
		neck="Pentalagus Charm",
		ear1="Dudgeon Earring",
		ear2="Heartseeker Earring",
		ring2="Garuda Ring +1",
		ring2="Garuda Ring +1",
		back="Bleating Mantle",
		}

	-- Actions we want to use to tag TH.
	sets.precast.Step = sets.TreasureHunter
	sets.precast.Flourish1 = sets.TreasureHunter
	sets.precast.JA.Provoke = sets.TreasureHunter


	--------------------------------------
	-- Precast sets
	--------------------------------------

	-- Precast sets to enhance JAs
	sets.precast.JA['Collaborator'] = {
		head="Raider's Bonnet +1",
		}

	sets.precast.JA['Accomplice'] = {
		head="Raider's Bonnet +1",
		}

	sets.precast.JA['Flee'] = {
		feet="Rog. Poulaines +1",
		}

	sets.precast.JA['Hide'] = {
		body="Pillager's Vest +1",
		}

	sets.precast.JA['Conspirator'] = {
		body="Raider's Vest +1",
		}

	sets.precast.JA['Steal'] = {
		ammo="Barathrum",
		head="Asn. Bonnet +2",
		hands="Pillager's Armlets +1",
		legs="Pillager's Culottes +1",
		}

	sets.precast.JA['Despoil'] = {
		ammo="Barathrum",
		legs="Raider's Culottes +1",
		feet="Skulk. Poulaines +1",
		}

	sets.precast.JA['Perfect Dodge'] = {
		hands="Plunderer's Armlets +1",
		}

	sets.precast.JA['Feint'] = {
		legs="Plunderer's Culottes +1",
		}

	sets.precast.JA['Sneak Attack'] = sets.buff['Sneak Attack']
	
	sets.precast.JA['Trick Attack'] = sets.buff['Trick Attack']

	sets.precast.Waltz = {
		hands="Slither Gloves +1",
		ring1="Asklepian Ring",
		ring2="Valseur's Ring",
		}

	sets.precast.Waltz['Healing Waltz'] = {}

	sets.precast.FC = {
		ammo="Sapience Orb",
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Leyline Gloves",
		feet=gear.Herc_MAB_feet,
		neck="Orunmila's Torque",
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		ring1="Prolix Ring",
		ring2="Weather. Ring",
		}

	sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {
		neck="Magoraga Beads",
		ring1="Lebeche Ring",
		})

	-- Weaponskill Sets

	sets.precast.WS = {
		ammo="Focal Orb",
		head="Lilitu Headpiece",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Lustratio Subligar",
		feet="Lustratio Leggings",
		neck=gear.ElementalGorget,
		ear1="Moonshade Earring",
		ear2="Ishvara Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Bleating Mantle",
		waist=gear.ElementalBelt,
		} -- default set

	sets.precast.WS.Acc = set_combine(sets.precast.WS, {
		legs="Adhemar Kecks",
		ring1="Cacoethic Ring +1",
		})


	sets.precast.WS['Exenterator'] = set_combine(sets.precast.WS, {
		ammo="Expeditious Pinion",
		head="Adhemar Bonnet",
		legs=gear.Herc_TA_legs,
		feet=gear.Herc_TA_feet,
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring2="Garuda Ring +1",
		ring2="Garuda Ring +1",
		})

	sets.precast.WS['Exenterator'].Acc = set_combine(sets.precast.WS['Exenterator'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands=gear.Herc_TA_hands,
		legs="Adhemar Kecks",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

	sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS, {
		ammo="Expeditious Pinion",
		head="Adhemar Bonnet",
		})

	sets.precast.WS['Evisceration'].Acc = set_combine(sets.precast.WS['Evisceration'], {
		ammo="Falcon Eye",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands=gear.Herc_TA_hands,
		legs="Adhemar Kecks",
		feet=gear.Herc_TA_feet,
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

	sets.precast.WS["Rudra's Storm"] = set_combine(sets.precast.WS, {
		ammo="Expeditious Pinion",
		neck="Caro Necklace",
		waist="Grunfeld Rope",
		})

	sets.precast.WS["Rudra's Storm"].Acc = set_combine(sets.precast.WS["Rudra's Storm"], {
		ammo="Falcon Eye",
		legs="Adhemar Kecks",
		})

	sets.precast.WS['Mandalic Stab'] = sets.precast.WS["Rudra's Storm"]

	sets.precast.WS['Mandalic Stab'].Acc = sets.precast.WS["Rudra's Storm"].Acc

	sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS, {
		ammo="Grenade Core",
		head=gear.Herc_MAB_head,
		body="Samnuha Coat",
		hands="Leyline Gloves",
		legs=gear.Herc_MAB_legs,
		feet=gear.Herc_MAB_feet,
		neck="Sanctity Necklace",
		ear1="Hecate's Earring",
		ear2="Friomisi Earring",
		ring1="Shiva Ring +1",
		ring2="Shiva Ring +1",
		back="Argocham. Mantle",
		waist="Eschan Stone",
		})

	sets.precast.WS['Aeolian Edge'].TH = set_combine(sets.precast.WS['Aeolian Edge'], sets.TreasureHunter)


	--------------------------------------
	-- Midcast sets
	--------------------------------------

	sets.midcast.FastRecast = {
		ear1="Etiolation Earring",
		ear2="Loquacious Earring",
		}

	-- Specific spells
	sets.midcast.Utsusemi = {
		ear2="Loquacious Earring",
		waist="Ninurta's Sash",
		}

	--------------------------------------
	-- Idle/resting/defense sets
	--------------------------------------

	-- Resting sets
	sets.resting = {}


	-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)

	sets.idle = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Mekosu. Harness",
		hands=gear.Herc_TA_hands,
		legs="Samnuha Tights",
		feet="Jute Boots +1",
		neck="Sanctity Necklace",
		ear1="Genmei Earring",
		ear2="Infused Earring",
		ring1="Paguroidea Ring",
		ring2="Sheltered Ring",
		back="Solemnity Cape",
		waist="Flume Belt",
		}

	sets.idle.PDT = set_combine (sets.idle, {
		hands=gear.Herc_TA_hands,
		neck="Loricate Torque +1", 
		ear1="Genmei Earring",
		ring1="Defending Ring",
		ring2="Gelatinous Ring +1", --7
		back="Solemnity Cape",
		waist="Flume Belt",
		})

	sets.idle.MDT = set_combine (sets.idle, {
		head="Dampening Tam",
		neck="Loricate Torque +1",
		ear1="Etiolation Earring",
		ring1="Defending Ring", 
		back="Solemnity Cape",
		})

	sets.idle.Town = set_combine(sets.idle, {
		body="Adhemar Jacket",
		neck="Erudit. Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Ramuh Ring +1",
		ring2="Ramuh Ring +1",
		back="Bleating Mantle",
		waist="Windbuffet Belt +1",
		})

	sets.idle.Weak = sets.idle.PDT


	-- Defense sets

	sets.defense.PDT = {
		hands=gear.Herc_TA_hands, --2
		neck="Loricate Torque +1", --6
		ear1="Genmei Earring", --2
		ring1="Defending Ring", --10
		ring2="Gelatinous Ring +1", --7
		back="Solemnity Cape", --4
		waist="Flume Belt", --4
		}

	sets.defense.MDT = {
		head="Dampening Tam", --4
		neck="Loricate Torque +1", --6
		ear1="Etiolation Earring", --3
		ring1="Defending Ring", --10
		back="Solemnity Cape", --4
		}


	--------------------------------------
	-- Melee sets
	--------------------------------------

	-- Engaged sets

	-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
	-- sets if more refined versions aren't defined.
	-- If you create a set with both offense and defense modes, the offense mode should be first.
	-- EG: sets.engaged.Dagger.Accuracy.Evasion
	
	sets.engaged = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Taeon_DW_feet,
		neck="Charis Necklace",
		ear1="Eabani Earring",
		ear2="Suppanomimi",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Canny Cape",
		waist="Patentia Sash",
		}

	sets.engaged.LowAcc = set_combine(sets.engaged, {
		ammo="Falcon Eye",
		hands=gear.Herc_TA_hands,
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MidAcc = set_combine(sets.engaged.LowAcc, {
		legs=gear.Herc_TA_legs,
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

	sets.engaged.HighAcc = set_combine(sets.engaged.MidAcc, {
		legs="Adhemar Kecks",
		neck="Erudit. Necklace",
		ear1="Digni. Earring",
		ear2="Zennaroi Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.Fodder = set_combine(sets.engaged, {
		body="Thaumas Coat",
		})

	sets.engaged.HighHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body="Adhemar Jacket",
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Asperity Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Canny Cape",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.HighHaste.LowAcc = set_combine(sets.engaged.HighHaste, {
		ammo="Falcon Eye",
		hands=gear.Herc_TA_hands,
		neck="Lissome Necklace",
		waist="Kentarch Belt +1",
		})

	sets.engaged.HighHaste.MidAcc = set_combine(sets.engaged.HighHaste.LowAcc, {
		legs=gear.Herc_TA_legs,
		ear2="Zennaroi Earring",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

		sets.engaged.HighHaste.HighAcc = set_combine(sets.engaged.HighHaste.MidAcc, {
		legs="Adhemar Kecks",
		neck="Erudit. Necklace",
		ear1="Digni. Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.HighHaste.Fodder = set_combine(sets.engaged.HighHaste, {
		body="Thaumas Coat",
		})

	sets.engaged.MaxHaste = {
		ammo="Ginsen",
		head="Dampening Tam",
		body=gear.Herc_TA_body,
		hands="Adhemar Wristbands",
		legs="Samnuha Tights",
		feet=gear.Herc_TA_feet,
		neck="Asperity Necklace",
		ear1="Cessance Earring",
		ear2="Brutal Earring",
		ring1="Petrov Ring",
		ring2="Epona's Ring",
		back="Bleating Mantle",
		waist="Windbuffet Belt +1",
		}

	sets.engaged.MaxHaste.LowAcc = set_combine(sets.engaged.MaxHaste, {
		ammo="Falcon Eye",
		hands=gear.Herc_TA_hands,
		neck="Lissome Necklace",
		back="Toetapper Mantle",
		waist="Kentarch Belt +1",
		})

	sets.engaged.MaxHaste.MidAcc = set_combine(sets.engaged.MaxHaste.LowAcc, {
		legs=gear.Herc_TA_legs,
		ear2="Zennaroi Earring",
		ring2="Ramuh Ring +1",
		back="Ground. Mantle +1",
		})

	sets.engaged.MaxHaste.HighAcc = set_combine(sets.engaged.MaxHaste.MidAcc, {
		legs="Adhemar Kecks",
		neck="Erudit. Necklace",
		ear1="Digni. Earring",
		ring1="Ramuh Ring +1",
		waist="Olseni Belt",
		})

	sets.engaged.MaxHaste.Fodder = set_combine(sets.engaged.MaxHaste, {
		body="Thaumas Coat",
		})

end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Run after the general precast() is done.
function job_post_precast(spell, action, spellMap, eventArgs)
	if spell.english == 'Aeolian Edge' and state.TreasureMode.value ~= 'None' then
		equip(sets.TreasureHunter)
	elseif spell.english=='Sneak Attack' or spell.english=='Trick Attack' or spell.type == 'WeaponSkill' then
		if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
			equip(sets.TreasureHunter)
		end
	end
end

-- Run after the general midcast() set is constructed.
function job_post_midcast(spell, action, spellMap, eventArgs)
	if state.TreasureMode.value ~= 'None' and spell.action_type == 'Ranged Attack' then
		equip(sets.TreasureHunter)
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_aftercast(spell, action, spellMap, eventArgs)
	-- Weaponskills wipe SATA/Feint.  Turn those state vars off before default gearing is attempted.
	if spell.type == 'WeaponSkill' and not spell.interrupted then
		state.Buff['Sneak Attack'] = false
		state.Buff['Trick Attack'] = false
		state.Buff['Feint'] = false
	end
end

-- Called after the default aftercast handling is complete.
function job_post_aftercast(spell, action, spellMap, eventArgs)
	-- If Feint is active, put that gear set on on top of regular gear.
	-- This includes overlaying SATA gear.
	check_buff('Feint', eventArgs)
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff,gain)
	-- If we gain or lose any haste buffs, adjust which gear set we target.
	if S{'haste','march','embrava','haste samba'}:contains(buff:lower()) then
		determine_haste_group()
		handle_equipping_gear(player.status)
	end
end

function job_status_change(new_status, old_status)
	if new_status == 'Engaged' then
		determine_haste_group()
	end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

function job_update(cmdParams, eventArgs)
	determine_haste_group()
end

function get_custom_wsmode(spell, spellMap, defaut_wsmode)
	local wsmode

	if state.Buff['Sneak Attack'] then
		wsmode = 'SA'
	end
	if state.Buff['Trick Attack'] then
		wsmode = (wsmode or '') .. 'TA'
	end

	return wsmode
end

-- Called any time we attempt to handle automatic gear equips (ie: engaged or idle gear).
function job_handle_equipping_gear(playerStatus, eventArgs)
	-- Check that ranged slot is locked, if necessary
	check_range_lock()

	-- Check for SATA when equipping gear.  If either is active, equip
	-- that gear specifically, and block equipping default gear.
	check_buff('Sneak Attack', eventArgs)
	check_buff('Trick Attack', eventArgs)
end


function customize_idle_set(idleSet)
	if player.hpp < 80 then
		idleSet = set_combine(idleSet, sets.ExtraRegen)
	end

	return idleSet
end


function customize_melee_set(meleeSet)
	if state.TreasureMode.value == 'Fulltime' then
		meleeSet = set_combine(meleeSet, sets.TreasureHunter)
	end

	return meleeSet
end


-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
	th_update(cmdParams, eventArgs)
end

-- Function to display the current relevant user state when doing an update.
-- Return true if display was handled, and you don't want the default info shown.
function display_current_job_state(eventArgs)
	local msg = 'Melee'
	
	if state.CombatForm.has_value then
		msg = msg .. ' (' .. state.CombatForm.value .. ')'
	end
	
	msg = msg .. ': '
	
	msg = msg .. state.OffenseMode.value
	if state.HybridMode.value ~= 'Normal' then
		msg = msg .. '/' .. state.HybridMode.value
	end
	msg = msg .. ', WS: ' .. state.WeaponskillMode.value
	
	if state.DefenseMode.value ~= 'None' then
		msg = msg .. ', ' .. 'Defense: ' .. state.DefenseMode.value .. ' (' .. state[state.DefenseMode.value .. 'DefenseMode'].value .. ')'
	end
	
	if state.Kiting.value == true then
		msg = msg .. ', Kiting'
	end
	
	msg = msg .. ', TH: ' .. state.TreasureMode.value

	add_to_chat(122, msg)

	eventArgs.handled = true
end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

function determine_haste_group()

	classes.CustomMeleeGroups:clear()
	
	if buffactive.embrava and (buffactive.haste or buffactive.march) then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('MaxHaste')
	elseif buffactive.embrava and (buffactive.haste or buffactive.march) then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 1 and buffactive.haste then
		classes.CustomMeleeGroups:append('HighHaste')
	elseif buffactive.march == 2 and buffactive.haste then
		classes.CustomMeleeGroups:append('HighHaste')
	end
end


-- State buff checks that will equip buff gear and mark the event as handled.
function check_buff(buff_name, eventArgs)
	if state.Buff[buff_name] then
		equip(sets.buff[buff_name] or {})
		if state.TreasureMode.value == 'SATA' or state.TreasureMode.value == 'Fulltime' then
			equip(sets.TreasureHunter)
		end
		eventArgs.handled = true
	end
end


-- Check for various actions that we've specified in user code as being used with TH gear.
-- This will only ever be called if TreasureMode is not 'None'.
-- Category and Param are as specified in the action event packet.
function th_action_check(category, param)
	if category == 2 or -- any ranged attack
		--category == 4 or -- any magic action
		(category == 3 and param == 30) or -- Aeolian Edge
		(category == 6 and info.default_ja_ids:contains(param)) or -- Provoke, Animated Flourish
		(category == 14 and info.default_u_ja_ids:contains(param)) -- Quick/Box/Stutter Step, Desperate/Violent Flourish
		then return true
	end
end


-- Function to lock the ranged slot if we have a ranged weapon equipped.
function check_range_lock()
	if player.equipment.range ~= 'empty' then
		disable('range', 'ammo')
	else
		enable('range', 'ammo')
	end
end


-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
	-- Default macro set/book
	if player.sub_job == 'DNC' then
		set_macro_page(1, 1)
	elseif player.sub_job == 'WAR' then
		set_macro_page(2, 1)
	elseif player.sub_job == 'NIN' then
		set_macro_page(3, 1)
	else
		set_macro_page(1, 1)
	end
end


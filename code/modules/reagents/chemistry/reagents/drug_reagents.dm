/datum/reagent/drug
	name = "Drug"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "bitterness"
	var/trippy = TRUE //Does this drug make you trip?

/datum/reagent/drug/on_mob_end_metabolize(mob/living/M)
	if(trippy)
		SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "[type]_high")

/datum/reagent/drug/space_drugs
	name = "Space drugs"
	value = REAGENT_VALUE_VERY_COMMON
	description = "An illegal chemical compound used as drug."
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 30
	pH = 9

/datum/reagent/drug/space_drugs/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(15)
	if(isturf(M.loc) && !isspaceturf(M.loc))
		if(CHECK_MOBILITY(M, MOBILITY_MOVE))
			if(prob(10))
				step(M, pick(GLOB.cardinals))
	if(prob(7))
		M.emote(pick("twitch","drool","moan","giggle"))
	..()

/datum/reagent/drug/space_drugs/overdose_start(mob/living/M)
	to_chat(M, "<span class='userdanger'>You start tripping hard!</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_overdose", /datum/mood_event/overdose, name)

/datum/reagent/drug/space_drugs/overdose_process(mob/living/M)
	if(M.hallucination < volume && prob(20))
		M.hallucination += 5
	..()

/datum/reagent/drug/nicotine
	name = "Nicotine"
	description = "Slightly reduces stun times. If overdosed it will deal toxin and oxygen damage."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	addiction_threshold = 20
	taste_description = "smoke"
	trippy = FALSE
	pH = 8

/datum/reagent/drug/nicotine/on_mob_life(mob/living/carbon/M)
	if(prob(1))
		var/smoke_message = pick("You feel relaxed.", "You feel calmed.","You feel alert.","You feel rugged.")
		to_chat(M, "<span class='notice'>[smoke_message]</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "smoked", /datum/mood_event/smoked, name)
	M.AdjustAllImmobility(-20, 0)
	M.AdjustUnconscious(-20, 0)
	M.adjustStaminaLoss(-0.5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/crank
	name = "Crank"
	description = "Reduces stun times by about 200%. If overdosed or addicted it will deal significant Toxin, Brute and Brain damage."
	reagent_state = LIQUID
	color = "#FA00C8"
	overdose_threshold = 20
	addiction_threshold = 10
	pH = 10
	value = REAGENT_VALUE_UNCOMMON

/datum/reagent/drug/crank/on_mob_life(mob/living/carbon/M)
	if(prob(5))
		var/high_message = pick("You feel jittery.", "You feel like you gotta go fast.", "You feel like you need to step it up.")
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustAllImmobility(-20, 0)
	M.AdjustUnconscious(-20, 0)
	..()
	. = 1

/datum/reagent/drug/crank/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM)
	M.adjustToxLoss(2*REM, 0)
	M.adjustBruteLoss(2*REM, 0)
	..()
	. = 1

/datum/reagent/drug/crank/addiction_act_stage1(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5*REM)
	..()

/datum/reagent/drug/crank/addiction_act_stage2(mob/living/M)
	M.adjustToxLoss(5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/crank/addiction_act_stage3(mob/living/M)
	M.adjustBruteLoss(5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/crank/addiction_act_stage4(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3*REM)
	M.adjustToxLoss(5*REM, 0)
	M.adjustBruteLoss(5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/krokodil
	name = "Krokodil"
	description = "Cools and calms you down. If overdosed it will deal significant Brain and Toxin damage. If addicted it will begin to deal fatal amounts of Brute damage as the subject's skin falls off."
	reagent_state = LIQUID
	color = "#0064B4"
	overdose_threshold = 20
	addiction_threshold = 15
	pH = 9
	value = REAGENT_VALUE_UNCOMMON


/datum/reagent/drug/krokodil/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel calm.", "You feel collected.", "You feel like you need to relax.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	..()

/datum/reagent/drug/krokodil/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.25*REM)
	M.adjustToxLoss(0.25*REM, 0)
	..()
	. = 1

/datum/reagent/drug/krokodil/addiction_act_stage1(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM)
	M.adjustToxLoss(2*REM, 0)
	..()
	. = 1

/datum/reagent/drug/krokodil/addiction_act_stage2(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class='danger'>Your skin feels loose...</span>")
	..()

/datum/reagent/drug/krokodil/addiction_act_stage3(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class='danger'>Your skin starts to peel away...</span>")
	M.adjustBruteLoss(3*REM, 0)
	..()
	. = 1

/datum/reagent/drug/krokodil/addiction_act_stage4(mob/living/carbon/human/M)
	CHECK_DNA_AND_SPECIES(M)
	if(!istype(M.dna.species, /datum/species/krokodil_addict))
		to_chat(M, "<span class='userdanger'>Your skin falls off easily!</span>")
		M.adjustBruteLoss(50*REM, 0) // holy shit your skin just FELL THE FUCK OFF
		M.set_species(/datum/species/krokodil_addict)
	else
		M.adjustBruteLoss(5*REM, 0)
	..()
	. = 1

/datum/reagent/drug/heroin
	name = "Heroin"
	description = "Makes life feel like a beautiful dream."
	reagent_state = LIQUID
	color = "#c7AB00"
	overdose_threshold = 31
	addiction_threshold = 20
	pH = 9
	value = REAGENT_VALUE_UNCOMMON


/datum/reagent/drug/heroin/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel like you're floating.", "Life feels like a beautiful dream.", "Everything seems right with the world.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/heroin/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.25*REM)
	M.adjustToxLoss(0.25*REM, 0)
	..()
	. = 1

/datum/reagent/drug/heroin/addiction_act_stage1(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM)
	M.adjustToxLoss(2*REM, 0)
	..()
	. = 1

/datum/reagent/drug/heroin/addiction_act_stage2(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class='danger'>Life feels so hard</span>")
	M.adjustToxLoss(3*REM, 0)
	..()
	. = 1

/datum/reagent/drug/heroin/addiction_act_stage3(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class='danger'>YOU CAN'T TAKE THIS ANYMORE!!</span>")
	M.adjustToxLoss(4*REM, 0)
	..()
	. = 1

/datum/reagent/drug/cocaine
	name = "Cocaine"
	description = "Party like it's 1980."
	reagent_state = LIQUID
	color = "#ffffff"
	overdose_threshold = 31
	addiction_threshold = 20
	pH = 9
	value = REAGENT_VALUE_UNCOMMON


/datum/reagent/drug/heroin/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel like you're floating.", "Life feels like a beautiful dream.", "Everything seems right with the world.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/heroin/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.25*REM)
	M.adjustToxLoss(0.25*REM, 0)
	..()
	. = 1

/datum/reagent/drug/heroin/addiction_act_stage1(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM)
	M.adjustToxLoss(2*REM, 0)
	..()
	. = 1

/datum/reagent/drug/heroin/addiction_act_stage2(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class='danger'>Life feels so hard</span>")
	M.adjustToxLoss(3*REM, 0)
	..()
	. = 1

/datum/reagent/drug/heroin/addiction_act_stage3(mob/living/M)
	if(prob(25))
		to_chat(M, "<span class='danger'>YOU CAN'T TAKE THIS ANYMORE!!</span>")
	M.adjustToxLoss(4*REM, 0)
	..()
	. = 1

/datum/reagent/drug/methamphetamine
	name = "Methamphetamine"
	description = "Reduces stun times by about 300%, and allows the user to quickly recover stamina while dealing a small amount of Brain damage. If overdosed the subject will move randomly, laugh randomly, drop items and suffer from Toxin and Brain damage. If addicted the subject will constantly jitter and drool, before becoming dizzy and losing motor control and eventually suffer heavy toxin damage."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	addiction_threshold = 10
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	var/brain_damage = TRUE
	var/jitter = TRUE
	var/confusion = TRUE
	pH = 5
	value = REAGENT_VALUE_UNCOMMON

/datum/reagent/drug/methamphetamine/on_mob_metabolize(mob/living/L)
	..()
	L.ignore_slowdown(type)
	ADD_TRAIT(L, TRAIT_TASED_RESISTANCE, type)

/datum/reagent/drug/methamphetamine/on_mob_end_metabolize(mob/living/L)
	L.unignore_slowdown(type)
	REMOVE_TRAIT(L, TRAIT_TASED_RESISTANCE, type)
	..()

/datum/reagent/drug/methamphetamine/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustAllImmobility(-40, 0)
	M.AdjustUnconscious(-40, 0)
	M.adjustStaminaLoss(-7.5 * REM, 0)
	if(jitter)
		M.Jitter(2)
	if(brain_damage)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1,4))
	M.heal_overall_damage(2, 2)
	if(prob(5))
		M.emote(pick("twitch", "shiver"))
	..()
	. = 1

/datum/reagent/drug/methamphetamine/overdose_process(mob/living/M)
	if(CHECK_MOBILITY(M, MOBILITY_MOVE) && !ismovable(M.loc))
		for(var/i in 1 to 4)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote("laugh")
	if(prob(33))
		M.visible_message("<span class='danger'>[M]'s hands flip out and flail everywhere!</span>")
		M.drop_all_held_items()
	..()
	M.adjustToxLoss(1, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, pick(0.5, 0.6, 0.7, 0.8, 0.9, 1))
	. = 1

/datum/reagent/drug/methamphetamine/addiction_act_stage1(mob/living/M)
	M.Jitter(5)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/methamphetamine/addiction_act_stage2(mob/living/M)
	M.Jitter(10)
	M.Dizzy(10)
	if(prob(30))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/methamphetamine/addiction_act_stage3(mob/living/M)
	if(CHECK_MOBILITY(M, MOBILITY_MOVE) && !ismovable(M.loc))
		for(var/i = 0, i < 4, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(15)
	M.Dizzy(15)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/methamphetamine/addiction_act_stage4(mob/living/carbon/human/M)
	if(CHECK_MOBILITY(M, MOBILITY_MOVE) && !ismovable(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(20)
	M.Dizzy(20)
	M.adjustToxLoss(5, 0)
	if(prob(50))
		M.emote(pick("twitch","drool","moan"))
	..()
	. = 1

/datum/reagent/drug/methamphetamine/changeling
	name = "Changeling Adrenaline"
	addiction_threshold = 35
	overdose_threshold = 35
	jitter = FALSE
	brain_damage = FALSE
	value = REAGENT_VALUE_RARE
	ghoulfriendly = TRUE

/datum/reagent/drug/bath_salts
	name = "Bath Salts"
	description = "Makes you impervious to stuns and grants a stamina regeneration buff, but you will be a nearly uncontrollable tramp-bearded raving lunatic."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	addiction_threshold = 10
	taste_description = "salt" // because they're bathsalts?
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage
	pH = 8.2
	value = REAGENT_VALUE_RARE
	ghoulfriendly = TRUE

/datum/reagent/drug/bath_salts/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_STUNIMMUNE, type)
	ADD_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/drug/bath_salts/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_STUNIMMUNE, type)
	REMOVE_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	if(rage)
		QDEL_NULL(rage)
	..()

/datum/reagent/drug/bath_salts/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.adjustStaminaLoss(-5, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 4)
	M.hallucination += 5
	if(CHECK_MOBILITY(M, MOBILITY_MOVE) && !ismovable(M.loc))
		step(M, pick(GLOB.cardinals))
		step(M, pick(GLOB.cardinals))
	..()
	. = 1

/datum/reagent/drug/bath_salts/overdose_process(mob/living/M)
	M.hallucination += 5
	if(CHECK_MOBILITY(M, MOBILITY_MOVE) && !ismovable(M.loc))
		for(var/i in 1 to 8)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	if(prob(33))
		M.drop_all_held_items()
	..()

/datum/reagent/drug/bath_salts/addiction_act_stage1(mob/living/M)
	M.hallucination += 10
	if(CHECK_MOBILITY(M, MOBILITY_MOVE) && !ismovable(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(5)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/bath_salts/addiction_act_stage2(mob/living/M)
	M.hallucination += 20
	if(CHECK_MOBILITY(M, MOBILITY_MOVE) && !ismovable(M.loc))
		for(var/i = 0, i < 8, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(10)
	M.Dizzy(10)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10)
	if(prob(30))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/bath_salts/addiction_act_stage3(mob/living/M)
	M.hallucination += 30
	if(CHECK_MOBILITY(M, MOBILITY_MOVE) && !ismovable(M.loc))
		for(var/i = 0, i < 12, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(15)
	M.Dizzy(15)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/bath_salts/addiction_act_stage4(mob/living/carbon/human/M)
	M.hallucination += 30
	if(CHECK_MOBILITY(M, MOBILITY_MOVE) && !ismovable(M.loc))
		for(var/i = 0, i < 16, i++)
			step(M, pick(GLOB.cardinals))
	M.Jitter(50)
	M.Dizzy(50)
	M.adjustToxLoss(5, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10)
	if(prob(50))
		M.emote(pick("twitch","drool","moan"))
	..()
	. = 1

/datum/reagent/drug/aranesp
	name = "Aranesp"
	description = "Amps you up and gets you going, fixing stamina damage but possibly causing toxin and oxygen damage."
	reagent_state = LIQUID
	color = "#78FFF0"
	pH = 9.2
	value = REAGENT_VALUE_RARE

/datum/reagent/drug/aranesp/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.adjustStaminaLoss(-10, 0)
	M.adjustToxLoss(0.5, 0)
	if(prob(50))
		M.losebreath++
		M.adjustOxyLoss(1, 0)
	..()
	. = 1

/datum/reagent/drug/happiness
	name = "Happiness"
	description = "Fills you with ecstasic numbness and causes minor brain damage. Highly addictive. If overdosed causes sudden mood swings."
	reagent_state = LIQUID
	color = "#FFF378"
	addiction_threshold = 10
	overdose_threshold = 20
	pH = 10.5
	value = REAGENT_VALUE_RARE

/datum/reagent/drug/happiness/on_mob_add(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_FEARLESS, type)
	SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/happiness_drug)

/datum/reagent/drug/happiness/on_mob_delete(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_FEARLESS, type)
	SEND_SIGNAL(L, COMSIG_CLEAR_MOOD_EVENT, "happiness_drug")
	..()

/datum/reagent/drug/happiness/on_mob_life(mob/living/carbon/M)
	M.jitteriness = 0
	M.confused = 0
	M.disgust = 0
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2)
	..()
	. = 1

/datum/reagent/drug/happiness/overdose_process(mob/living/M)
	if(prob(30))
		var/reaction = rand(1,3)
		switch(reaction)
			if(1)
				M.emote("laugh")
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/happiness_drug_good_od)
			if(2)
				M.emote("sway")
				M.Dizzy(25)
			if(3)
				M.emote("frown")
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/happiness_drug_bad_od)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5)
	..()
	. = 1

/datum/reagent/drug/happiness/addiction_act_stage1(mob/living/M)// all work and no play makes jack a dull boy
	var/datum/component/mood/mood = M.GetComponent(/datum/component/mood)
	mood.setSanity(min(mood.sanity, SANITY_DISTURBED))
	M.Jitter(5)
	if(prob(20))
		M.emote(pick("twitch","laugh","frown"))
	..()

/datum/reagent/drug/happiness/addiction_act_stage2(mob/living/M)
	var/datum/component/mood/mood = M.GetComponent(/datum/component/mood)
	mood.setSanity(min(mood.sanity, SANITY_UNSTABLE))
	M.Jitter(10)
	if(prob(30))
		M.emote(pick("twitch","laugh","frown"))
	..()

/datum/reagent/drug/happiness/addiction_act_stage3(mob/living/M)
	var/datum/component/mood/mood = M.GetComponent(/datum/component/mood)
	mood.setSanity(min(mood.sanity, SANITY_CRAZY))
	M.Jitter(15)
	if(prob(40))
		M.emote(pick("twitch","laugh","frown"))
	..()

/datum/reagent/drug/happiness/addiction_act_stage4(mob/living/carbon/human/M)
	var/datum/component/mood/mood = M.GetComponent(/datum/component/mood)
	mood.setSanity(SANITY_INSANE)
	M.Jitter(20)
	if(prob(50))
		M.emote(pick("twitch","laugh","frown"))
	..()
	. = 1

/datum/reagent/drug/skooma
	name = "Getaway"
	description = "A highly-addictive drug developed by a local pre-war crime family. It greatly improves the user's speed and strength, but heavily impedes their intelligence and agility."
	reagent_state = LIQUID
	color = "#F3E0F9"
	taste_description = "moonshine and the feeling of a successful heist"
	addiction_threshold = 1
	addiction_stage3_end = 40
	addiction_stage4_end = 240
	pH = 12.5
	value = REAGENT_VALUE_EXCEPTIONAL

/datum/reagent/drug/skooma/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/skooma)
	L.action_cooldown_mod *= 2
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.physiology)
			H.physiology.stamina_mod *= 0.5
		if(H.dna && H.dna.species)
			H.dna.species.punchdamagehigh += 4
			H.dna.species.punchdamagelow  += 4
			H.dna.species.punchstunthreshold -= 2

/datum/reagent/drug/skooma/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/skooma)
	L.action_cooldown_mod *= 0.5
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.physiology)
			H.physiology.stamina_mod *= 2
		if(H.dna && H.dna.species)
			H.dna.species.punchdamagehigh -= 4
			H.dna.species.punchdamagelow -= 4
			H.dna.species.punchstunthreshold += 2

/datum/reagent/drug/skooma/on_mob_life(mob/living/carbon/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1*REM)
	M.adjustToxLoss(1*REM)
	if(prob(10))
		M.adjust_blurriness(2)
	..()
	. = 1

/datum/reagent/drug/skooma/addiction_act_stage1(mob/living/M)
	M.Jitter(10)
	if(prob(50))
		M.adjust_blurriness(2)
	..()

/datum/reagent/drug/skooma/addiction_act_stage2(mob/living/M)
	M.Jitter(20)
	M.Dizzy(10)
	M.adjust_blurriness(2)
	..()

/datum/reagent/drug/skooma/addiction_act_stage3(mob/living/M)
	M.Jitter(50)
	M.Dizzy(20)
	M.adjust_blurriness(4)
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/drug/skooma/addiction_act_stage4(mob/living/M)
	M.Jitter(50)
	M.Dizzy(50)
	M.adjust_blurriness(10)
	if(prob(50)) //This proc will be called about 200 times and the adjustbrainloss() below only has to be called 40 times to kill. This will make surviving skooma addiction pretty rare without mannitol usage.
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
	if(prob(40))
		M.emote(pick("twitch","drool","moan"))
	..()

/datum/reagent/syndicateadrenals
	name = "Syndicate Adrenaline"
	description = "Regenerates your stamina and increases your reaction time."
	color = "#E62111"
	overdose_threshold = 6
	value = REAGENT_VALUE_VERY_RARE
	ghoulfriendly = TRUE

/datum/reagent/syndicateadrenals/on_mob_life(mob/living/M)
	M.adjustStaminaLoss(-5*REM)
	. = ..()

/datum/reagent/syndicateadrenals/on_mob_metabolize(mob/living/M)
	. = ..()
	if(istype(M))
		M.action_cooldown_mod *= 0.5
		to_chat(M, "<span class='notice'>You feel an intense surge of energy rushing through your veins.</span>")

/datum/reagent/syndicateadrenals/on_mob_end_metabolize(mob/living/M)
	. = ..()
	if(istype(M))
		M.action_cooldown_mod *= 2
		to_chat(M, "<span class='notice'>You feel as though the world around you is going faster.</span>")

/datum/reagent/syndicateadrenals/overdose_start(mob/living/M)
	to_chat(M, "<span class='danger'>You feel an intense pain in your chest...</span>")

/datum/reagent/syndicateadrenals/overdose_process(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.undergoing_cardiac_arrest())
			C.set_heartattack(TRUE)

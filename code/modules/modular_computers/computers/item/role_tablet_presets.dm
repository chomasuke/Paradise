/**
 * Command
 */

/obj/item/modular_computer/pda/heads
	max_capacity = parent_type::max_capacity * 2
	var/static/list/datum/computer_file/head_programs = list(
		/datum/computer_file/program/status,
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/budgetorders,
	)

/obj/item/modular_computer/pda/heads/Initialize(mapload)
	. = ..()
	for(var/programs in head_programs)
		var/datum/computer_file/program/program_type = new programs
		store_file(program_type)

/obj/item/modular_computer/pda/heads/captain
	name = "captain PDA"
	inserted_item = /obj/item/pen/fountain/captain

/obj/item/modular_computer/pda/heads/captain/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TABLET_CHECK_DETONATE, PROC_REF(tab_no_detonate))
	for(var/datum/computer_file/program/messenger/messenger_app in stored_files)
		messenger_app.spam_mode = TRUE

/obj/item/modular_computer/pda/heads/captain/proc/tab_no_detonate()
	SIGNAL_HANDLER
	return COMPONENT_TABLET_NO_DETONATE

/obj/item/modular_computer/pda/heads/hop
	name = "head of personnel PDA"
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/job_management,
	)

/obj/item/modular_computer/pda/heads/hos
	name = "head of security PDA"
	inserted_item = /obj/item/pen/red/security
	starting_programs = list(
		/datum/computer_file/program/records/security,
	)

/obj/item/modular_computer/pda/heads/ce
	name = "chief engineer PDA"
	starting_programs = list(
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/supermatter_monitor,
	)

/obj/item/modular_computer/pda/heads/cmo
	name = "chief medical officer PDA"
	starting_programs = list(
		/datum/computer_file/program/maintenance/phys_scanner,
		/datum/computer_file/program/records/medical,
	)

/obj/item/modular_computer/pda/heads/rd
	name = "research director PDA"
	inserted_item = /obj/item/pen/fountain
	starting_programs = list(
		/datum/computer_file/program/borg_monitor,
		/datum/computer_file/program/scipaper_program,
		/datum/computer_file/program/signal_commander,
	)

/obj/item/modular_computer/pda/heads/quartermaster
	name = "quartermaster PDA"
	inserted_item = /obj/item/pen/survival
	stored_paper = 20
	starting_programs = list(
		/datum/computer_file/program/shipping,
		/datum/computer_file/program/restock_tracker,
	)

/**
 * Security
 */

/obj/item/modular_computer/pda/security
	name = "security PDA"
	inserted_item = /obj/item/pen/red/security
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/robocontrol,
	)

/obj/item/modular_computer/pda/detective
	name = "detective PDA"
	inserted_item = /obj/item/pen/red/security
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/robocontrol,
	)

/obj/item/modular_computer/pda/warden
	name = "warden PDA"
	inserted_item = /obj/item/pen/red/security
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/robocontrol,
	)

/**
 * Engineering
 */

/obj/item/modular_computer/pda/engineering
	name = "engineering PDA"
	starting_programs = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/supermatter_monitor,
	)

/obj/item/modular_computer/pda/atmos
	name = "atmospherics PDA"
	starting_programs = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/supermatter_monitor,
	)

/**
 * Science
 */

/obj/item/modular_computer/pda/science
	name = "scientist PDA"
	starting_programs = list(
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/science,
		/datum/computer_file/program/scipaper_program,
		/datum/computer_file/program/signal_commander,
	)

/obj/item/modular_computer/pda/roboticist
	name = "roboticist PDA"
	starting_programs = list(
		/datum/computer_file/program/science,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/borg_monitor,
	)

/obj/item/modular_computer/pda/geneticist
	name = "geneticist PDA"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
	)

/**
 * Medical
 */

/obj/item/modular_computer/pda/medical
	name = "medical PDA"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/robocontrol,
	)

/obj/item/modular_computer/pda/medical/paramedic
	name = "paramedic PDA"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/radar/lifeline,
	)

/obj/item/modular_computer/pda/chemist
	name = "chemist PDA"

/obj/item/modular_computer/pda/coroner
	name = "coroner PDA"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
	)

/**
 * Supply
 */

/obj/item/modular_computer/pda/cargo
	name = "cargo technician PDA"
	stored_paper = 20
	starting_programs = list(
		/datum/computer_file/program/shipping,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/restock_tracker,
	)

/obj/item/modular_computer/pda/shaftminer
	name = "shaft miner PDA"
	starting_programs = list(
		/datum/computer_file/program/skill_tracker,
	)

/obj/item/modular_computer/pda/bitrunner
	name = "bit runner PDA"
	starting_programs = list(
		/datum/computer_file/program/arcade,
		/datum/computer_file/program/skill_tracker,
	)

/**
 * Service
 */

/obj/item/modular_computer/pda/janitor
	name = "janitor PDA"
	starting_programs = list(
		/datum/computer_file/program/skill_tracker,
		/datum/computer_file/program/radar/custodial_locator,
	)

/obj/item/modular_computer/pda/chaplain
	name = "chaplain PDA"

/obj/item/modular_computer/pda/lawyer
	name = "lawyer PDA"
	inserted_item = /obj/item/pen/fountain
	starting_programs = list(
		/datum/computer_file/program/records/security,
	)

/obj/item/modular_computer/pda/lawyer/Initialize(mapload)
	. = ..()
	for(var/datum/computer_file/program/messenger/messenger_app in stored_files)
		messenger_app.spam_mode = TRUE

/obj/item/modular_computer/pda/botanist
	name = "botanist PDA"

/obj/item/modular_computer/pda/cook
	name = "cook PDA"

/obj/item/modular_computer/pda/bar
	name = "bartender PDA"
	inserted_item = /obj/item/pen/fountain

/obj/item/modular_computer/pda/clown
	name = "clown PDA"
	inserted_disk = /obj/item/computer_disk/virus/clown
	icon_state = "pda-clown"
	inserted_item = /obj/item/toy/crayon/rainbow

/obj/item/modular_computer/pda/clown/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/slippery,\
		knockdown = 12 SECONDS,\
		lube_flags = NO_SLIP_WHEN_WALKING,\
		on_slip_callback = CALLBACK(src, PROC_REF(AfterSlip)),\
		can_slip_callback = CALLBACK(src, PROC_REF(try_slip)),\
		slot_whitelist = list(ITEM_SLOT_ID, ITEM_SLOT_BELT),\
	)
	AddComponent(/datum/component/wearertargeting/sitcomlaughter, CALLBACK(src, PROC_REF(after_sitcom_laugh)))

/// Returns whether the PDA can slip or not, if we have a wearer then check if they are in a position to slip someone.
/obj/item/modular_computer/pda/clown/proc/try_slip(mob/living/slipper, mob/living/slippee)
	if(isnull(slipper))
		return TRUE
	if(!istype(slipper.get_item_by_slot(ITEM_SLOT_FEET), /obj/item/clothing/shoes/clown_shoes))
		to_chat(slipper,span_warning("[src] failed to slip anyone. Perhaps I shouldn't have abandoned my legacy..."))
		return FALSE
	return TRUE

/obj/item/modular_computer/pda/clown/update_overlays()
	. = ..()
	. += mutable_appearance(icon, "pda_stripe_clown") // clowns have eyes that go over their screen, so it needs to be compiled last

/obj/item/modular_computer/pda/clown/proc/AfterSlip(mob/living/carbon/human/M)
	if (istype(M) && (M.real_name != saved_identification))
		var/obj/item/computer_disk/virus/clown/cart = inserted_disk
		if(istype(cart) && cart.charges < 5)
			cart.charges++
			playsound(src,'sound/machines/ping.ogg',30,TRUE)

/obj/item/modular_computer/pda/clown/proc/after_sitcom_laugh(mob/victim)
	victim.visible_message("[src] lets out a burst of laughter!")

/obj/item/modular_computer/pda/mime
	name = "mime PDA"
	inserted_disk = /obj/item/computer_disk/virus/mime
	inserted_item = /obj/item/toy/crayon/mime
	starting_programs = list(
		/datum/computer_file/program/emojipedia,
	)

/obj/item/modular_computer/pda/mime/Initialize(mapload)
	. = ..()
	for(var/datum/computer_file/program/messenger/msg in stored_files)
		msg.mime_mode = TRUE
		msg.alert_silenced = TRUE

/obj/item/modular_computer/pda/curator
	name = "curator PDA"
	desc = "A small experimental microcomputer."
	icon_state = "pda-library"
	inserted_item = /obj/item/pen/fountain
	long_ranged = TRUE
	starting_programs = list(
		/datum/computer_file/program/emojipedia,
		/datum/computer_file/program/newscaster,
	)

/obj/item/modular_computer/pda/curator/Initialize(mapload)
	. = ..()
	for(var/datum/computer_file/program/messenger/msg in stored_files)
		msg.alert_silenced = TRUE

/obj/item/modular_computer/pda/psychologist
	name = "psychologist PDA"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/robocontrol,
	)

/**
 * No Department/Station Trait
 */
/obj/item/modular_computer/pda/assistant
	name = "assistant PDA"
	starting_programs = list(
		/datum/computer_file/program/bounty_board,
	)

/obj/item/modular_computer/pda/bridge_assistant
	name = "bridge assistant PDA"
	starting_programs = list(
		/datum/computer_file/program/status,
	)

/obj/item/modular_computer/pda/veteran_advisor
	name = "security advisor PDA"
	inserted_item = /obj/item/pen/fountain
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/coupon, //veteran discount
		/datum/computer_file/program/skill_tracker,
	)

/obj/item/modular_computer/pda/human_ai
	name = "modular interface"
	icon_state = "pda-silicon-human"
	base_icon_state = "pda-silicon-human"

	has_light = FALSE //parity with borg PDAs
	comp_light_luminosity = 0
	inserted_item = null
	has_pda_programs = FALSE
	starting_programs = list(
		/datum/computer_file/program/messenger,
		/datum/computer_file/program/secureye/human_ai,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/status,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/borg_monitor,
	)

/obj/item/modular_computer/pda/pun_pun
	name = "monkey PDA"
	starting_programs = list(
		/datum/computer_file/program/bounty_board,
		/datum/computer_file/program/emojipedia,
	)

/**
 * Non-roles
 */
/obj/item/modular_computer/pda/syndicate
	name = "military PDA"
	saved_identification = "John Doe"
	saved_job = "Citizen"
	device_theme = PDA_THEME_SYNDICATE

/obj/item/modular_computer/pda/syndicate/Initialize(mapload)
	. = ..()
	var/datum/computer_file/program/messenger/msg = locate() in stored_files
	if(msg)
		msg.invisible = TRUE

/obj/item/modular_computer/pda/clear
	name = "clear PDA"
	icon_state = "pda-clear"
	long_ranged = TRUE

/obj/item/modular_computer/pda/clear/Initialize(mapload)
	. = ..()
	var/datum/computer_file/program/themeify/theme_app = locate() in stored_files
	if(theme_app)
		for(var/theme_key in GLOB.pda_name_to_theme - GLOB.default_pda_themes)
			theme_app.imported_themes += theme_key

/obj/item/modular_computer/pda/clear/get_messenger_ending()
	return "Sent from my crystal PDA"

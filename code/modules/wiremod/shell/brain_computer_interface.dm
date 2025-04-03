/obj/item/organ/internal/cyberimp/brain/bci
	name = "brain-computer interface"
	desc = "An implant that can be placed in a user's head to control circuits using their brain."
	status = ORGAN_ROBOT
	icon = 'icons/obj/circuits.dmi'
	icon_state = "bci"
	slot = INTERNAL_ORGAN_BRAIN_COMPUTER_INTERFACE
	w_class = WEIGHT_CLASS_TINY

/obj/item/organ/internal/cyberimp/brain/bci/Initialize(mapload)
	. = ..()

	RegisterSignal(src, COMSIG_CIRCUIT_ACTION_COMPONENT_REGISTERED, PROC_REF(action_comp_registered))
	RegisterSignal(src, COMSIG_CIRCUIT_ACTION_COMPONENT_UNREGISTERED, PROC_REF(action_comp_unregistered))

	var/obj/item/integrated_circuit/circuit = new(src)
	circuit.add_component(new /obj/item/circuit_component/equipment_action(null, "One"))

	AddComponent(/datum/component/shell, list(
		new /obj/item/circuit_component/bci_core,
	), SHELL_CAPACITY_SMALL, starting_circuit = circuit)

/obj/item/organ/internal/cyberimp/brain/bci/atom_say(message)
	if(owner)
		// Otherwise say_dead will be called.
		// It's intentional that a circuit for a dead person does not speak from the shell.
		if(owner.stat == DEAD)
			return

		return owner.say(message)

	return ..()

/obj/item/organ/internal/cyberimp/brain/bci/proc/action_comp_registered(datum/source, obj/item/circuit_component/equipment_action/action_comp)
	SIGNAL_HANDLER
	LAZYADD(actions, new/datum/action/innate/bci_action(src, action_comp))

/obj/item/organ/internal/cyberimp/brain/bci/proc/action_comp_unregistered(datum/source, obj/item/circuit_component/equipment_action/action_comp)
	SIGNAL_HANDLER
	var/datum/action/innate/bci_action/action = action_comp.granted_to[REF(src)]
	if(!istype(action))
		return
	LAZYREMOVE(actions, action)
	QDEL_LIST_ASSOC_VAL(action_comp.granted_to)

/datum/action/innate/bci_action
	name = "Action"
	icon_icon = 'icons/mob/actions/actions_bci.dmi'
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "bci_power"

	var/obj/item/organ/internal/cyberimp/brain/bci/bci
	var/obj/item/circuit_component/equipment_action/circuit_component

/datum/action/innate/bci_action/New(obj/item/organ/internal/cyberimp/brain/bci/_bci, obj/item/circuit_component/equipment_action/circuit_component)
	..()
	bci = _bci
	circuit_component.granted_to[REF(_bci)] = src
	src.circuit_component = circuit_component

/datum/action/innate/bci_action/Destroy()
	circuit_component.granted_to -= REF(bci)
	circuit_component = null

	return ..()

/datum/action/innate/bci_action/Activate()
	circuit_component.user.set_output(owner)
	circuit_component.signal.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/bci_core
	display_name = "BCI Core"
	desc = "Controls the core operations of the BCI."

	/// A reference to the action button to look at charge/get info
	var/datum/action/innate/bci_charge_action/charge_action

	var/datum/port/input/message
	var/datum/port/input/send_message_signal
	var/datum/port/input/show_charge_meter

	var/datum/port/output/user_port

	var/obj/item/organ/internal/cyberimp/brain/bci/bci

/obj/item/circuit_component/bci_core/populate_ports()

	message = add_input_port("Message", PORT_TYPE_STRING, trigger = null)
	send_message_signal = add_input_port("Send Message", PORT_TYPE_SIGNAL)
	show_charge_meter = add_input_port("Show Charge Meter", PORT_TYPE_NUMBER, trigger = PROC_REF(update_charge_action))

	user_port = add_output_port("User", PORT_TYPE_USER)

/obj/item/circuit_component/bci_core/Destroy()
	QDEL_NULL(charge_action)
	return ..()

/obj/item/circuit_component/bci_core/proc/update_charge_action()
	CIRCUIT_TRIGGER
	if(show_charge_meter.value)
		if(charge_action)
			return
		charge_action = new(src)
		if(bci.owner)
			charge_action.Grant(bci.owner)
		bci.actions += charge_action
	else
		if(!charge_action)
			return
		if(bci.owner)
			charge_action.Remove(bci.owner)
		bci.actions -= charge_action
		QDEL_NULL(charge_action)

/obj/item/circuit_component/bci_core/register_shell(atom/movable/shell)
	bci = shell

	show_charge_meter.set_value(TRUE)

	RegisterSignal(shell, COMSIG_ORGAN_IMPLANTED, PROC_REF(on_organ_implanted))
	RegisterSignal(shell, COMSIG_ORGAN_REMOVED, PROC_REF(on_organ_removed))

/obj/item/circuit_component/bci_core/unregister_shell(atom/movable/shell)
	bci = shell

	if(charge_action)
		if(bci.owner)
			charge_action.Remove(bci.owner)
		bci.actions -= charge_action
		QDEL_NULL(charge_action)

	UnregisterSignal(shell, list(
		COMSIG_ORGAN_IMPLANTED,
		COMSIG_ORGAN_REMOVED,
	))

/obj/item/circuit_component/bci_core/input_received(datum/port/input/port)
	if(!COMPONENT_TRIGGERED_BY(send_message_signal, port))
		return

	var/sent_message = trim(message.value)
	if(!sent_message)
		return

	if(isnull(bci.owner))
		return

	if(bci.owner.stat == DEAD)
		return

	to_chat(bci.owner, "<i>You hear a strange, robotic voice in your head...</i> \"[span_robot("[html_encode(sent_message)]")]\"")

/obj/item/circuit_component/bci_core/proc/on_organ_implanted(datum/source, mob/living/carbon/owner)
	SIGNAL_HANDLER

	update_charge_action()

	user_port.set_output(owner)

	RegisterSignal(owner, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(on_borg_charge))
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/circuit_component/bci_core/proc/on_organ_removed(datum/source, mob/living/carbon/owner)
	SIGNAL_HANDLER

	user_port.set_output(null)

	UnregisterSignal(owner, list(
		COMSIG_PARENT_EXAMINE,
		COMSIG_PROCESS_BORGCHARGER_OCCUPANT,
		COMSIG_LIVING_ELECTROCUTE_ACT,
	))

/obj/item/circuit_component/bci_core/proc/on_borg_charge(datum/source, datum/callback/charge_cell, seconds_per_tick)
	SIGNAL_HANDLER

	if(isnull(parent.cell))
		return

	charge_cell.Invoke(parent.cell, seconds_per_tick)

/obj/item/circuit_component/bci_core/proc/on_electrocute(datum/source, shock_damage, shock_source, siemens_coefficient, flags)
	SIGNAL_HANDLER

	if(isnull(parent.cell))
		return

	if(flags & SHOCK_ILLUSION)
		return

	parent.cell.give(shock_damage * 2)
	to_chat(source, span_notice("You absorb some of the shock into your [parent.name]!"))

/obj/item/circuit_component/bci_core/proc/on_examine(datum/source, mob/mob, list/examine_text)
	SIGNAL_HANDLER

	if(isobserver(mob))
		examine_text += span_notice("<a href='byond://?src=[REF(src)];open_bci=1'>\a [parent] implanted in [source.p_them()]</a>.")
		// examine_text += span_notice("[source.p_They()] [source.p_have()] <a href='byond://?src=[REF(src)];open_bci=1'>\a [parent] implanted in [source.p_them()]</a>.")

/obj/item/circuit_component/bci_core/Topic(href, list/href_list)
	..()

	if(!isobserver(usr))
		return

	if(href_list["open_bci"])
		parent.ui_interact(usr)

/datum/action/innate/bci_charge_action
	name = "Check BCI Charge"
	check_flags = NONE
	icon_icon = 'icons/obj/engines_and_power/power.dmi'
	button_icon_state = "cell"

	var/obj/item/circuit_component/bci_core/circuit_component

/datum/action/innate/bci_charge_action/New(obj/item/circuit_component/bci_core/circuit_component)
	..()

	src.circuit_component = circuit_component

	button.maptext_x = 2
	button.maptext_y = 0
	update_maptext()

	START_PROCESSING(SSobj, src)

/datum/action/innate/bci_charge_action/Destroy()
	circuit_component.charge_action = null
	circuit_component = null

	STOP_PROCESSING(SSobj, src)

	return ..()

/datum/action/innate/bci_charge_action/Trigger(left_click = TRUE)
	var/obj/item/stock_parts/cell/cell = circuit_component.parent.cell

	if(isnull(cell))
		to_chat(owner, span_boldwarning("[circuit_component.parent] has no power cell."))
	else
		to_chat(owner, span_info("[circuit_component.parent]'s [cell.name] has <b>[cell.percent()]%</b> charge left."))
		to_chat(owner, span_info("You can recharge it by using a cyborg recharging station."))

/datum/action/innate/bci_charge_action/process(seconds_per_tick)
	update_maptext()

/datum/action/innate/bci_charge_action/update_maptext()
	var/obj/item/stock_parts/cell/cell = circuit_component.parent.cell
	button.maptext = cell ? MAPTEXT("[cell.percent()]%") : ""

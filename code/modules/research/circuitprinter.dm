/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulfuric acis).

*/
/obj/machinery/r_n_d/circuit_imprinter
	name = "Circuit Imprinter"
	desc = "Машина, предназначенное для печати плат различных устройств."
	icon_state = "circuit_imprinter"
	base_icon_state = "circuit_imprinter"
	container_type = OPENCONTAINER

	/// The current unlocked circuit component designs. Used by integrated circuits to print off circuit components remotely.
	var/list/current_unlocked_circuits_designs = list()

	categories = list(
								"AI Modules",
								"Computer Boards",
								"Engineering Machinery",
								"Exosuit Modules",
								"Hydroponics Machinery",
								"Medical Machinery",
								"Misc. Machinery",
								"Research Machinery",
								"Subspace Telecomms",
								"Teleportation Machinery",
								"Circuit Components",
								)

	reagents = new()

/obj/machinery/r_n_d/circuit_imprinter/get_ru_names()
	return list(
		NOMINATIVE = "принтер плат",
		GENITIVE = "принтера плат",
		DATIVE = "принтеру плат",
		ACCUSATIVE = "принтер плат",
		INSTRUMENTAL = "принтером плат",
		PREPOSITIONAL = "принтере плат",
	)

/obj/machinery/r_n_d/circuit_imprinter/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/circuit_imprinter(null)
	component_parts += new /obj/item/stock_parts/matter_bin(null)
	component_parts += new /obj/item/stock_parts/manipulator(null)
	component_parts += new /obj/item/reagent_containers/glass/beaker(null)
	component_parts += new /obj/item/reagent_containers/glass/beaker(null)
	RefreshParts()
	if(is_taipan(z))
		icon_state = "syndie_circuit_imprinter"
		base_icon_state = "syndie_circuit_imprinter"
	reagents.my_atom = src

/obj/machinery/r_n_d/circuit_imprinter/upgraded/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/circuit_imprinter(null)
	component_parts += new /obj/item/stock_parts/matter_bin/super(null)
	component_parts += new /obj/item/stock_parts/manipulator/pico(null)
	component_parts += new /obj/item/reagent_containers/glass/beaker/large(null)
	component_parts += new /obj/item/reagent_containers/glass/beaker/large(null)
	RefreshParts()
	if(is_taipan(z))
		icon_state = "syndie_circuit_imprinter"
		base_icon_state = "syndie_circuit_imprinter"
	reagents.my_atom = src

/obj/machinery/r_n_d/circuit_imprinter/RefreshParts()
	reagents.maximum_volume = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.maximum_volume += G.volume
		G.reagents.trans_to(src, G.reagents.total_volume)

	materials.max_amount = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		materials.max_amount += M.rating * 75000

	var/T = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T += M.rating
	T = clamp(T, 1, 5)
	efficiency_coeff = 1 / (2 ** (T - 1))

/obj/machinery/r_n_d/circuit_imprinter/check_mat(datum/design/being_built, M)
	var/list/all_materials = being_built.reagents_list + being_built.materials

	var/A = materials.amount(M)
	if(!A)
		A = reagents.get_reagent_amount(M)

	return round(A / max(1, (all_materials[M] * efficiency_coeff)))


// /obj/machinery/r_n_d/circuit_imprinter/proc/on_sync()


// /obj/machinery/r_n_d/circuit_imprinter/proc/on_reset()


// /obj/machinery/r_n_d/circuit_imprinter/proc/print_component(typepath)
// 	var/design_id = current_unlocked_circuits_designs[typepath]

// 	var/datum/design/design = linked_console.files.known_designs[design_id]
// 	if (!((design.build_type & IMPRINTER)||("Circuit Components" in design.category)))
// 		return

// 	if (materials.on_hold())
// 		return

// 	if (!materials.mat_container.has_materials(design.materials, efficiency_coeff))
// 		return

// 	materials.use_materials(design.materials, efficiency_coeff, 1, "printed", "[design.name]")
// 	return new design.build_path(drop_location())

/obj/machinery/r_n_d/circuit_imprinter/attackby(obj/item/I, mob/user, params)
	if(shocked && shock(user, 50))
		add_fingerprint(user)
		return ATTACK_CHAIN_BLOCKED_ALL

	var/is_open_container = I.is_open_container()
	if(user.a_intent == INTENT_HARM)
		if(is_open_container)
			return ..() | ATTACK_CHAIN_NO_AFTERATTACK
		return ..()

	if(exchange_parts(user, I))
		return ATTACK_CHAIN_PROCEED_SUCCESS

	if(is_open_container)
		if(panel_open)
			to_chat(user, span_warning("Close the maintenance panel first."))
			return ATTACK_CHAIN_PROCEED|ATTACK_CHAIN_NO_AFTERATTACK
		return ATTACK_CHAIN_PROCEED	// afterattack will handle this

	var/obj/item/integrated_circuit/circuit
	if(istype(I, /obj/item/integrated_circuit))
		circuit = I

	else if (istype(I, /obj/item/circuit_component/module))
		var/obj/item/circuit_component/module/module = I
		circuit = module.internal_circuit

	if (isnull(circuit))
		return ..()

	circuit.linked_circuit_imprinter = WEAKREF(src)
	circuit.update_static_data_for_all_viewers()
	balloon_alert(user, "successfully linked to the integrated circuit")

	return ..()


/obj/machinery/r_n_d/circuit_imprinter/screwdriver_act(mob/living/user, obj/item/I)
	if(shocked && shock(user, 50))
		add_fingerprint(user)
		return TRUE
	. = default_deconstruction_screwdriver(user, "[base_icon_state]_unscrewed", base_icon_state, I)
	if(. && linked_console)
		linked_console.linked_imprinter = null
		linked_console = null


/obj/machinery/r_n_d/circuit_imprinter/crowbar_act(mob/living/user, obj/item/I)
	. = TRUE
	if(shocked && shock(user, 50))
		add_fingerprint(user)
		return .
	if(!panel_open)
		add_fingerprint(user)
		to_chat(user, span_warning("Open the maintenance panel first."))
		return .
	var/atom/drop_loc = drop_location()
	for(var/obj/component as anything in component_parts)
		if(istype(component, /obj/item/reagent_containers/glass/beaker))
			reagents.trans_to(component, reagents.total_volume)
		component.forceMove(drop_loc)
	materials.retrieve_all()
	default_deconstruction_crowbar(user, I)


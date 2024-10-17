/obj/item/paper_bin
	name = "paper bin"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"
	throwforce = 1
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 7
	pressure_resistance = 8
	var/total_paper = 30					//How much paper is in the bin.
	var/list/paper_stack = list()	//List of paper put in the bin for reference.
	var/letterhead_type
	var/purple_bin = FALSE

/obj/item/paper_bin/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume, global_overlay = TRUE)
	if(total_paper)
		total_paper = 0
		update_icon(UPDATE_ICON_STATE)
	..()

/obj/item/paper_bin/Destroy()
	QDEL_LIST(paper_stack)
	return ..()

/obj/item/paper_bin/burn()
	total_paper = 0
	extinguish()
	update_icon(UPDATE_ICON_STATE)


/obj/item/paper_bin/MouseDrop(atom/over_object, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!.)
		return FALSE

	var/mob/user = usr
	if(over_object != user || user.incapacitated() || !ishuman(user))
		return FALSE

	if(user.put_in_hands(src, ignore_anim = FALSE))
		add_fingerprint(user)
		user.visible_message(span_notice("[user] picks up [src]."))
		return TRUE

	return FALSE


/obj/item/paper_bin/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.bodyparts_by_name[BODY_ZONE_PRECISE_R_HAND]
		if(H.hand)
			temp = H.bodyparts_by_name[BODY_ZONE_PRECISE_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(H, "<span class='notice'>You try to move your [temp.name], but cannot!")
			return
	if(total_paper >= 1)
		total_paper--
		if(total_paper==0)
			update_icon(UPDATE_ICON_STATE)

		var/obj/item/paper/P
		if(paper_stack.len > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = paper_stack[paper_stack.len]
			paper_stack.Remove(P)
			P.forceMove_turf()
		else
			if(letterhead_type && alert("Choose a style",,"Letterhead","Blank")=="Letterhead")
				P = new letterhead_type(drop_location())
			else
				P = new /obj/item/paper(drop_location())
			if(SSholiday.holidays && SSholiday.holidays[APRIL_FOOLS])
				if(prob(30))
					P.info = "<font face=\"[P.crayonfont]\" color=\"red\"><b>HONK HONK HONK HONK HONK HONK HONK<br>HOOOOOOOOOOOOOOOOOOOOOONK<br>APRIL FOOLS</b></font>"
					P.rigged = 1
					P.updateinfolinks()
		if(in_range(user, src))
			user.put_in_hands(P, ignore_anim = FALSE)
			P.add_fingerprint(user)
			to_chat(user, "<span class='notice'>You take [P] out of the [src].</span>")
	else
		to_chat(user, "<span class='notice'>[src] is empty!</span>")

	add_fingerprint(user)
	return


/obj/item/paper_bin/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/paper))
		add_fingerprint(user)
		if(!user.drop_transfer_item_to_loc(I, src))
			return ..()
		to_chat(user, span_notice("You have put [I] into [src]."))
		paper_stack.Add(I)
		total_paper++
		return ATTACK_CHAIN_BLOCKED_ALL

	return ..()

/obj/item/paper_bin/proc/remove_paper(amount = 1)
	var/obj/item/paper/top_paper = pop(paper_stack)
	if(top_paper)
		qdel(top_paper)
	total_paper -= amount

/obj/item/paper_bin/examine(mob/user)
	. = ..()
	if(in_range(user, src))
		if(total_paper)
			. += "<span class='notice'>There " + (total_paper > 1 ? "are [total_paper] paper_stack" : "is one paper") + " in the bin.</span>"
		else
			. += "<span class='notice'>There are no paper_stack in the bin.</span>"


/obj/item/paper_bin/update_icon_state()
	if(total_paper < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin[purple_bin ? "2" : "1"]"


/obj/item/paper_bin/carbon
	name = "carbonless paper bin"
	icon_state = "paper_bin2"
	purple_bin = TRUE

/obj/item/paper_bin/carbon/attack_hand(mob/user)
	if(total_paper >= 1)
		total_paper--
		if(total_paper==0)
			update_icon(UPDATE_ICON_STATE)

		var/obj/item/paper/carbon/P
		if(paper_stack.len > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = paper_stack[paper_stack.len]
			paper_stack.Remove(P)
		else
			P = new /obj/item/paper/carbon(drop_location())
		user.put_in_hands(P, ignore_anim = FALSE)
		to_chat(user, "<span class='notice'>You take [P] out of the [src].</span>")
	else
		to_chat(user, "<span class='notice'>[src] is empty!</span>")

	add_fingerprint(user)
	return

/obj/item/paper_bin/nanotrasen
	name = "nanotrasen paper bin"
	letterhead_type = /obj/item/paper/nanotrasen

/obj/item/paper_bin/syndicate
	name = "syndicate paper bin"
	letterhead_type = /obj/item/paper/syndicate

/obj/item/paper_bin/ussp
	name = "ussp paper bin"
	letterhead_type = /obj/item/paper/ussp

/obj/item/paper_bin/solgov
	name = "solgov paper bin"
	letterhead_type = /obj/item/paper/solgov

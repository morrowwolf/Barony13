# Contributing to The Barony

## Reporting Issues

Even if you can't code, we do really appreciate you filing any bugs or other issues via the [issue tab](https://github.com/morrowwolf/Barony13/issues) on this Github. This is a complex game, and we need all the help we can get in squashing the thousands of bugs lurking in it.

## Introduction

Hi. If you are here because you are curious or interested in contributing - holy fucking shit THANK YOU!! You're totally free to contribute to this project, as long as they follow the simple guidelines and specifications below. They're nothing too complex, just something to keep code quality at a tolerable level; it's in our best interests - and yours too! - if the same bug doesn't have to be fixed twice or thrice or daily because of your shitty duplicated code.

First things first, we want to make it clear how you can contribute (if you've never contributed before), as well as the kinds of powers the team has over your additions, to avoid any unpleasant surprises if your pull request is closed for no obvious reason.

## ***A Warning Before You Spend 200 Hours on Stuff We Won't Accept***
Generally, you are free to work on whatever you want to. You're giving us your skilled labour for free and we're not really going to be too picky about what you give us. We're just happy someone's helping.

However, it is very possible that even if your code is good and the idea isn't bad it will be rejected as not what we're looking for.  If you're going to work on a big project you should consult with the development team or a host and wait for a conclusion on if such an idea would most likely be added.  On top of this, expect to have your PRs changed by a dev or host to keep it within what we're looking for.

## Getting Started

### If You're New To Github
Our co-host has created a dashing [guide in this repo's Wiki](https://github.com/morrowwolf/Barony13/wiki/How-to-Github) for how to operate Github, which is made to be short and easy to follow.

Alternatively, we allow recommend reading the Yogstation guides on [setting up Git](https://wiki.yogstation.net/wiki/Setting_up_git) and [other things](https://wiki.yogstation.net/wiki/Guides#Development_and_Contribution_Guides) that will help you get started contributing to the Barony with Git and Dream Maker.

### If You're New To Programming
Tell us you're new to coding on the [Discord](https://discord.gg/rbvCtP7). We'll hold your hand the whole way through your first PR, if you want.
If you need other help learning to program in BYOND, check out this [repository of resources](http://www.byond.com/developer/articles/resources).

For beginners, it is recommended you work on small projects like bugfixes at first. Ask around if there's any trivial bug or tweak that could be done, just so you can familiarize yourself with using Github and touching the code.


## Meet the Team

**Hosts - MorrowWolf & Altoids**

The Hosts on this server participate in both the administration and development of this server, as heads of both departments. Much of the code comes from these two people. They are the people who will review & merge your PRs. Ping them if you need code assistance.

**Head Designer - Parune**

The Head Designer leads quality control, and has made many of the sprites and artwork for the Barony. Contributions involving those two things require his authorization.

**Admin Department - DLCabbose, Solnear**

The administrators, headed by DLCabbose, still moderate the content and discussion on this Github. Whatever server rules can apply, still apply on the Github. Ultimately, if they tell you to quit doing something, just listen to them.

## Pull Request Process

There is no strict process when it comes to merging pull requests. Pull requests will sometimes take a while before they are looked at by a maintainer; the bigger the change, the more time it will take before they are accepted into the code. Every team member is a volunteer who is giving up their own time to help maintain and contribute, so please be courteous and respectful. Here are some helpful ways to make it easier for you and for the maintainers when making a pull request.

* You are going to be expected to document all your changes in the pull request. Failing to do so will mean delaying it as we will have to question why you made the change. On the other hand, you can speed up the process by making the pull request readable and easy to understand, with diagrams or before/after data.

* If you are proposing multiple changes, which change many different aspects of the code, you are expected to section them off into different pull requests in order to make it easier to review them and to deny/accept the changes that are deemed acceptable.

* If your pull request is accepted, the code you add no longer belongs exclusively to you but to everyone, and what ends up being added onto it is up to the Hosts.

* Please explain why you are submitting the pull request, and how you think your change will be beneficial to the game. Failure to do so will be grounds for rejecting the PR.



## How to not Shitcode

You are expected to follow these specifications in order to make everyone's lives easier. It'll save both your time and ours, by making sure you don't have to make any changes and we don't have to ask you to. Thanks, babe.

### Object Oriented Code
As BYOND's Dream Maker (henceforth "DM") is an object-oriented language, code must be object-oriented when possible in order to be more flexible when adding content to it. If you don't know what "object-oriented" means, you should probably look that up.

The **TLDR** is: If you have a thing A that has a proc ``Foo`` and ``Bar``, and a thing B that has a proc ``Foo`` and ``Oof``, do not do:
```DM
/obj/thingA/proc/Foo()
	codecodecode
/obj/thingB/proc/Foo()
	samecodesamecodesamcode
/obj/thingB/proc/Oof()
	differentcodedifferentcode
/obj/thingA/proc/Bar()
	moredifferentcodemoredifferentcode
```
Instead, do:
```DM
/obj/thingy/proc/Foo()
	codecodecode
/obj/thingy/A/proc/Bar()
	othercodeothercode
/obj/thingy/B/proc/Oof()
	differentcodedifferentcode
```
That way, if you ever have to edit ``Foo``, you only have to do it in one place, and it affects A, B, as well as any other ``thingy``'s that are created later on.

There's a bunch of other concepts about code design in Object Orientation, which is why we asked you to look it up, but this is the general concept: Having two things that are related come from a parent that has the code they share in one neat place.

### All BYOND paths must contain the full path
(i.e. absolute pathing)

DM will allow you nest almost any type keyword into a block, such as:

```DM
datum
	datum1
		var
			varname1 = 1
			varname2
			static
				varname3
				varname4
		proc
			proc1()
				code
			proc2()
				code

		datum2
			varname1 = 0
			proc
				proc3()
					code
			proc2()
				..()
				code
```

Worse yet, coding for this game involves doing a lot of file searching for the definitions of specific procs and objects. Doing this tabbing nonsense means that if you need to search the entire 1000-file codebase for ``datum/datum1/proc/proc1()``, it's pretty much next to impossible. The only exception is the variables of an object may be nested to the object, but must not nest further.

The previous code made compliant:

```DM
/datum/datum1
	var/varname1
	var/varname2
	var/static/varname3
	var/static/varname4

/datum/datum1/proc/proc1()
	code
/datum/datum1/proc/proc2()
	code
/datum/datum1/datum2
	varname1 = 0
/datum/datum1/datum2/proc/proc3()
	code
/datum/datum1/datum2/proc2()
	..()
	code
```

### No overriding type safety checks
The use of the : operator to override type safety checks is not allowed. You must cast the variable to the proper type.

### Type paths must begin with a /
eg: `/datum/thing`, not `datum/thing`

### Datum type paths must began with "datum"
In DM, this is optional, but omitting it makes finding definitions harder.

### Do not use text/string based type paths
It is rarely allowed to put type paths in a text format, as there are no compile errors if the type path no longer exists. Here is an example:

```DM
//Good
var/path_type = /obj/item/baseball_bat

//Bad
var/path_type = "/obj/item/baseball_bat"
```

### Use var/name format when declaring variables
While DM allows other ways of declaring variables, this one should be used for consistency.

### Tabs, not spaces
You must use tabs to indent your code, NOT SPACES.

(You may use spaces to align something, but you should tab to the block level first, then add the remaining spaces)

### No hacky code
Hacky code, such as adding specific checks, is highly discouraged and only allowed when there is ***no*** other option. (Protip: 'I couldn't immediately think of a proper way so thus there must be no other option' is not gonna cut it here! If you can't think of anything else, say that outright and admit that you need help with it. Maintainers exist for exactly that reason.)

You can avoid hacky code by using object-oriented methodologies, such as overriding a function (called "procs" in DM) or sectioning code into functions and then overriding them as required.

### No duplicated code
Copying code from one place to another may be suitable for small, short-time projects, but Barony 13 is a long-term project and highly discourages this.

Instead you can use object orientation, or place repeated code in a function, to obey this specification easily.

### Prefer `Initialize()` over `New()` for atoms
Our game controller is pretty good at handling long operations and lag, but it can't control what happens when the map is loaded, which calls `New` for all atoms on the map. If you're creating a new atom, use the `Initialize` proc to do what you would normally do in `New`. This cuts down on the number of proc calls needed when the world is loaded. See here for details on `Initialize`: https://github.com/tgstation/tgstation/blob/master/code/game/atoms.dm#L49
While we normally encourage (and in some cases, even require) bringing out of date code up to date when you make unrelated changes near the out of date code, that is not the case for `New` -> `Initialize` conversions. These systems are generally more dependant on parent and children procs so unrelated random conversions of existing things can cause bugs that take months to figure out.

### No magic numbers or strings
This means stuff like having a "mode" variable for an object set to "1" or "2" with no clear indicator of what that means. Make these #defines with a name that more clearly states what it's for. For instance:
````DM
/datum/proc/do_the_thing(thing_to_do)
	switch(thing_to_do)
		if(1)
			(...)
		if(2)
			(...)
````
There's no indication of what "1" and "2" mean! Instead, you'd do something like this:
````DM
#define DO_THE_THING_REALLY_HARD 1
#define DO_THE_THING_EFFICIENTLY 2
/datum/proc/do_the_thing(thing_to_do)
	switch(thing_to_do)
		if(DO_THE_THING_REALLY_HARD)
			(...)
		if(DO_THE_THING_EFFICIENTLY)
			(...)
````
This is clearer and enhances readability of your code! Get used to doing it!

### Control statements
(if, while, for, etc)

* All control statements must not contain code on the same line as the statement (`if (blah) return`)
* All control statements comparing a variable to a number should use the formula of `thing` `operator` `number`, not the reverse (eg: `if (count <= 10)` not `if (10 >= count)`)

### Use early return
Do not enclose a proc in an if-block when returning on a condition is more feasible
This is bad:
````DM
/datum/datum1/proc/proc1()
	if (thing1)
		if (!thing2)
			if (thing3 == 30)
				do stuff
````
This is good:
````DM
/datum/datum1/proc/proc1()
	if (!thing1)
		return
	if (thing2)
		return
	if (thing3 != 30)
		return
	do stuff
````
This prevents nesting levels from getting deeper then they need to be.

### Develop Secure Code

* Player input must always be escaped safely, we recommend you use stripped_input in all cases where you would use input. Essentially, just always treat input from players as inherently malicious and design with that use case in mind.

* Calls to the database must be escaped properly - use sanitizeSQL to escape text based database entries from players or admins, and isnum() for number based database entries from players or admins.

* All calls to topics must be checked for correctness. Topic href calls can be easily faked by clients, so you should ensure that the call is valid for the state the item is in. Do not rely on the UI code to provide only valid topic calls, because it won't.

* Information that players could use to metagame (that is, to identify round information and/or antagonist type via information that would not be available to them in character) should be kept as administrator only.

* It is recommended as well you do not expose information about the players - even something as simple as the number of people who have readied up at the start of the round can and has been used to try to identify the round type.

* Where you have code that can cause large-scale modification and *FUN*, make sure you start it out locked behind one of the default admin roles - use common sense to determine which role fits the level of damage a function could do.

### Files
* Because runtime errors do not give the full path, try to avoid having files with the same name across folders.

* File names should not be mixed case, or contain spaces or any character that would require escaping in a uri.

* Files and path accessed and referenced by code above simply being #included should be strictly lowercase to avoid issues on filesystems where case matters.

### SQL
* Do not use the shorthand sql insert format (where no column names are specified) because it unnecessarily breaks all queries on minor column changes and prevents using these tables for tracking outside related info such as in a connected site/forum.

* All changes to the database's layout(schema) must be specified in the database changelog in SQL, as well as reflected in the schema files

* Any time the schema is changed the `schema_revision` table and `DB_MAJOR_VERSION` or `DB_MINOR_VERSION` defines must be incremented.

* Queries must never specify the database, be it in code, or in text files in the repo.

### Mapping Standards
* TGM Format & Map Merge
	* All new maps submitted to the repo through a pull request must be in TGM format (unless there is a valid reason present to have it in the default BYOND format.) This is done using the [Map Merge](https://github.com/tgstation/tgstation/wiki/Map-Merger) utility included in the repo to convert the file to TGM format.
	* Likewise, you MUST run Map Merge prior to opening your PR when updating existing maps to minimize the change differences (even when using third party mapping programs such as FastDMM.)
		* Failure to run Map Merge on a map after using third party mapping programs (such as FastDMM) greatly increases the risk of the map's key dictionary becoming corrupted by future edits after running map merge. Resolving the corruption issue involves rebuilding the map's key dictionary; id est rewriting all the keys contained within the map by reconverting it from BYOND to TGM format - which creates very large differences that ultimately delay the PR process and is extremely likely to cause merge conflicts with other pull requests.

* Variable Editing (Var-edits)
	* While var-editing an item within the editor is perfectly fine, it is preferred that when you are changing the base behavior of an item (how it functions) that you make a new subtype of that item within the code, especially if you plan to use the item in multiple locations on the same map, or across multiple maps. This makes it easier to make corrections as needed to all instances of the item at one time as opposed to having to find each instance of it and change them all individually.
		* Subtypes only intended to be used on away mission or ruin maps should be contained within an .dm file with a name corresponding to that map within `code\modules\awaymissions` or `code\modules\ruins` respectively. This is so in the event that the map is removed, that subtype will be removed at the same time as well to minimize leftover/unused data within the repo.
	* Please attempt to clean out any dirty variables that may be contained within items you alter through var-editing. For example, due to how DM functions, changing the `pixel_x` variable from 23 to 0 will leave a dirty record in the map's code of `pixel_x = 0`. Likewise this can happen when changing an item's icon to something else and then back. This can lead to some issues where an item's icon has changed within the code, but becomes broken on the map due to it still attempting to use the old entry.
	* Areas should not be var-edited on a map to change it's name or attributes. All areas of a single type and it's altered instances are considered the same area within the code, and editing their variables on a map can lead to issues with powernets and event subsystems which are difficult to debug.
	
## Miscellaneous Notes

* Code should be modular where possible. If you're making a brand new thing, put it in a new file or folder. If you're adding on to an old thing, keep it in the same file.

* If you used a regex to replace code during development of your code, post the regex in your PR for the benefit of future developers and downstream users.

* Changes to the `/config` tree must be made in a way that allows for updating server deployments while preserving previous behaviour. This is due to the fact that the config tree is to be considered owned by the user and not necessarily updated alongside the remainder of the code. The code to preserve previous behaviour may be removed at some point in the future given the OK by maintainers.

* Put spaces in-between your math, logic, & bitwise operators. Our host is colourblind and ergo is not reading your code with a decent mark-up. Please be kind to him.

* Yes, we know that the files have a tonne of mixed Windows and Linux line endings. Attempts to fix this have been met with less than stellar success, and as such we have decided to give up caring until there comes a time when it matters. Therefore, EOF settings of main repo are forbidden territory one must avoid wandering into, at risk of losing body and/or mind to the Git gods.
	
## Porting features/sprites/sounds/tools from other codebases

If you are porting features/tools from other codebases, you must give them credit where it's due. Typically, crediting them in your pull request and the changelog is the recommended way of doing it. Take note of what license they use though, porting stuff from AGPLv3 and GPLv3 codebases are allowed.

Regarding sprites & sounds, you must credit the artist and possibly the codebase. All Barony 13 assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated. However if you are porting assets from GoonStation or usually any assets under the [Creative Commons 3.0 BY-NC-SA license](https://creativecommons.org/licenses/by-nc-sa/3.0/) are to go into the 'goon' folder of the Barony codebase.

## Banned content
Do not add any of the following in a Pull Request or risk getting the PR closed:
* National Socialist Party of Germany content, National Socialist Party of Germany related content, or National Socialist Party of Germany references
* Code where one line of code is split across mutiple lines (except for multiple, separate strings and comments; in those cases, existing longer lines must not be split up)

Just because something isn't on this list or guide doesn't mean that it's acceptable. Use common sense above all else.

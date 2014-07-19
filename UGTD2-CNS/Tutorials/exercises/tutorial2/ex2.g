//genesis

// Here we define the function
function make_dialog(name)
// We need to declare the argument as a string.
	str name

	echo In make_dialog with argument {name}
	// Whenever you want to evaluate a variable, put it in braces

	// Check if a dialog with the same name already exists
	if ({exists /form/{name}})
		// We need to evaluate the function 'exists' so it must
		// be placed in braces as well
		echo Repeated name {name} in make_dialog. Aborting.
		return
	end

	create xdialog /form/{name}
	// Here we create the new dialog

	setfield /form/{name} script "make_dialog <v>"
	// Now we assign a function to this new dialog
end



// Here we create the original form with the original dialog.

create xform /form
xshow /form

make_dialog first

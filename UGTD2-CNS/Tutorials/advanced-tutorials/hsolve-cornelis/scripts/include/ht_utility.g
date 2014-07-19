//genesis


int include_tutorial_utility

if ( {include_tutorial_utility} == 0 )

	include_tutorial_utility = 1


///
/// SH:	FileExists
///
/// PA:	path..:	(shell) path.
///
/// RE:	0 if path exists, 1 otherwise.
///
/// DE: Check if the given file exists.  I do not know what will
/// happen if special files or symbolic links are checked.
///
/// NO: Don't use this function if you have setup a large model, it is
/// likely to result in a segmentation violation because of its memory
/// overhead.
///

function FileExists(path)

str path

	sh "echo >/tmp/.exists 1"

	sh {"test -e " @ path @ " && echo >/tmp/.exists 0"}

	openfile /tmp/.exists r

	str sResult = {readfile /tmp/.exists}

	closefile /tmp/.exists

	sh "rm /tmp/.exists"

	if (sResult == 1)

		echo {"File " @ path @ " does not exist (" @ sResult @ ")"}
	else

		echo {"File " @ path @ " exists (" @ sResult @ ")"}
	end

	return {sResult}
end


end



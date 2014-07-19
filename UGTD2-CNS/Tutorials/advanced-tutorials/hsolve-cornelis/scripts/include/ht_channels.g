//genesis


int include_tutorial_channels

if ( {include_tutorial_channels} == 0 )

	include_tutorial_channels = 1


include ht_utility.g

include ht_consts.g

include ht_channels_read.g

include ht_channels_create.g


if ({FileExists channels_created.txt} == 0)

	make_channels_read

else

	make_channels_create

	sh "echo >channels_created.txt"
	sh "echo >>channels_created.txt This file indicates that all tabulated"
	sh "echo >>channels_created.txt channels have been created correctly."
	sh "echo >>channels_created.txt"
	sh "echo >>channels_created.txt Remove this file and rerun the scripts"
	sh "echo >>channels_created.txt to recreate the tabulated channels."
end


end



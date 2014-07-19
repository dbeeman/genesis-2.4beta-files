//genesis


int include_tutorial_granule_channels

if ( {include_tutorial_granule_channels} == 0 )

	include_tutorial_granule_channels = 1


include ht_utility.g

include ht_granule_consts.g

include ht_granule_channels_read.g

include ht_granule_channels_create.g


if ({FileExists granule_channels_created.txt} == 0)

	granule_make_channels_read

else

	granule_make_channels_create

	sh "echo >granule_channels_created.txt"
	sh "echo >>granule_channels_created.txt This file indicates that all tabulated"
	sh "echo >>granule_channels_created.txt channels have been created correctly."
	sh "echo >>granule_channels_created.txt"
	sh "echo >>granule_channels_created.txt Remove this file and rerun the scripts"
	sh "echo >>granule_channels_created.txt to recreate the tabulated channels."
end


end



// genesis 2.1
// Kerstin Menne
// Luebeck, 02.10.2001
// incorporate spike history elements

str tofile="DATA"

create spikehistory pyr22_spikes
setfield pyr22_spikes filename {tofile}/pyr22_spikes flush 0 leave_open 1 append 0

create spikehistory pyr26_spikes
setfield pyr26_spikes filename {tofile}/pyr26_spikes flush 0 leave_open 1 append 0

create spikehistory pyr27_spikes
setfield pyr27_spikes filename {tofile}/pyr27_spikes flush 0 leave_open 1 append 0

create spikehistory pyr28_spikes
setfield pyr28_spikes filename {tofile}/pyr28_spikes flush 0 leave_open 1 append 0

create spikehistory pyr32_spikes
setfield pyr32_spikes filename {tofile}/pyr32_spikes flush 0 leave_open 1 append 0

create spikehistory pyr33_spikes
setfield pyr33_spikes filename {tofile}/pyr33_spikes flush 0 leave_open 1 append 0

create spikehistory pyr34_spikes
setfield pyr34_spikes filename {tofile}/pyr34_spikes flush 0 leave_open 1 append 0

create spikehistory pyr38_spikes
setfield pyr38_spikes filename {tofile}/pyr38_spikes flush 0 leave_open 1 append 0

create spikehistory pyr39_spikes
setfield pyr39_spikes filename {tofile}/pyr39_spikes flush 0 leave_open 1 append 0

create spikehistory pyr40_spikes
setfield pyr40_spikes filename {tofile}/pyr40_spikes flush 0 leave_open 1 append 0

create spikehistory pyr44_spikes
setfield pyr44_spikes filename {tofile}/pyr44_spikes flush 0 leave_open 1 append 0

create spikehistory pyr45_spikes
setfield pyr45_spikes filename {tofile}/pyr45_spikes flush 0 leave_open 1 append 0

create spikehistory pyr46_spikes
setfield pyr46_spikes filename {tofile}/pyr46_spikes flush 0 leave_open 1 append 0

create spikehistory pyr52_spikes
setfield pyr52_spikes filename {tofile}/pyr52_spikes flush 0 leave_open 1 append 0

create spikehistory fb4_spikes
setfield fb4_spikes filename {tofile}/fb4_spikes flush 0 leave_open 1 append 0

create spikehistory fb5_spikes
setfield fb5_spikes filename {tofile}/fb5_spikes flush 0 leave_open 1 append 0

create spikehistory fb8_spikes
setfield fb8_spikes filename {tofile}/fb8_spikes flush 0 leave_open 1 append 0

create spikehistory ff4_spikes
setfield ff4_spikes filename {tofile}/ff4_spikes flush 0 leave_open 1 append 0

create spikehistory ff5_spikes
setfield ff5_spikes filename {tofile}/ff5_spikes flush 0 leave_open 1 append 0

addmsg {pyr_array_name}{pyr_cell_name}[22]/ax/pyr_spikegen \
	pyr22_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[26]/ax/pyr_spikegen \
	pyr26_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[27]/ax/pyr_spikegen \
	pyr27_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[28]/ax/pyr_spikegen \
	pyr28_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[32]/ax/pyr_spikegen \
	pyr32_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[33]/ax/pyr_spikegen \
	pyr33_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[34]/ax/pyr_spikegen \
	pyr34_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[38]/ax/pyr_spikegen \
	pyr38_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[39]/ax/pyr_spikegen \
	pyr39_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[40]/ax/pyr_spikegen \
	pyr40_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[44]/ax/pyr_spikegen \
	pyr44_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[45]/ax/pyr_spikegen \
	pyr45_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[46]/ax/pyr_spikegen \
	pyr46_spikes SPIKESAVE

addmsg {pyr_array_name}{pyr_cell_name}[52]/ax/pyr_spikegen \
	pyr52_spikes SPIKESAVE

addmsg {fb_array_name}{fb_cell_name}[4]/ax/spikegen \
	fb4_spikes SPIKESAVE

addmsg {fb_array_name}{fb_cell_name}[5]/ax/spikegen \
	fb5_spikes SPIKESAVE

addmsg {fb_array_name}{fb_cell_name}[8]/ax/spikegen \
	fb8_spikes SPIKESAVE

addmsg {ff_array_name}{ff_cell_name}[4]/ax/spikegen \
	ff4_spikes SPIKESAVE

addmsg {ff_array_name}{ff_cell_name}[5]/ax/spikegen \
	ff5_spikes SPIKESAVE

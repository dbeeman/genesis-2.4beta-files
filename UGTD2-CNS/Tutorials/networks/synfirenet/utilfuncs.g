// genesis 
// by D. Jaeger 4-16-2001
// Utility functions to be used in conjunction with netsim to access cellarray variables

function savesyns(fname)
str fname

openfile {fname} w

int i, j, nsyn
pushe /cellarray
for(i=1; i<=100; i=i+1)
	nsyn = {getfield c[{i}]/esyn nsynapses}
	for(j=0; j<nsyn; j=j+1)
		writefile {fname} {i} {j} {getfield c[{i}]/esyn synapse[{j}].weight} \
			{getfield c[{i}]/esyn synapse[{j}].delay}
	end
end
closefile {fname}
pope
end

function readsyns (fname)
/*
** It only works if the asci file was saved from a simulation with	
** the matching number and names of synapses defined.
*/
str fname

openfile {fname} r
pushe /cellarray/c[1]

str instr

float synpar1, synpar2, synpar3, synpar4
instr = {readfile {fname} -l}

while ({getarg {arglist {instr}} -count} ==4)

	synpar1 = {getarg {arglist {instr}} -arg 1}
	synpar2 = {getarg {arglist {instr}} -arg 2}
	synpar3 = {getarg {arglist {instr}} -arg 3}
	synpar4 = {getarg {arglist {instr}} -arg 4}
	ce ../c[{synpar1}]
	setfield esyn synapse[{synpar2}].weight {synpar3}
	setfield esyn synapse[{synpar2}].delay {synpar4}
	
	instr = {readfile {fname} -l}	
end

closefile {fname}
pope

end

function setinject(cellidx, delay, amp, width, isi)

int cellidx
float delay, amp, width, isi

if(!{exists /cellarray/c[{cellidx}]/soma/trigpulse})
create pulsegen /cellarray/c[{cellidx}]/soma/trigpulse
addmsg /cellarray/c[{cellidx}]/soma/trigpulse /cellarray/c[{cellidx}]/soma/injectpulse INPUT output
end

setfield /cellarray/c[{cellidx}]/soma/trigpulse delay1 {delay} level1 1 width1 999

setfield /cellarray/c[{cellidx}]/soma/injectpulse delay1 {isi} level1 {amp} \
	width1 {width}, trig_mode 2
end
		

function weights(cell)
int cell
int i

pushe /cellarray
for (i=0; i<9; i=i+1)
	showfield c[{cell}]/esyn synapse[{i}].weight
end
pope
end

function delays(cell)
int cell
int i

pushe /cellarray
for (i=0; i<9; i=i+1)
	showfield c[{cell}]/esyn synapse[{i}].delay
end
pope
end

function preactivity(cell)
int cell
int i

pushe /cellarray
for (i=0; i<9; i=i+1)
	showfield c[{cell}]/esyn synapse[{i}].pre_activity
end
pope
end

function learnon
int i

pushe /cellarray
for (i=11; i<=100; i=i+1)
	setfield c[{i}]/esyn change_weights 1
end
pope
end

function learnoff
int i

pushe /cellarray
for (i=11; i<=100; i=i+1)
	setfield c[{i}]/esyn change_weights 0
end
pope
end

function setsyn (field, value)
str field
float value
int i

pushe /cellarray
for (i=11; i<=100; i=i+1)
	setfield c[{i}]/esyn {field} {value}
	call c[{i}]/isyn RECALC
end
pope
end

function setigmax(gmax)
float gmax
int i

pushe /cellarray
for (i=11; i<=100; i=i+1)
setfield c[{i}]/isyn gmax {gmax}
call c[{i}]/isyn RECALC
end
pope
end

function setitau2(tau)
float tau
int i
pushe /cellarray
for (i=11; i<=100; i=i+1)
	setfield c[{i}]/isyn tau2 {tau}
	call c[{i}]/isyn RECALC
end
pope
end


function setdelays(mean, scatter)
float mean, scatter

echo Making new delays with mean of {mean} and uniform scatter of factor {scatter}
pushe /cellarray
planardelay c[]/spike \
        -fixed {mean} \
        -uniform {scatter}  // see BOGv2 p. 296
pope
end

function setweights(mean, scatter)
float mean, scatter

echo Making new delays with mean of {mean} and uniform scatter of factor {scatter}
pushe /cellarray
planarweight c[]/spike \
        -fixed {mean} \
        -uniform {scatter}  // see BOGv2 p. 296
pope
end

// genesis 2.2
// Kerstin Menne
// Luebeck, 02.10.2001
// instead of providing online graphical output, save data in ascii-files 
// and use xplot to visualize the data after the simulation is finished

// ascii.g: make_asc_file(ascname,clock,path_to_save,field_to_save)

int i
for (i=25; i<=50;i=i+1)
make_asc_file pyr{i}_soma 1 {pyr_array_name}{pyr_cell_name}[{i}]/soma Vm
end

for (i=0; i<=8;i=i+1)
make_asc_file ff{i}_soma 1 {ff_array_name}{ff_cell_name}[{i}]/soma Vm
end

for (i=0; i<=8;i=i+1)
make_asc_file fb{i}_soma 1 {fb_array_name}{fb_cell_name}[{i}]/soma Vm
end

for (i=0; i<13; i=i+1)
	make_asc_file e90_{i} 1 /e90{e_recsite1}[{i}] field
end

for (i=0; i<13; i=i+1)
	make_asc_file e120_{i} 1 /e120{e_recsite1}[{i}] field
end

for (i=0; i<13; i=i+1)
	make_asc_file e120soma_{i} 1 /e120soma{e_recsite1}[{i}] field
end 

for (i=0; i<13; i=i+1)
	make_asc_file e180_{i} 1 /e180{e_recsite1}[{i}] field
end





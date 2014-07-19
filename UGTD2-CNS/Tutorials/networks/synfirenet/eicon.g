// genesis connections.g
// by D. Jaeger 2-99


function makeconnections ( path )
str path

pushe {path}

// excitatory connections
echo Making excitatory connections ...

int i
for (i=1; i<10; i=i+1)
planarconnect c[]/spike c[]/esyn \
	-sourcemask box {{i}-0.5} 0 {{i}+0.5} 9.5 \
	-destmask box {{i}+0.5} 0 {{i}+1.5} 11 \
	-probability 1.0
end
echo Done
echo making synaptic delays of 5+-2 ms
planardelay c[]/spike \
	-fixed 0.005 \
	-uniform 0.4  // see BOGv2 p. 296
echo Done

// inhibitory connections
echo Making inhibitory connections ....

for (i=1; i<10; i=i+1)
planarconnect c[]/spike c[]/isyn \
    -sourcemask box {{i}-0.5} 9.5 {{i}+0.5} 11 \
    -destmask box {{i}-0.5} 0 {{i}+0.5} 11 \
    -probability 1.0
end

for (i=10; i<100; i=i+10)
planardelay c[{i}]/spike \
	-fixed 0.002
end

//echo Done


pope
end

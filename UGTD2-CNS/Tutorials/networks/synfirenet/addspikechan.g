// genesis
// D. Jaeger 2-15-99

// endowing the passive cell with active conductances

include spikechan

// this makes a bunch of tabchannel prototypes ready for use
make_spike_chans

function addspikecurrent (path)
str path

pushe {path}

copy /library/eds_NaF NaF
setfield NaF Gbar 2e-4
addmsg NaF . CHANNEL Gk Ek
addmsg . NaF VOLTAGE Vm

copy /library/eds_Kdr Kdr
setfield Kdr Gbar 8e-6
addmsg Kdr . CHANNEL Gk Ek
addmsg . Kdr VOLTAGE Vm

pope
end

function addothercurrent (path)
str path

pushe {path}

copy /library/eds_CaP CaP
setfield CaP Gbar 2e-6
addmsg CaP . CHANNEL Gk Ek
addmsg . CaP VOLTAGE Vm

copy /library/eds_CaT CaT
setfield CaT Gbar 2e-5
addmsg CaT . CHANNEL Gk Ek
addmsg . CaT VOLTAGE Vm

copy /library/eds_KM KM
setfield KM Gbar 2e-6
addmsg KM . CHANNEL Gk Ek
addmsg . KM VOLTAGE Vm

copy /library/eds_h1 h1
setfield h1 Gbar 2e-6
addmsg h1 . CHANNEL Gk Ek
addmsg . h1 VOLTAGE Vm

copy /library/eds_KA KA 
setfield KA Gbar 2e-5
addmsg KA . CHANNEL Gk Ek
addmsg . KA VOLTAGE Vm

pope
end

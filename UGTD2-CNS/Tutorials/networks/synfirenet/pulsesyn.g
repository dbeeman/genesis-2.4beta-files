// genesis
// by D. Jaeger  2-15-99

function makepulsesyn

// to be used as pulse of synaptic conductance

if ( !{exists /syn} )
create neutral /syn
end

pushe /syn
create leakage constsyn 
setfield ^ Ek 0.0 Gk 0.0
addmsg constsyn /cell/soma CHANNEL Gk Ek

// the next line is not strictly needed but allows the element to
// calculate it's current. This current is NOT used as injection into soma
addmsg /cell/soma constsyn VOLTAGE Vm

pope // back to where we were before this function started

end

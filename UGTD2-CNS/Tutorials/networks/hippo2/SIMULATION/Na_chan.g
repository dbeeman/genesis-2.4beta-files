// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 02.10.2001
//
// prototype Na channels for pyramidal cells and interneurons
// taken from BABEL/babeldirs/cells/traub94/traub94proto.g


//========================================================================
//                Tabchannel Na Hippocampal cell channel--soma-dend
//========================================================================
function make_Na
        if (({exists Na}))
                return
	end

        create tabchannel Na
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {ENA} Gbar 1 Ik 0 Gk 0 Xpower 2 \
                     Ypower 1 Zpower 0

        setupalpha Na X {320e3*(0.0131 + EREST_ACT)} -320e3 -1.0  \
            {-1.0*(0.0131 + EREST_ACT)} -0.004  \
            {-280e3*(0.0401 + EREST_ACT)} 280e3 -1.0  \
            {-1.0*(0.0401 + EREST_ACT)} 5.0e-3

        setupalpha Na Y 128.0 0.0 0.0 {-1.0*(0.017 + EREST_ACT)}  \
            0.018 4.0e3 0.0 1.0 {-1.0*(0.040 + EREST_ACT)} -5.0e-3
end

function make_Na_axon
        if (({exists NaA}))
                return
	end

        create tabchannel NaA
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {ENA} Gbar 1 Ik 0 Gk 0 Xpower 3 \
                     Ypower 1 Zpower 0

        setupalpha NaA X {800e3*(0.0172 + EREST_ACT)} -800e3 -1.0  \
            {-1.0*(0.0172 + EREST_ACT)} -0.004  \
            {-700e3*(0.0422 + EREST_ACT)} 700e3 -1.0  \
            {-1.0*(0.0422 + EREST_ACT)} 5.0e-3

        setupalpha NaA Y 320.0 0.0 0.0 {-1.0*(0.042 + EREST_ACT)}  \
            0.018 10.0e3 0.0 1.0 {-1.0*(0.042 + EREST_ACT)} -5.0e-3
end






// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 02.10.2001
//
// prototype K_A channels for pyramidal cells and interneurons
// taken from BABEL/babeldirs/cells/traub94/traub94proto.g
// K_A equilibrium potential of interneurons according to 
// Traub, R.D. and Miles, R., Pyramidal Cell-to-Inhibitory Cell 
// Spike Transduction Explicable by Active Dendritic Conductances in 
// Inhibitory Cell, Journal of Computational Neuroscience, 2, 291-298 (1995)


//========================================================================
//                Tabchannel K(A) Hippocampal cell channel
//========================================================================
function make_K_A
        if (({exists K_A}))
                return
        end

        create tabchannel K_A
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {pyr_EK} Gbar 1 Ik 0 Gk 0 Xpower 1  \
                    Ypower 1 Zpower 0

        setupalpha K_A X {20e3*(0.0131 + EREST_ACT)} -20e3 -1.0  \
            {-1.0*(0.0131 + EREST_ACT)} -0.01  \
            {-17.5e3*(0.0401 + EREST_ACT)} 17.5e3 -1.0  \
            {-1.0*(0.0401 + EREST_ACT)} 0.01

        setupalpha K_A Y 1.6 0.0 0.0 {0.013 - EREST_ACT} 0.018 50.0  \
            0.0 1.0 {-1.0*(0.0101 + EREST_ACT)} -0.005
end

// ======================================================0
// same channel for interneuron; different Ek
// =======================================================

function make_K_Ai
        if (({exists K_Ai}))
                return
        end

        create tabchannel K_Ai
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {int_EK} Gbar 1 Ik 0 Gk 0 Xpower 1  \
                    Ypower 1 Zpower 0

        setupalpha K_Ai X {20e3*(0.0131 + EREST_ACT)} -20e3 -1.0  \
            {-1.0*(0.0131 + EREST_ACT)} -0.01  \
            {-17.5e3*(0.0401 + EREST_ACT)} 17.5e3 -1.0  \
            {-1.0*(0.0401 + EREST_ACT)} 0.01

        setupalpha K_Ai Y 1.6 0.0 0.0 {0.013 - EREST_ACT} 0.018 50.0  \
            0.0 1.0 {-1.0*(0.0101 + EREST_ACT)} -0.005
end

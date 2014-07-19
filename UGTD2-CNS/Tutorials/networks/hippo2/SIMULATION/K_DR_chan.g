// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 02.10.2001
//
// prototype K_DR channels for pyramidal cells and interneurons
// taken from BABEL/babeldirs/cells/traub94/traub94proto.g
// K_DR equilibrium potential of interneurons according to 
// Traub, R.D. and Miles, R., Pyramidal Cell-to-Inhibitory Cell 
// Spike Transduction Explicable by Active Dendritic Conductances in 
// Inhibitory Cell, Journal of Computational Neuroscience, 2, 291-298 (1995)



//========================================================================
//                Tabchannel K(DR) Hippocampal cell channel--soma-dend
//========================================================================
function make_K_DR
        if (({exists K_DR}))
                return
        end

        create tabchannel K_DR
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {pyr_EK} Gbar 1 Ik 0 Gk 0 Xpower 2  \
                    Ypower 0 Zpower 0

        setupalpha K_DR X {16e3*(0.0351 + EREST_ACT)} -16e3 -1.0  \
            {-1.0*(0.0351 + EREST_ACT)} -0.005 250 0.0 0.0  \
            {-1.0*(0.02 + EREST_ACT)} 0.04
end

// ===============================================================
// in the case of interneurons we have a different equilibrium potential
// ================================================================
function make_K_DRi
        if (({exists K_DRi}))
                return
        end

        create tabchannel K_DRi
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {int_EK} Gbar 1 Ik 0 Gk 0 Xpower 2  \
                    Ypower 0 Zpower 0

        setupalpha K_DRi X {16e3*(0.0351 + EREST_ACT)} -16e3 -1.0  \
            {-1.0*(0.0351 + EREST_ACT)} -0.005 250 0.0 0.0  \
            {-1.0*(0.02 + EREST_ACT)} 0.04
end

function make_K_DR_axon
        if (({exists K_DRA}))
                return
        end

        create tabchannel K_DRA
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {pyr_EK} Gbar 1 Ik 0 Gk 0 Xpower 4  \
                    Ypower 0 Zpower 0

        setupalpha K_DRA X {30e3*(0.0172 + EREST_ACT)} -30e3 -1.0  \
            {-1.0*(0.0172 + EREST_ACT)} -0.005 450 0.0 0.0  \
            {-1.0*(0.012 + EREST_ACT)} 0.04
end

function make_K_DR_axoni
        if (({exists K_DRAi}))
                return
        end

        create tabchannel K_DRAi
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {int_EK} Gbar 1 Ik 0 Gk 0 Xpower 4  \
                    Ypower 0 Zpower 0

        setupalpha K_DRAi X {30e3*(0.0172 + EREST_ACT)} -30e3 -1.0  \
            {-1.0*(0.0172 + EREST_ACT)} -0.005 450 0.0 0.0  \
            {-1.0*(0.012 + EREST_ACT)} 0.04
end


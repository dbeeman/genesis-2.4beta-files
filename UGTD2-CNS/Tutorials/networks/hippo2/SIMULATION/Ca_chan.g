// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 02.10.2001
//
// prototype Ca channels and Ca concentration for pyramidal cells and 
// interneurons
// taken from BABEL/babeldirs/cells/traub94/traub94proto.g
// somatic Ca decay time for interneurons according to 
// Traub, R.D. and Miles, R., Pyramidal Cell-to-Inhibitory Cell 
// Spike Transduction Explicable by Active Dendritic Conductances in 
// Inhibitory Cell, Journal of Computational Neuroscience, 2, 291-298 (1995)


//========================================================================
//                      Tabulated Ca Channel
//========================================================================

function make_Ca
        if (({exists Ca}))
                return
        end

        create tabchannel Ca
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {ECA} Gbar 1 Ik 0 Gk 0 Xpower 2  \
                    Ypower 0 Zpower 0

// Converting Traub's expressions for the gCa/s alpha and beta functions
// to SI units and entering the A, B, C, D and F parameters, we get:

        setupalpha Ca X 1.6e3 0 1.0 {-1.0*(0.065 + EREST_ACT)}  \
            -0.01389 {-20e3*(0.0511 + EREST_ACT)} 20e3 -1.0  \
            {-1.0*(0.0511 + EREST_ACT)} 5.0e-3

end

//========================================================================
//                      Ca concentration
//========================================================================

function make_Ca_conc
        if (({exists Ca_conc}))
                return
        end
        create Ca_concen Ca_conc
        // 0.01333 sec
        // Curr to conc for soma
        setfield Ca_conc tau 0.020 B 17.402e12 Ca_base 0.0
        if (!{exists Ca_conc sendmsg1})
            addfield Ca_conc sendmsg1
        end
        setfield  Ca_conc sendmsg1 "../Ca . I_Ca Ik"
end

function make_Ca_conc_soma
        if (({exists Ca_concs}))
                return
        end
        create Ca_concen Ca_concs
        // 0.01333 sec
        // Curr to conc for soma
        setfield Ca_concs tau 1.0 B 17.402e12 Ca_base 0.0
        if (!{exists Ca_concs sendmsg1})
            addfield Ca_concs sendmsg1
        end
        setfield  Ca_concs sendmsg1 "../Ca . I_Ca Ik"
end

// ==================================================
// for interneurons somatic Ca decay time is much faster, compared to pyramidal
// cell
// =================================================

function make_Ca_conc_somai
        if (({exists Ca_concsi}))
                return
        end
        create Ca_concen Ca_concsi
        // 0.01333 sec
        // Curr to conc for soma
        setfield Ca_concsi tau 0.333 B 17.402e12 Ca_base 0.0
        if (!{exists Ca_concsi sendmsg1})
            addfield Ca_concsi sendmsg1
        end
        setfield  Ca_concsi sendmsg1 "../Ca . I_Ca Ik"
end


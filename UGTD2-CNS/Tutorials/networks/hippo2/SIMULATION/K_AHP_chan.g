// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 02.10.2001
//
// prototype K_AHP channels for pyramidal cells and interneurons
// taken from BABEL/babeldirs/cells/traub94/traub94proto.g
// K_AHP equilibrium potential of interneurons according to 
// Traub, R.D. and Miles, R., Pyramidal Cell-to-Inhibitory Cell 
// Spike Transduction Explicable by Active Dendritic Conductances in 
// Inhibitory Cell, Journal of Computational Neuroscience, 2, 291-298 (1995)


//========================================================================
// Tabulated Ca-dependent K AHP Channel
//========================================================================
function make_K_AHP
        if (({exists K_AHP}))
                return
        end

        create tabchannel K_AHP
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {pyr_EK} Gbar 1 Ik 0 Gk 0 Xpower 0  \
                    Ypower 0 Zpower 1

                // Allocate space in the Z gate A and B tables, covering a concentration
                // range from xmin = 0 to xmax = 1000, with 50 divisions
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50

        call K_AHP TABCREATE Z {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 500.0)
                y = 0.02*x
            else
                y = 10.0
            end
            setfield K_AHP Z_A->table[{i}] {y}
            setfield K_AHP Z_B->table[{i}] {y + 1.0}
            x = x + dx
        end
        // For speed during execution, set the calculation mode to "no interpolation"
        // and use TABFILL to expand the table to 3000 entries.
        setfield K_AHP Z_A->calc_mode 0 Z_B->calc_mode 0
        call K_AHP TABFILL Z 3000 0
        // Use an environment variable to tell the cell reader to set up the
        // CONCEN message from the Ca_concen element
        if (!{exists K_AHP sendmsg1})
            addfield K_AHP sendmsg1
        end
        setfield  K_AHP sendmsg1 "../Ca_conc . CONCEN Ca"
end


function make_K_AHP_soma
        if (({exists K_AHPs}))
                return
        end

        create tabchannel K_AHPs
                //      V 
                //      S 
                //      A 
                //      S 
                setfield ^ Ek {pyr_EK} Gbar 1 Ik 0 Gk 0 Xpower 0  \
                    Ypower 0 Zpower 1

                // Allocate space in the Z gate A and B tables, covering a concentration
                // range from xmin = 0 to xmax = 1000, with 50 divisions
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50

        call K_AHPs TABCREATE Z {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 500.0)
                y = 0.02*x
            else
                y = 10.0
            end
            setfield K_AHPs Z_A->table[{i}] {y}
            setfield K_AHPs Z_B->table[{i}] {y + 1.0}
            x = x + dx
        end
        // For speed during execution, set the calculation mode to "no interpolation"
        // and use TABFILL to expand the table to 3000 entries.
        setfield K_AHPs Z_A->calc_mode 0 Z_B->calc_mode 0
        call K_AHPs TABFILL Z 3000 0
        // Use an environment variable to tell the cell reader to set up the
        // CONCEN message from the Ca_concen element
        if (!{exists K_AHPs sendmsg1})
            addfield K_AHPs sendmsg1
        end
        setfield  K_AHPs sendmsg1 "../Ca_concs . CONCEN Ca"
end

// ==================================================0
// same channels for interneurons; different Ek
// ===================================================

function make_K_AHPi
        if (({exists K_AHPi}))
                return
        end

        create tabchannel K_AHPi
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {int_EK} Gbar 1 Ik 0 Gk 0 Xpower 0  \
                    Ypower 0 Zpower 1

                // Allocate space in the Z gate A and B tables, covering a concentration
                // range from xmin = 0 to xmax = 1000, with 50 divisions
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50

        call K_AHPi TABCREATE Z {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 500.0)
                y = 0.02*x
            else
                y = 10.0
            end
            setfield K_AHPi Z_A->table[{i}] {y}
            setfield K_AHPi Z_B->table[{i}] {y + 1.0}
            x = x + dx
        end
        // For speed during execution, set the calculation mode to "no interpolation"
        // and use TABFILL to expand the table to 3000 entries.
        setfield K_AHPi Z_A->calc_mode 0 Z_B->calc_mode 0
        call K_AHPi TABFILL Z 3000 0
        // Use an environment variable to tell the cell reader to set up the
        // CONCEN message from the Ca_concen element
        if (!{exists K_AHPi sendmsg1})
            addfield K_AHPi sendmsg1
        end
        setfield  K_AHPi sendmsg1 "../Ca_conc . CONCEN Ca"
end

function make_K_AHP_somai
        if (({exists K_AHPsi}))
                return
        end

        create tabchannel K_AHPsi
                //      V 
                //      S 
                //      A 
                //      S 
                setfield ^ Ek {int_EK} Gbar 1 Ik 0 Gk 0 Xpower 0  \
                    Ypower 0 Zpower 1

                // Allocate space in the Z gate A and B tables, covering a concentration
                // range from xmin = 0 to xmax = 1000, with 50 divisions
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50

        call K_AHPsi TABCREATE Z {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 500.0)
                y = 0.02*x
            else
                y = 10.0
            end
            setfield K_AHPsi Z_A->table[{i}] {y}
            setfield K_AHPsi Z_B->table[{i}] {y + 1.0}
            x = x + dx
        end
        // For speed during execution, set the calculation mode to "no interpolation"
        // and use TABFILL to expand the table to 3000 entries.
        setfield K_AHPsi Z_A->calc_mode 0 Z_B->calc_mode 0
        call K_AHPsi TABFILL Z 3000 0
        // Use an environment variable to tell the cell reader to set up the
        // CONCEN message from the Ca_concen element
        if (!{exists K_AHPsi sendmsg1})
            addfield K_AHPsi sendmsg1
        end
        setfield  K_AHPsi sendmsg1 "../Ca_concsi . CONCEN Ca"
end

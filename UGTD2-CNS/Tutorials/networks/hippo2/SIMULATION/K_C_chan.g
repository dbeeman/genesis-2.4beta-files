// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 02.10.2001
//
// prototype K_C channels for pyramidal cells and interneurons
// taken from BABEL/babeldirs/cells/traub94/traub94proto.g
// K_C equilibrium potential of interneurons according to 
// Traub, R.D. and Miles, R., Pyramidal Cell-to-Inhibitory Cell 
// Spike Transduction Explicable by Active Dendritic Conductances in 
// Inhibitory Cell, Journal of Computational Neuroscience, 2, 291-298 (1995)


//========================================================================
//  Ca-dependent K Channel - K(C) - (vdep_channel with table and tabgate)
//========================================================================
function make_K_C
        if (({exists K_C}))
                return
        end

        create vdep_channel K_C
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {pyr_EK} gbar 1 Ik 0 Gk 0

        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50
        create table K_C/tab
        call K_C/tab TABCREATE {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 250.0)
                y = x/250.0
            else
                y = 1.0
            end
            setfield K_C/tab table->table[{i}] {y}
            x = x + dx
        end
	setfield K_C/tab table->calc_mode 0
	call K_C/tab TABFILL 3000 0
        float xmin = -0.1
        float xmax = 0.05
        int xdivs = 49
        create tabgate K_C/X
        call K_C/X TABCREATE alpha {xdivs} {xmin} {xmax}
        call K_C/X TABCREATE beta {xdivs} {xmin} {xmax}

        int i
        float x, dx, alpha, beta
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < EREST_ACT + 0.05)
                alpha = ({exp {53.872*(x - EREST_ACT) - 0.66835}})/0.018975
		beta = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}}) - alpha
            else
		alpha = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}})
		beta = 0.0
            end
            setfield K_C/X alpha->table[{i}] {alpha}
            setfield K_C/X beta->table[{i}] {beta}
            x = x + dx
        end

	setfield K_C/X alpha->calc_mode 0 beta->calc_mode 0
	call K_C/X TABFILL alpha 3000 0
	call K_C/X TABFILL beta 3000 0

        addmsg K_C/tab K_C MULTGATE output 1
        addmsg K_C/X K_C MULTGATE m 1
        if (!{exists K_C sendmsg1})
            addfield K_C sendmsg1
        end
        if (!{exists K_C sendmsg2})
            addfield K_C sendmsg2
        end
        setfield  K_C sendmsg1 "../Ca_conc  tab INPUT Ca"  \
            sendmsg2 "..  X  VOLTAGE Vm"
end


function make_K_C_soma
        if (({exists K_Cs}))
                return
        end

        create vdep_channel K_Cs
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {pyr_EK} gbar 1 Ik 0 Gk 0
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50
        create table K_Cs/tab
        call K_Cs/tab TABCREATE {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 250.0)
                y = x/250.0
            else
                y = 1.0
            end
            setfield K_Cs/tab table->table[{i}] {y}
            x = x + dx
        end
        setfield K_Cs/tab table->calc_mode 0
        call K_Cs/tab TABFILL 3000 0
        float xmin = -0.1
        float xmax = 0.05
        int xdivs = 49
        create tabgate K_Cs/X
        call K_Cs/X TABCREATE alpha {xdivs} {xmin} {xmax}
        call K_Cs/X TABCREATE beta {xdivs} {xmin} {xmax}

        int i
        float x, dx, alpha, beta
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < EREST_ACT + 0.05)
                alpha = ({exp {53.872*(x - EREST_ACT) - 0.66835}})/0.018975
                beta = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}}) - alpha
            else
                alpha = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}})
                beta = 0.0
            end
            setfield K_Cs/X alpha->table[{i}] {alpha}
            setfield K_Cs/X beta->table[{i}] {beta}
            x = x + dx
        end

        setfield K_Cs/X alpha->calc_mode 0 beta->calc_mode 0
        call K_Cs/X TABFILL alpha 3000 0
        call K_Cs/X TABFILL beta 3000 0

        addmsg K_Cs/tab K_Cs MULTGATE output 1
        addmsg K_Cs/X K_Cs MULTGATE m 1
        if (!{exists K_Cs sendmsg1})
            addfield K_Cs sendmsg1
        end
        if (!{exists K_Cs sendmsg2})
            addfield K_Cs sendmsg2
        end
        setfield  K_Cs sendmsg1 "../Ca_concs  tab INPUT Ca"  \
            sendmsg2 "..  X  VOLTAGE Vm"
end

// =====================================================
// same channels for interneuron; different Ek
// =====================================================

function make_K_Ci
        if (({exists K_Ci}))
                return
        end

        create vdep_channel K_Ci
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {int_EK} gbar 1 Ik 0 Gk 0
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50
        create table K_Ci/tab
        call K_Ci/tab TABCREATE {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 250.0)
                y = x/250.0
            else
                y = 1.0
            end
            setfield K_Ci/tab table->table[{i}] {y}
            x = x + dx
        end
	setfield K_Ci/tab table->calc_mode 0
	call K_Ci/tab TABFILL 3000 0
        float xmin = -0.1
        float xmax = 0.05
        int xdivs = 49
        create tabgate K_Ci/X
        call K_Ci/X TABCREATE alpha {xdivs} {xmin} {xmax}
        call K_Ci/X TABCREATE beta {xdivs} {xmin} {xmax}

        int i
        float x, dx, alpha, beta
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < EREST_ACT + 0.05)
                alpha = ({exp {53.872*(x - EREST_ACT) - 0.66835}})/0.018975
		beta = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}}) - alpha
            else
		alpha = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}})
		beta = 0.0
            end
            setfield K_Ci/X alpha->table[{i}] {alpha}
            setfield K_Ci/X beta->table[{i}] {beta}
            x = x + dx
        end

	setfield K_Ci/X alpha->calc_mode 0 beta->calc_mode 0
	call K_Ci/X TABFILL alpha 3000 0
	call K_Ci/X TABFILL beta 3000 0

        addmsg K_Ci/tab K_Ci MULTGATE output 1
        addmsg K_Ci/X K_Ci MULTGATE m 1
        if (!{exists K_Ci sendmsg1})
            addfield K_Ci sendmsg1
        end
        if (!{exists K_Ci sendmsg2})
            addfield K_Ci sendmsg2
        end
        setfield  K_Ci sendmsg1 "../Ca_conc  tab INPUT Ca"  \
            sendmsg2 "..  X  VOLTAGE Vm"
end

function make_K_C_somai
        if (({exists K_Csi}))
                return
        end

        create vdep_channel K_Csi
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {int_EK} gbar 1 Ik 0 Gk 0
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50
        create table K_Csi/tab
        call K_Csi/tab TABCREATE {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 250.0)
                y = x/250.0
            else
                y = 1.0
            end
            setfield K_Csi/tab table->table[{i}] {y}
            x = x + dx
        end
        setfield K_Csi/tab table->calc_mode 0
        call K_Csi/tab TABFILL 3000 0
        float xmin = -0.1
        float xmax = 0.05
        int xdivs = 49
        create tabgate K_Csi/X
        call K_Csi/X TABCREATE alpha {xdivs} {xmin} {xmax}
        call K_Csi/X TABCREATE beta {xdivs} {xmin} {xmax}

        int i
        float x, dx, alpha, beta
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < EREST_ACT + 0.05)
                alpha = ({exp {53.872*(x - EREST_ACT) - 0.66835}})/0.018975
                beta = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}}) - alpha
            else
                alpha = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}})
                beta = 0.0
            end
            setfield K_Csi/X alpha->table[{i}] {alpha}
            setfield K_Csi/X beta->table[{i}] {beta}
            x = x + dx
        end

        setfield K_Csi/X alpha->calc_mode 0 beta->calc_mode 0
        call K_Csi/X TABFILL alpha 3000 0
        call K_Csi/X TABFILL beta 3000 0

        addmsg K_Csi/tab K_Csi MULTGATE output 1
        addmsg K_Csi/X K_Csi MULTGATE m 1
        if (!{exists K_Csi sendmsg1})
            addfield K_Csi sendmsg1
        end
        if (!{exists K_Csi sendmsg2})
            addfield K_Csi sendmsg2
        end
        setfield  K_Csi sendmsg1 "../Ca_concsi  tab INPUT Ca"  \
            sendmsg2 "..  X  VOLTAGE Vm"
end


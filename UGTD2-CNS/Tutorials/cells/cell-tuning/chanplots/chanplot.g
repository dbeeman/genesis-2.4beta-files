//genesis
// Hacked version of neurokit/xchannel_funcs.g for testing channels

int kincolor = 15

function do_xchannel_funcs
	create xform /channel_params [0,0,800,450]
	pushe /channel_params
	create xgraph alpha [0,0,50%,45%] -range [-0.1,0,0.1,1]
	setfield alpha ymin 0 overlay 0 XUnits Volts YUnits "1/sec"
	create xgraph beta [50%,0,50%,45%] -range [-0.1,0,0.1,1]
	setfield beta ymin 0 overlay 0 XUnits Volts YUnits "1/sec"
	create xgraph taus	[0,39%,50%,45%] -range [-0.1,0,0.1,1]
	setfield taus ymin 0 overlay 0 XUnits Volts YUnits "sec"
	create xgraph minf	[50%,39%,50%,45%] -range [-0.1,0,0.1,1]
	setfield minf ymin 0 overlay 0 XUnits Volts YUnits "minf"
    create xdialog gate [4,4:minf.bottom,19%,30] -value "X" \
		-script "do_plot_kinetics "<widget>
    create xtoggle overlay [20%,4:minf.bottom,19%,30]
    setfield ^ label0 "overlay off" label1 "overlay on"
    create xdialog channel_path [4,4:overlay.bottom,75%,30] -value {channelpath} \
		 -script set_channelpath
	create xbutton QUIT [75%,4:overlay.bottom,24%,30] -script quit 
pope
end

function set_channelpath
	channelpath = {getfield /channel_params/channel_path value}
end

function deleteelms(path)
    str elm
    foreach elm ({el {path}})
        delete {elm}
    end
end

function do_plot_kinetics(widget)
	str widget
    str gate = {getfield {widget} value}

	str channeltype
	str gatepath
	float x,y,a,b,tau
	float xmin=-0.1,xmax=0.07,dx=0.002
	float amax=-1.0,bmax=-1.0,mmax=-1.0,tmax=-1.0
	str	kinname
	int i

	ce /channel_params
	dx = 0.005

   if (!({exists {channelpath}}))
		return
	end

	kinname = {getfield {channelpath} name} @ "->" @ (gate)
        channeltype = {getfield {channelpath} object->name}
        if ({getfield /channel_params/overlay state} == 0)
            deleteelms alpha/##[ISA=xplot]
            deleteelms beta/##[ISA=xplot]
            deleteelms taus/##[ISA=xplot]
            deleteelms minf/##[ISA=xplot]
            setfield alpha ymax 1e6
            setfield beta ymax 1e6
            setfield taus ymax 1e6
            setfield taus ymax 1e6
            kincolor = 15
	else
		kincolor = kincolor + 15
		if (kincolor > 99)
			kincolor = kincolor - 95
		end
		    amax = {getfield alpha ymax}
            bmax = {getfield beta ymax}
            mmax = {getfield minf ymax}
            tmax = {getfield taus ymax}
	end

	if ({strcmp {channeltype} hh_channel} == 0)
		if ((!{strcmp {gate} "X"} == 0) || ({strcmp {gate} "Y"} == 0))
			echo For hh channels, gate must be X or Y
			return
		end
	end

	if ({strcmp {channeltype} tabchannel} == 0)
		if (!(({strcmp {gate} "X"} == 0) || ({strcmp {gate} "Y"} == 0) || ({strcmp {gate} "Z"} == 0)))

			echo For vdep channels, gate must be X or Y or Z
			return
		end
        if ({getfield {channelpath} {gate}_alloced} == 1)
             xmin = {getfield {channelpath} {gate}_A->xmin}
             xmax = {getfield {channelpath} {gate}_A->xmax}
             dx = {getfield {channelpath} {gate}_A->dx}
             if (dx < ((xmax - xmin)/100.0))
                dx = (xmax - xmin)/100.0
             end
		else
			echo gate {gate} not allocated
			return
		end
	end

	if (({strcmp {channeltype} hh_channel} == 0) || \
		({strcmp {channeltype} tabchannel} == 0))

            if (!{exists alpha/{kinname}})
                create xplot alpha/{kinname}
            end
            if (!{exists beta/{kinname}})
                create xplot beta/{kinname}
            end
            if (!{exists taus/{kinname}})
                create xplot taus/{kinname}
            end
            for (x = xmin; x <= xmax; x = x + dx)

        a = {call {channelpath} CALC_ALPHA {gate} {x}}
        if (amax < a)
           amax = a
        end

     b = {call {channelpath} CALC_BETA {gate} {x}}
        if (bmax < b)
            bmax = b
        end
            tau = 1/(a + b)
        if (tau > tmax)
           tmax = tau
        end
        call alpha/{kinname} ADDPTS {x} {a}
        setfield alpha/{kinname} fg {kincolor}
        call beta/{kinname} ADDPTS {x} {b}
        setfield beta/{kinname} fg {kincolor}
        call taus/{kinname} ADDPTS {x} {tau}
        setfield taus/{kinname} fg {kincolor}
    end

    if (!{exists minf/{kinname}})
        create xplot minf/{kinname}
    end
	for (x = xmin ; x <= xmax ; x = x + dx)
			y = {call {channelpath} CALC_MINF {gate} {x}}
			if (y > mmax)
				mmax = y
			end
            call minf/{kinname} ADDPTS {x} {y}
            setfield minf/{kinname} fg {kincolor}
      end
		setfield alpha ymax {amax} xmin {xmin} xmax {xmax}
		setfield beta ymax {bmax} xmin {xmin} xmax {xmax}
		setfield taus ymax {tmax} xmin {xmin} xmax {xmax}
		setfield minf ymax {mmax} xmin {xmin} xmax {xmax}
	end

/* deal with vdep_channel later
	if ({strcmp {channeltype} vdep_channel} == 0)
        gatepath = (channelpath) @ "/" @ (gate)
		if (!{exists({gatepath})})
			echo Gate {gatepath} does not exist.
			return
		end
		if ({strcmp {getfield {gatepath} object->name} vdep_gate) != 0)
			xmin = get({gatepath},alpha->xmin)
			xmax = get({gatepath},alpha->xmax)
			dx = get({gatepath},alpha->dx)
			if (dx < {(xmax - xmin)/100.0})
				dx = (xmax - xmin)/100.0
			end
		end
		for (x = xmin ; x <= xmax ; x = x + dx)

			a = call({gatepath},CALC_ALPHA,{x})
			if (amax < a )
				amax = a
			end

			b = call({gatepath},CALC_BETA,{x})
			if (bmax < b)
				bmax = b
			end
			tau = 1/(a+b)
			if (tau > tmax)
				tmax = tau
			end
			xaddpts alpha -plotname {kinname} -color hot{kincolor} {x} {a}
			xaddpts beta -plotname {kinname} -color hot{kincolor} {x} {b}
			xaddpts taus -plotname {kinname} -color hot{kincolor} {x} {tau}
		end

		for (x = xmin ; x <= xmax ; x = x + dx)
			y = call({gatepath},CALC_MINF,{x})
			if (y > mmax)
				mmax = y
			end
			xaddpts minf -plotname {kinname} -color hot{kincolor} {x} {y}
		end

		set alpha ymax {amax} xmin {xmin} xmax {xmax}
		set beta ymax {bmax} xmin {xmin} xmax {xmax}
		set taus ymax {tmax} xmin {xmin} xmax {xmax}
		set minf ymax {mmax} xmin {xmin} xmax {xmax}
	end
	if (strcmp({channeltype},channelC2) == 0)
	end
	if (strcmp({channeltype},table) == 0)
	end
*/
	ce /
end

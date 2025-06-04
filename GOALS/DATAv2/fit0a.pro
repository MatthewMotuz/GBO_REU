pro fit0a,sc
;;check low level baselines comparisons with medsub
freexy
getrec,sc
gsmooth,7,/decimate
medsub
show
freeze
getrec,sc+1
gsmooth,7,/decimate
medsub
oshow
unfreeze
return
end


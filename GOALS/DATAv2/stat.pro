pro stat
;;
;;works on data in current container and with velocity scale in km/s
;;
;;Calibration correction factor 
;;;tcal measured at 1.65 using 3c sources
;;but given as 1.45 in calibration table
;cfac=1.138
;;correct calibration later
cfac=1.0

print,'Off source region for noise measurement'


stats,ret=astats

rms1=cfac*astats.rms

print,'Measure Line emission'


stats,ret=bstats

ch1=bstats.bchan
ch2=bstats.echan
peak=bstats.max
line=bstats.area
vel=0.001*!g.s[0].source_velocity
exp=!g.s[0].exposure
source=!g.s[0].source

print,source,vel,exp
print,line,peak,ch1,ch2,rms1

outfile='output_stat'
openw,lun,outfile,/GET_LUN,/append
fmt='(a15,f10.1,f10.2,f10.2,f10.5,i6,i6,f10.6)'
printf,lun,format=fmt,source,vel,exp,line,peak,ch1,ch2,rms1

free_lun,lun

return
end

;;area in Ta*km/s

;GBTIDL -> stats,/full,ret=astats
;    Chans    bchan    echan        Xmin        Xmax        Ymin        Ymax
;     4096        0     4095      1.3875      1.4000    -0.49146      1.7022
;
;                       Mean      Median         RMS    Variance        Area
;                    0.32277     0.30964    0.074265   0.0055153   0.0040345


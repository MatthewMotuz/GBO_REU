pro k2jy

;;Converts current data container (0) from Ta (K) to Sn (Jy)
;;making the appropriate Tcal correction as a function of frequency
;;and polarization
;;
;;Freq in GHz
freq=!g.s[0].observed_frequency/1.e9
pol=!g.s[0].polarization

if (pol eq 'YY' and freq gt 1.335) then  INN='TCAL2010_L_YY_NONOTCH'
if (pol eq 'XX' and freq gt 1.335) then  INN='TCAL2010_L_XX_NONOTCH'
if (pol eq 'YY' and freq le 1.335) then  INN='TCAL2010_L_YY_NOTCH'
if (pol eq 'XX' and freq le 1.335) then  INN='TCAL2010_L_XX_NOTCH'

INfile='/data/scratch/dfrayer/GOALS/AGBT10B14/CAL/'+INN

readcol,INfile,c1,c2

;;Average +/-5MHz around Freq consistent with 80% bandwidth method
;;used by the GBT for calibration
dnu=0.005

bb=where(c1 lt freq+dnu and c1 gt freq-dnu)

tcal=avg(c2[bb])

airm=1./(sin(!g.s[0].elevation*!pi/180.))
tau=get_tau(freq)

;;Convert to data to snu
;;Snu = Ta*exp(tau_o*Airm)*(1Jy/2.0)*tcal/!g.s[0].mean_tcal
;;1.97 is 2.0/(exp(tau) for typical observations
;;Note did not apply ATM for independent sessions
;;but avg correction is 1.96-->1.98 depending on source declination
;;
sf=0.50*exp(tau*airm)*tcal/!g.s[0].mean_tcal
;;
print,'Scaling data by [Jy/K]',sf, '  Tcal ratio is',tcal/!g.s[0].mean_tcal
scale,sf
!g.s[0].units='Jy'
show

return 
end

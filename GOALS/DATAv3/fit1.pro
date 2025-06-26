pro fit1,sc
;;combines data from save file for individual polarizations
;;calibrates each separate first and then accums

freexy
sclear

getrec,sc
print,!g.s[0].source
k2jy
accum
v1=median(getdata(0))
getrec,sc+1
k2jy
accum
v2=median(getdata(0))
ave
v3=median(getdata(0))
;;
print,'Rough continuum levels in K and difference between pols [K]:'
print,v3, abs(v1-v2)
;copy,0,10
chan

print,'Smoothing the data to 4.5km/s [7channels]'
gsmooth,7,/decimate
copy,0,10
histogram

;;replace after smoothing
;;Reduction/Measurement steps
;; (1) run fit1.pro to combine polarizations
;;
;; (2) replace narrow RFI channels if needed interactively 
;; Linear interpolate across channels
;; zoom, chan,
;; replace,ch1,ch2
;; 
;; (3) Smooth/decimate channels by 7 (~4.5km/s) and Fit baseline
;;     by running fit2
;;
;; (4) Make measurements and save ascii spectra
;;     by running fit3

;;
;fileout,'rawcombine.fits'

;nsave,outnum

;fileout,'junk.fits'

;;
return

end


pro abspeak_fix
;;derive negative peaks for ABS features 
;;(reduction routine returned the MAX not the negative peak)
;;

;freexy
;getrec,rec
;velo
;show



print,'Measure min/max of line profile'
stats,ret=bstats
;;peak in mJy
pk=bstats.max*1000.
npk=bstats.min*1000.

print,!g.s[0].source,'Max, Min',pk,npk

print,'If remeasure line click enter 1'
read,x

if (x eq 1) then begin
 print,'Select RMS region'
 stats,ret=out
 print,'RMS',out.rms
 print,'Measure Line emission or noise region again if non-detection'
 stats,ret=bstats
;;rms in mJy
 rms1=out.rms*1000.
 c1=bstats.bchan
 c2=bstats.echan
;;peak in mJy
 pk=bstats.max*1000.
;;Area in Jy km/s
 skms=bstats.area
 print,'Line intensity [Jy km/s]',skms
endif

return
end

pro fit2
histogram
;;runs smoothing step
copy,0,11
;print,'Smoothing the data to 4.5km/s [7channels]'
;gsmooth,7,/decimate
freexy
chan
setx,30,560
freey
ok=0
x=3
;;Removes baselines
while (ok eq 0) do begin
   print,'set baseline region'
   setregion
   fok=0
   while (fok eq 0) do begin
     print,'enter baseline fit'
     read,x 
     nfit,x
     bshape
     print,'Enter 0 to enter different polonomial or 1 if done'
     read,fok
    endwhile
;;save model in 3 for continuum level
   baseline,modelbuffer=3
   print,'enter 0 to repeat or 1 if done'
   read,ok
   if (ok eq 0) then begin 
     copy,11,0
;     gsmooth,7,/decimate
     freey
  endif

endwhile
;;save results in 12
velo
copy,0,12

return
end


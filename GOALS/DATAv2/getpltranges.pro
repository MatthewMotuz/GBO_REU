pro getpltranges,sc1,sc2

freexy
velo

outfile='plotranges.dat'
openw,lun,outfile,/get_lun,/append
print,lun
fmt='(a,f,f,f,f)'
for i=sc1,sc2 do begin
 getrec,i
 show
 ok = 0
 while (ok eq 0) do begin
   print,'Click BLC of plot'
   c1 = click()
   print,'Click TRC of plot'
   c2= click()
   setx,c1.x,c2.x
   sety,c1.y,c2.y
   print,'Enter 1 when done or 0 to do again'
   print,'Enter 2 to reset plot and do again'
   read,ok
   if (ok eq 2) then begin
      freexy
      ok =0
   endif
 endwhile
;;save output as file
 printf,lun,format=fmt,!g.s[0].source, c1.x,c1.y,c2.x,c2.y
;;
 freexy
 endfor
free_lun,lun

return
end

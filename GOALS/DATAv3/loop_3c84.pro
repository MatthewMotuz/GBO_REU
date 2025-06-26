pro loop_3c84,plnum=plnum

;;sessions and scan range
;;F03164+4119 07 77 82 24 49 52 28 7 8 28 10 17

filein,'data/AGBT10B_014_07.raw.acs.fits'
;;set
nfit,3
xx=0
;for ii=77,82,2 do begin
;   getps,ii,ifnum=0,plnum=plnum
;   bshape
;   baseline
;   read,xx
;   accum
;   getps,ii,ifnum=1,plnum=plnum
;   bshape
;   baseline
;   accum

;endfor


filein,'data/AGBT10B_014_24.raw.acs.fits'
for ii=49,52,2 do begin
   getps,ii,ifnum=0,plnum=plnum
   bshape
   baseline
   read,xx
   accum
   getps,ii,ifnum=1,plnum=plnum
   bshape
   baseline
   accum

endfor

filein,'data/AGBT10B_014_28.raw.acs.fits'
;for ii=7,8,2 do begin
;   getps,ii,ifnum=0,plnum=plnum
;   bshape
;   baseline
;   read,xx
;   accum
;   getps,ii,ifnum=1,plnum=plnum
;   bshape
;   baseline
;   accum

;endfor
for ii=12,17,2 do begin
   getps,ii,ifnum=0,plnum=plnum
   bshape
   baseline
   read,xx
   accum
   getps,ii,ifnum=1,plnum=plnum
   bshape
   baseline
   accum

endfor
ave

return
end

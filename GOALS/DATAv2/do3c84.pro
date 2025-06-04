pro do3c84,OUTDIR
;; e.g., dogroups,'reduc1'
;;Process only 3c84 data
;;
freexy
sclear

fmt='a,a,i,i,a,i,i,a,i,i,a,i,i,a,i,i'
readcol,'REDUC/sessions_list',FORMAT=fmt,n1,s1,b1,e1,s2,b2,e2,s3,b3,e3,s4,b4,e4,s5,b5,e5

source='F03164+4119'

bb=where(n1 eq source)
;;should read 162 lines ok (need zeros)

nn=n_elements(b1)
myoutfile=OUTDIR+'/rawcombine_info'

nout=0
nout1=0
jj=bb[0]
;for jj=0,nn-1 do begin
openw,lun,myoutfile,/GET_LUN,/append
sclear
freexy
totscans=0
;;
;;Do each polarization separately to to check baselines
  myplnum=0
  filein,'data/AGBT10B_014_'+s1[jj]+'.raw.acs.fits'
  for ii=b1[jj],e1[jj] do begin 
   getps,ii,ifnum=0,plnum=myplnum
   accum
   getps,ii,ifnum=1,plnum=myplnum
   accum
  endfor
  totscans=e1[jj]-b1[jj]+1
  if (s2[jj] ne '00') then begin
    filein,'data/AGBT10B_014_'+s2[jj]+'.raw.acs.fits'
    for ii=b2[jj],e2[jj] do begin
      getps,ii,ifnum=0,plnum=myplnum
      accum
      getps,ii,ifnum=1,plnum=myplnum
      accum
    endfor
    totscans=totscans+e2[jj]-b2[jj]+1
  endif
  if (s3[jj] ne '00') then begin
    filein,'data/AGBT10B_014_'+s3[jj]+'.raw.acs.fits'
    for ii=b3[jj],e3[jj] do begin
      getps,ii,ifnum=0,plnum=myplnum
      accum
      getps,ii,ifnum=1,plnum=myplnum
      accum
  endfor
    totscans=totscans+e3[jj]-b3[jj]+1
  endif
  if (s4[jj] ne '00') then begin
    filein,'data/AGBT10B_014_'+s4[jj]+'.raw.acs.fits'
    for ii=b4[jj],e4[jj] do begin
      getps,ii,ifnum=0,plnum=myplnum
      accum
      getps,ii,ifnum=1,plnum=myplnum
      accum
  endfor
    totscans=totscans+e4[jj]-b4[jj]+1
  endif
  if (s5[jj] ne '00') then begin
    filein,'data/AGBT10B_014_'+s5[jj]+'.raw.acs.fits'
    for ii=b5[jj],e5[jj] do begin
      getps,ii,ifnum=0,plnum=myplnum
      accum
      getps,ii,ifnum=1,plnum=myplnum
      accum
  endfor
    totscans=totscans+e5[jj]-b5[jj]+1
  endif
  ave 
  copy,0,10
;;save polarization 0 in container 10
;;Do plnum=1
  myplnum=1
  filein,'data/AGBT10B_014_'+s1[jj]+'.raw.acs.fits'
  for ii=b1[jj],e1[jj] do begin
   getps,ii,ifnum=0,plnum=myplnum
   accum
   getps,ii,ifnum=1,plnum=myplnum
   accum
  endfor
  if (s2[jj] ne '00') then begin
    filein,'data/AGBT10B_014_'+s2[jj]+'.raw.acs.fits'
    for ii=b2[jj],e2[jj] do begin
      getps,ii,ifnum=0,plnum=myplnum
      accum
      getps,ii,ifnum=1,plnum=myplnum
      accum
    endfor
  endif
  if (s3[jj] ne '00') then begin
    filein,'data/AGBT10B_014_'+s3[jj]+'.raw.acs.fits'
    for ii=b3[jj],e3[jj] do begin
      getps,ii,ifnum=0,plnum=myplnum
      accum
      getps,ii,ifnum=1,plnum=myplnum
      accum
     endfor
  endif
  if (s4[jj] ne '00') then begin
    filein,'data/AGBT10B_014_'+s4[jj]+'.raw.acs.fits'
    for ii=b4[jj],e4[jj] do begin
      getps,ii,ifnum=0,plnum=myplnum
      accum
      getps,ii,ifnum=1,plnum=myplnum
      accum
    endfor
  endif
  if (s5[jj] ne '00') then begin
    filein,'data/AGBT10B_014_'+s5[jj]+'.raw.acs.fits'
    for ii=b5[jj],e5[jj] do begin
      getps,ii,ifnum=0,plnum=myplnum
      accum
      getps,ii,ifnum=1,plnum=myplnum
      accum
    endfor
  endif
  ave 
  copy,0,11
;;save polarization 1 in container 11
;; Save data for each polarization 
;; edit names for each sub-group
  fileout,OUTDIR+'/rawpol1.fits'
  copy,10,0
  nsave,nout1
  copy,11,0
  nsave,nout1+1
  nout1=nout1+2
;;combine polarizations and save
  copy,10,0
  accum
  copy,11,0
  accum
  ave
  fileout,OUTDIR+'/rawcombine1.fits'
  nsave,nout
  nout=nout+1
;;Output information
  vel=0.001*!g.s[0].source_velocity
  exp=!g.s[0].exposure
  source=!g.s[0].source
  fmt='(a15,f10.1,f10.2,i6)'
  printf,lun,format=fmt,source,vel,exp,totscans
  free_lun,lun
;endfor

close,/all

fileout,'junkout.fits'

return

end


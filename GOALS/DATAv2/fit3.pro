pro fit3
;;velocity in km/s
vel=0.001*!g.s[0].source_velocity
;;exposure in minutes (factor of 2 correction for dual polarization)
exp=!g.s[0].exposure/60./2.0
src=!g.s[0].source
print,src,vel,exp

;;baseline model in container 3 data in container-0
vec=getdata(3)
;;assumes data already smooothed and decimated
cont=median(vec[100:500])
print,'Continuum Level',cont
;velo
;copy,0,12  (baselined removed result from fit2)
;;continuum level needs to be removed first before gmeasure
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
xx=1
print,'If non-Gaussian emission hit 1, if Gaussian Emission source hit 2'
print,'If absorption hit 3 for gaussian abs fit, hit 4 for non-Gaus abs'
print,'or if nondetection hit 0'
read,xx
if (xx eq 1) then begin
 gmeasure,4,0.5,rms=out.rms,ret=o1
 gmeasure,4,0.2,rms=out.rms,ret=o2
 a1=o1[0]
 a2=o1[3]
 a3=o1[1]
 a4=o1[4]
 a5=o1[2]
 a6=o1[5]
 a7=o2[0]
 a8=o2[3]
 a9=o2[1]
 a10=o2[4]
 a11=o2[2]
 a12=o2[5]
endif
if (xx eq 4) then begin
;;absorption
;;flip scaling for fitting
 scale,-1.0
 gmeasure,4,0.5,rms=out.rms,ret=o1
 gmeasure,4,0.2,rms=out.rms,ret=o2
 a1=o1[0]
 a2=o1[3]
 a3=o1[1]
 a4=o1[4]
 a5=o1[2]
 a6=o1[5]
 a7=o2[0]
 a8=o2[3]
 a9=o2[1]
 a10=o2[4]
 a11=o2[2]
 a12=o2[5]
;;flip back after fitting
scale,-1.0
endif

if (xx eq 2) then begin
;;speed of light
c=2.99792458e5
frest=1420.4058
;;Gaussian 
;;output parameters in channels, argh..
  fitgauss,myfit,myrms
;;Single Gaussian Line flux = 1.06 * Peak * width
;;work in MHz
  dch=!g.s[0].frequency_interval/1.e6
  wfr=myfit(2)*dch
;;GBTIDL reference channel matches TOPO reference frequency 
  cfr=(myfit(1)-!g.s[0].reference_channel)*dch+ !g.s[0].reference_frequency/1.e6
;;in velocity frame (correct for doppler shift)
  fvel= -1.*!g.s[0].frame_velocity/1.e3
  fcfr= cfr - cfr*(fvel/c)
  vc=c*(frest-fcfr)/fcfr
  vw=c*wfr/fcfr
;;line fluxe
  a1=1.06*myfit(0)*vw
  a2=a1*((myrms(0)/myfit(0))^2.+(myrms(2)/myfit(2))^2.)^0.5
;;line width
  a3=vw
  a4=a3*(myrms(2)/myfit(2))
;;line center
  a5=vc
  a6=a5*(myrms(1)/myfit(1))
;;run gmeasure for 20% stats
gmeasure,4,0.2,rms=out.rms,ret=o2
 a7=o2[0]
 a8=o2[3]
 a9=o2[1]
 a10=o2[4]
 a11=o2[2]
 a12=o2[5]
endif
if (xx eq 3) then begin
;;Absorption Gaussian; do fitting to flipped spectrum for gmeasure
scale,-1.0
;;speed of light
c=2.99792458e5
frest=1420.4058
;;Gaussian 
;;output parameters in channels, argh..
  fitgauss,myfit,myrms
;;Single Gaussian Line flux = 1.06 * Peak * width
;;work in MHz
  dch=!g.s[0].frequency_interval/1.e6
  wfr=myfit(2)*dch
;;GBTIDL reference channel matches TOPO reference frequency 
  cfr=(myfit(1)-!g.s[0].reference_channel)*dch+ !g.s[0].reference_frequency/1.e6
;;in velocity frame (correct for doppler shift)
  fvel= -1.*!g.s[0].frame_velocity/1.e3
  fcfr= cfr - cfr*(fvel/c)
  vc=c*(frest-fcfr)/fcfr
  vw=c*wfr/fcfr
;;line fluxe
  a1=1.06*myfit(0)*vw
  a2=a1*((myrms(0)/myfit(0))^2.+(myrms(2)/myfit(2))^2.)^0.5
;;line width
  a3=vw
  a4=a3*(myrms(2)/myfit(2))
;;line center
  a5=vc
  a6=a5*(myrms(1)/myfit(1))
;;run gmeasure for 20% stats
gmeasure,4,0.2,rms=out.rms,ret=o2
 a7=o2[0]
 a8=o2[3]
 a9=o2[1]
 a10=o2[4]
 a11=o2[2]
 a12=o2[5]
;;flip back after fitting
scale,-1.0
endif
if (xx eq 0) then begin
 a1=0
 a2=0
 a3=0
 a4=0
 a5=0
 a6=0
 a7=0
 a8=0
 a9=0
 a10=0
 a11=0
 a12=0
 skms=0.0
 pk=0.0
 c1=0
 c2=0
endif

x=0
;;Save to output file
print,'Hit 1 to save'
read,x
if (x eq 1) then begin
  outfile='GOALS_output_measure.dat'
  openw,lun,outfile,/GET_LUN,/append
  fmt='(a12,i2,f8.1,f8.2,f6.2,f7.2,i4,i4,f7.3,f6.2,f6.2,f5.2,f7.1,f6.1,f8.1,f6.1,f6.2,f5.2,f7.1,f6.1,f8.1,f6.1)'
  printf,lun,format=fmt,src,xx,vel,exp,skms,pk,c1,c2,cont,rms1,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12
  free_lun,lun
;;Add back in continuum level after fitting
  bias,cont
;;Put on velocity scale
  velo
  write_ascii,'FINAL/'+src+'_v1.txt'
  fileout,'FINAL/GOALS_final_v1.fits'
;;output FITS file does not include continuum but Ascii does
  copy,12,0
  keep
  fileout,'junkout.fits'
endif

;;
return
end


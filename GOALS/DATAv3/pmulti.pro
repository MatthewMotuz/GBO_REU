pro pmulti

;!P.position=[0.1,0.1,0.95,0.95]
!P.Multi = [0,3,5]
!p.charsize=1.5
!p.charthick=1.0
!p.thick=1.0
!x.margin=[7,1]
!y.margin=[2,1]
;;work in mJy
readcol,'plotranges.dat',FORMAT='(a,f,f,f,f)',a1,x1,y1,x2,y2


j=0
;;page1
for i=0,29 do begin
  nam=a1[j]
  file1=nam+'_v1.txt'
  print,file1
  readcol,file1,v1,v2
  medy=median(v2)
  bb=where((v1 gt x1[j]) and (v1 lt x2[j]))
  setx,x1[j],x2[j]
;  ymin=min(v2[bb])
;  if (ymin gt 0) then 
;  ymax=max(v2[bb])
  sety,y1[j]+medy,y2[j]+medy
;;data ranges are based in data with median taken out, so add back in
;;ascii includes continuum, while saved keep.fits file has continuum
;;removed

  xr=x2[j]-x1[j]
  yr=y2[j]-y1[j]
  xlab=x1[j]+0.03*xr
  ylab=y2[j]+medy-0.1*yr

   
;;
  plot,v1[bb],v2[bb]
  xyouts,xlab,ylab,nam,size=0.8
;;
  j=j+1
;  oplot,v1[bb],v2[bb]
;  xyouts,xlab,ylab,nam,size=0.8
endfor

;!Y.OMargin = [0, 0]
;!X.OMargin = [0, 0]
!x.margin=[0,0]
!y.margin=[0,0]
!P.Multi = 0
;;default x y margins (10,3) (4,2)
return
end

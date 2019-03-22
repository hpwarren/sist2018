
pro plot_susim, ts=ts

  file = 'susim_v22_c01_l3bs_0031_5073.h5'
  nrl_restore_hdf, wavelength=wavelength, irradiance=irradiance, $
                   date_ccsds=date_ccsds, date_tai=date_tai, units=units, $
                   file=file

  ref_time = '12-FEB-2002 00:00'
  diff = min(abs(utc2tai(ref_time) - date_tai), pT)
  print, date_ccsds[pT]

  if keyword_set(ts) then begin
    diff = min(abs(wavelength-1215.67/10.),pW)
    flux = irradiance[pW,*]
    print, flux[pT]
    utplot, date_ccsds, flux, psym=1
    plots, anytim(date_ccsds[pT]) - getutbase(), !y.crange
    pause
  endif

  yr = [0.00001,10]*1000
  xr = [110, 400]

  plot, wavelength, 1000*irradiance[*,pT], /ylog, yrange=yr, xrange=xr, xstyle=1, $
        xtitle='Wavelength (nm)', ytitle='Irradiance (mW m!a-2!n s!a-1!n)', psym=10, $
        ytickformat='logticks_exp'
  
end

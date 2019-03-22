
pro convert_susim_hpw

  ;; a pro to restore susim mid res data in XDR files
  ;; day2 is MJD (modified julian date)
  ;; irrad2 is irradiance in W/m^3 (W/m^2-m)
  ;; scale by 1e-6 to convert to mW/cm^2-nm or scale by 1e-9 to convert to W/m^2-nm or ...

  str = 'SUSIM_V22_C01_L3BS_*.XDR'
  files = file_search(str,count=nFiles)
  print, files
  if nFiles eq 0 then return

  for i=0,nFiles-1 do begin

    restore,files[i]
    if i eq 0 then begin
      irrad2 = irrad
      wave2 = wave
      day2 = day
      param2 = param
      param_name2 = param_name
    endif else begin
      irrad2 = [irrad2,irrad]
      day2 = [day2,day]
      param2 = [param2,param]
    endelse

  endfor

  wave2 = double(wave2)
  irrad2 = double(irrad2*1.0E-9)
  irrad2 = transpose(irrad2)
  units = 'W/m^2/nm'
  param = double(param)

  ;; convert from UARS day to MJD
  ;; determine MJD of UARS day zero (9/11/91)
  day0 = date2mjd(1991,9,11)
  ;; convert UARS day to MJD
  day3 = day2 + day0
  ;; replace UARS day with MJD
  day2 = day3

  ;; more date conversions
  nDates = n_elements(day2) 
  date_ccsds = strarr(nDates)
  date_tai = dblarr(nDates)
  date_mjd = dblarr(nDates)
  for i=0,nDates-1 do begin
    d = MJD2STR(day2[i])
    date_ccsds[i] = anytim(d,/ccsds)
    date_tai[i] = utc2tai(date_ccsds[i])
    date_mjd[i] = day2[i]
  endfor

  ;; --- save outputs

  opf = 'susim_v22_c01_l3bs_0031_5073'

  ;; HDF5
  inputs = {time_stamp:  systime(0), input_files: files}
  nrl_save_hdf, wavelength=wave2, irradiance=irrad2, date_ccsds=date_ccsds, date_tai=date_tai, $
                date_mjd=date_mjd, param=param, units=units, inputs=inputs, file=opf+'.h5'
  print, ' + wrote HDF file' 

  ;; IDL SAVE
  wavelength = wave2
  irradiance = irrad2
  save, wavelength, irradiance, date_ccsds, date_tai, date_mjd, param, units, inputs, $
        file=opf+'.save'
  print, ' + wrote IDL save file'

return
end

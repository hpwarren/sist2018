
pro plot_susim_data

  file = 'susim_v22_c01_l3bs_0031_5073.h5'  
  
  nrl_restore_hdf, wavelength=wavelength, irradiance=irradiance, $
                   date_ccsds=date_ccsds, date_tai=date_tai, units=units, $
                   file=file

  range = [1.0E-5, 1.0E+3]
  scaled = eis_scale_image(irradiance, 'logarithmic', range)

  w = hpw_image_grid([1000, 1000], 1, margin_px=40)
  w.set_window

  pos = w.get_position(0)
  img = image(scaled, /current, aspect=0, position=pos)

  x0 = mean(pos[[0,2]])
  y0 = pos[1]*0.3
  t = text(x0, y0, 'Wavelength', /normal, alignment=0.5)

  y0 = mean(pos[[1,3]])
  x0 = pos[0]*0.6
  t = text(x0, y0, 'Time', /normal, alignment=0.5, orientation=90)

  x0 = mean(pos[[0,2]])
  y0 = 1 - pos[1]*0.6
  title = 'SUSMI Irradiances  ' + trim(min(wavelength),'(f10.1)')+'-'+$
          trim(max(wavelength),'(f10.1)')+' nm  '+$
          anytim2cal(date_ccsds[0], form=9, /date)+' - '+$
          anytim2cal(date_ccsds[-1], form=9, /date)
  t = text(x0, y0, title, /normal, alignment=0.5)

  img.save, 'plot_susim_data.jpg', resolution=100
  print, ' + wrote JPEG file'

end
bq mk \
--table \
--time_partitioning_field fecha_carga \
[PROJECT ID]:aemet.t_observacion_convencional \
fecha_carga:DATE,fecha_obs_UTC:TIMESTAMP,idema:STRING,nombre_estacion:STRING,geog_estacion:GEOGRAPHY,longitud:FLOAT,latitud:FLOAT,altitud:FLOAT,temperatura_suelo:FLOAT,temperatura_aire:FLOAT,temperatura_max_aire:FLOAT,humedad_rel:INTEGER,presion:FLOAT,precipitacion_pluvi:FLOAT,insolacion:FLOAT,visibilidad:FLOAT,stdvvu:FLOAT,vvu:FLOAT,dvu:INTEGER,vmaxu:FLOAT,psoltp:INTEGER,tss5cm:FLOAT,tss20cm:FLOAT,tpr:FLOAT,pacutp:FLOAT,rviento:INTEGER,pres_nmar:FLOAT,dmax:INTEGER,stdvv:FLOAT,stddvu:INTEGER,pliqt:FLOAT,stddv:INTEGER,tamin:FLOAT,dv:INTEGER,vv:FLOAT,vmax:FLOAT,nieve:FLOAT,dmaxu:INTEGER
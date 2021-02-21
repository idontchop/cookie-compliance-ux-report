SELECT origin, app, 
       MAX(IF(ms_bin = '200', density,0)) as b200,      
       MAX(IF(ms_bin = '600', density,0)) as b600,
       MAX(IF(ms_bin = '1000', density,0)) as b1000,
       MAX(IF(ms_bin = '1400', density,0)) as b1400,
       MAX(IF(ms_bin = '1800', density,0)) as b1800,
       MAX(IF(ms_bin = '2200', density,0)) as b2200,
       MAX(IF(ms_bin = '2700', density,0)) as b2700,
       MAX(IF(ms_bin = '3500', density,0)) as b3500,
       MAX(IF(ms_bin = '4500', density,0)) as b4500,
       MAX(IF(ms_bin = '5500', density,0)) as b5500,
       MAX(IF(ms_bin = '6500', density,0)) as b6500,
       MAX(IF(ms_bin = '7500', density,0)) as b7500,
       MAX(IF(ms_bin = '8500', density,0)) as b8500,
       MAX(IF(ms_bin = '9500', density,0)) as b9500,
       MAX(IF(ms_bin = '10500', density,0)) as b10500,
       MAX(IF(ms_bin = '11500', density,0)) as b11500,
       MAX(IF(ms_bin = '12500', density,0)) as b12500,
       MAX(IF(ms_bin = '13500', density,0)) as b13500,
       MAX(IF(ms_bin = '14500', density,0)) as b14500,
       MAX(IF(ms_bin = '15500', density,0)) as b15500,
       MAX(IF(ms_bin = '16500', density,0)) as b16500,
       MAX(IF(ms_bin = '17500', density,0)) as b17500,
       MAX(IF(ms_bin = '18500', density,0)) as b18500,
       MAX(IF(ms_bin = '19500', density,0)) as b19500,
       MAX(IF(ms_bin = '25000', density,0)) as b25000,
       MAX(IF(ms_bin = '35000', density,0)) as b35000,
       MAX(IF(ms_bin = '45000', density,0)) as b45000,
       MAX(IF(ms_bin = '55000', density,0)) as b55000,
       MAX(IF(ms_bin = '65000', density,0)) as b65000,
       MAX(IF(ms_bin = '75000', density,0)) as b75000,
       MAX(IF(ms_bin = '85000', density,0)) as b85000,
       MAX(IF(ms_bin = '95000', density,0)) as b95000,
       MAX(IF(ms_bin = '110000', density,0)) as b110000,
       MAX(IF(ms_bin = '130000', density,0)) as b130000       
FROM (
       SELECT origin,
           CASE
              WHEN onload.start < 400                THEN '200'
              WHEN onload.start BETWEEN 400 AND 799 THEN '600'
              WHEN onload.start BETWEEN 800 AND 1199 THEN '1000'
              WHEN onload.start BETWEEN 1200 AND 1599 THEN '1400'
              WHEN onload.start BETWEEN 1600 AND 1999 THEN '1800'
              WHEN onload.start BETWEEN 2000 AND 2399 THEN '2200'
              WHEN onload.start BETWEEN 2400 AND 2999 THEN '2700'
              WHEN onload.start BETWEEN 3000 AND 3999 THEN '3500'
              WHEN onload.start BETWEEN 4000 AND 4999 THEN '4500'
              WHEN onload.start BETWEEN 5000 AND 5999 THEN '5500'
              WHEN onload.start BETWEEN 6000 AND 6999 THEN '6500'
              WHEN onload.start BETWEEN 7000 AND 7999 THEN '7500'
              WHEN onload.start BETWEEN 8000 AND 8999 THEN '8500'
              WHEN onload.start BETWEEN 9000 AND 9999 THEN '9500'
              WHEN onload.start BETWEEN 10000 AND 10999 THEN '10500'
              WHEN onload.start BETWEEN 11000 AND 11999 THEN '11500'
              WHEN onload.start BETWEEN 12000 AND 12999 THEN '12500'
              WHEN onload.start BETWEEN 13000 AND 13999 THEN '13500'
              WHEN onload.start BETWEEN 14000 AND 14999 THEN '14500'
              WHEN onload.start BETWEEN 15000 AND 15999 THEN '15500'
              WHEN onload.start BETWEEN 16000 AND 16999 THEN '16500'
              WHEN onload.start BETWEEN 17000 AND 17999 THEN '17500'
              WHEN onload.start BETWEEN 18000 AND 18999 THEN '18500'
              WHEN onload.start BETWEEN 19000 AND 19999 THEN '19500'
              WHEN onload.start BETWEEN 20000 AND 29999 THEN '25000'
              WHEN onload.start BETWEEN 30000 AND 39999 THEN '35000'
              WHEN onload.start BETWEEN 40000 AND 49999 THEN '45000'
              WHEN onload.start BETWEEN 50000 AND 59999 THEN '55000'
              WHEN onload.start BETWEEN 60000 AND 69999 THEN '65000'
              WHEN onload.start BETWEEN 70000 AND 79999 THEN '75000'
              WHEN onload.start BETWEEN 80000 AND 89999 THEN '85000'
              WHEN onload.start BETWEEN 90000 AND 99999 THEN '95000'
              WHEN onload.start BETWEEN 100000 AND 119999 THEN '110000'
              ELSE '130000'
          END AS ms_bin,
          ROUND(SUM(onload.density),4) AS density
    FROM `chrome-ux-report.all.202010`,
      UNNEST(first_contentful_paint.histogram.bin) AS onload       
    where origin LIKE 'https://%'
    GROUP BY origin, ms_bin
    ) 
LEFT JOIN 
      (SELECT url, app from httparchive.technologies.2020_10_01_mobile
      WHERE category = 'Cookie compliance') as tech
   ON NET.HOST(url) = NET.HOST(origin) 
GROUP BY origin, app
ORDER BY origin
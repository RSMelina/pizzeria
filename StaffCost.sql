SELECT
r.date,
s.first_name,
s.last_name,
s.hourly_rate,
sh.start_time,
sh.end_time,
TIMESTAMPDIFF(MINUTE, sh.start_time,sh.end_time)/60 AS hours_in_shift,
TIMESTAMPDIFF(MINUTE, sh.start_time,sh.end_time)/60*s.hourly_rate AS staff_cost
FROM rota r 
LEFT JOIN staff s ON r.staff_id=s.staff_id
LEFT JOIN shift sh ON r.shift_id=sh.shift_id;
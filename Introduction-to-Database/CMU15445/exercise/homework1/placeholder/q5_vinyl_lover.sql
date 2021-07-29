select distinct release.name
from release
	inner join release_info on release.id=release_info.release
	inner join artist_credit on release.artist_credit=artist_credit.id
	inner join medium on release.id=medium.release
	inner join medium_format on medium.format = medium_format.id
	inner join artist_credit_name on artist_credit.id=artist_credit_name.artist_credit
where artist_credit_name.name = 'Coldplay'
	and medium_format.name like '%Vinyl'
order by date_year,
	date_month,
	date_day;

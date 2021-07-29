select area.name, 
	count(*) as c
	from artist
	inner join area on artist.area = area.id
	where begin_date_year < 1850
	group by artist.area
order by c desc
limit 10;
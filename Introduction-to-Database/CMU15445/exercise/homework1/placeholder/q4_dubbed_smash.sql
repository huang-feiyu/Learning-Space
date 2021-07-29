select artist.name, count(distinct artist_alias.name) as num
from artist 
	inner join artist_alias
	on artist.id = artist_alias.artist
where artist.begin_date_year > 1950
	and artist.area = 221
group by artist.id
order by num desc
limit 10;

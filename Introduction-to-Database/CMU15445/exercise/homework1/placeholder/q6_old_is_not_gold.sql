select decade, count(*) as num
from (
	select (CAST((date_year / 10) as int) * 10) || 's' as decade
	from release
		inner join release_info on release.id = release_info.release
	where date_year >= 1900
		and release.status=1
)
Group by decade
order by decade desc,
	num desc;
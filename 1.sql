
#Write   a   SQL   query   that   computes   the   amount   of   people   per   city
/*Choose to use left join instead of inner join so that during analysis analyst 
	can find out if there are people with missing city and state entries*/
select 
	coalesce(b.name,'Unknown') as city, 
	count(*) as no_of_people 
from 
	people a
left join 
	city_dim b
on 
	a.city_sk = b.city_sk
group by 
	b.name
order by 
	count(*) desc

# Write   a   SQL   query   that   computes   the   amount   of   people   from   a   state   with   is_in   True.
# Coalesce is used to make sure that the users without entries in state and city dim are also shown
select 
	coalesce(b.name,'Unknown') as city,
	coalesce(c.is_in,'Unknown') as is_in, 
	count(*) as no_of_people 
from 
	people a
left join 
	city_dim b
on 
	a.city_sk = b.city_sk
left join 
	state_dim c
on 
	c.state_sk = b.state_sk
where 
	c.is_in=True
group by 
	b.name,c.is_in
order by 
	count(*) desc

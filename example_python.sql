create extension if not exists plpython3u ;

create or replace function hello_python()
	returns setof text
as $$
	return('Hello','PostgreSQL','!')
$$ language plpython3u;



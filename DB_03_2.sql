use world;

-- 1. 도시명 kabul이 속한 국가의 이름은?

select Name from country
where code=( select countryCode from city
where name like 'kabul');

-- 2. 국가의 공식 언어 사용율이 100%인 국가의 정보를 출력하시오. 국가 이름으로 오름차순 정렬한다.(8건)


select name from country
where code in (
				select countrycode from countryLanguage
				where percentage=100.0 and IsOfficial =true
                )
order by name;

-- 3. 도시명 amsterdam에서 사용되는 주요 언어와 amsterdam이 속한 국가는?
select countrycode from city
where name like 'amsterdam';

select cl.language, c.name from country c , countrylanguage cl
where c.code=(
			select countrycode from city
			where name like 'amsterdam'
            ) and cl.countrycode= (
			select countrycode from city
			where name like 'amsterdam' and isOfficial=true
            );
            
-- 4. 국가명이 united로 시작하는 국가의 정보와 수도의 이름, 인구를 함께 출력하시오. 단 수도 정보가 없다면 출력하지 않는다. (3건)
select c.name, c.capital, city.name as "수도", city.population as "수도인구"
from country c inner join city on c.capital=city.id
where c.name like 'united%' and c.capital is not null;

-- 5. 국가명이 united로 시작하는 국가의 정보와 수도의 이름, 인구를 함께 출력하시오. 단 수도 정보가 없다면 수도 없음이라고 출력한다. (4건)
select c.name, c.capital, ifnull(city.name,"수도없음") as "수도", ifnull(city.population,"수도없음") as "수도인구"
from country c left outer join city on c.capital=city.id
where c.name like 'united%' ;

-- 6. 국가 코드 che의 공식 언어 중 가장 사용률이 높은 언어보다 사용율이 높은 공식언어를 사용하는 국가는 몇 곳인가? 63.6보다 높은 공식언어
select count(*) as "국가수" from countrylanguage 
where isOfficial =true and percentage > (select max(percentage) from countrylanguage where countrycode like 'che');

-- 7. 국가명 south korea의 공식 언어는?
select *
from countrylanguage;

select language
from countrylanguage
where countrycode = (select code from country where Name like 'south korea') and IsOfficial like 'T';

-- 8. 국가 이름이 bo로 시작하는 국가에 속한 도시의 개수를 출력하시오. (3건)
select *
from country
where name like 'bo%';

select country.Name, country.code, count(city.countryCode) as '도시개수'
from city left outer join country on city.CountryCode= Country.code
where country.name like 'bo%'
group by city.countryCode;

select c1.name, c1.code, (select count(*) from city c2 where c2.countrycode=c1.code)
from country c1
where c1.name like "bo%" and c1.capital is not null;


-- 9. 국가 이름이 bo로 시작하는 국가에 속한 도시의 개수를 출력하시오. 도시가 없을 경우는 단독 이라고 표시한다.(4건)
select *
from city
where CountryCode like 'BVT';


select country.Name, country.code, case when count(city.countryCode) =0
										then '단독'
										else count(city.countryCode)
										end as '도시개수'
from city right outer join country on city.CountryCode= Country.code
where country.name like 'bo%'
group by city.countryCode;

select c1.name, c1.code, if((select count(*) from city c2 where c2.countrycode=c1.code)=0, '단독', (select count(*) from city c2 where c2.countrycode=c1.code)) 도시개수
from country c1
where c1.name like "bo%";

-- 10. 인구가 가장 많은 도시는 어디인가?
select CountryCode, name, Population
from city
order by Population desc
limit 1;

-- 11. 가장 인구가 적은 도시의 이름, 인구수, 국가를 출력하시오.
select country.name, city.countrycode,city.name, city.Population
from city inner join country on city.CountryCode=country.Code
order by Population
limit 1;

-- 12. KOR의 seoul보다 인구가 많은 도시들을 출력하시오.
select CountryCode,name,Population
from city
where Population >=(select Population from city where CountryCode like 'Kor' and Name like 'seoul') and Name not like 'seoul';

-- 13. San Miguel 이라는 도시에 사는 사람들이 사용하는 공식 언어는?
select distinct (cl.countrycode), cl.language 
from countrylanguage cl inner join city 
on cl.countrycode = city.countrycode
where cl.isofficial=true and cl.countrycode in(
												select countrycode from city
												where name ='San Miguel'
												)
order by countrycode;

-- 14. 국가 코드와 해당 국가의 최대 인구수를 출력하시오. 국가 코드로 정렬한다.(232건)

select countrycode, max(city.population)
from city inner join country on city.countrycode = country.code
group by city.countrycode
order by countrycode;

-- 15. 국가별로 가장 인구가 많은 도시의 정보를 출력하시오. 국가 코드로 정렬한다.(232건)
select city.countrycode, city.name, max(city.population)
from city inner join country on city.countrycode = country.code
group by city.countrycode
order by countrycode;

-- 16. 국가 이름과 함께 국가별로 가장 인구가 많은 도시의 정보를 출력하시오.(239건)
select c1.code, c1.name, c2.name, max(c2.population)
from country c1, city c2
where c1.code = c2.countrycode
group by c2.countrycode
union
select code, name, capital, population
from country
where capital is null;


select countrycode code, (select name from country where code=c1.countrycode) name, name, population
from city c1
where c1.population >= all(
                     select population
                     from city
                     where countrycode = c1.countrycode
                            )
order by countrycode;

-- 17. 위 쿼리의 내용이 자주 사용된다. 재사용을 위해 위 쿼리의 내용을 summary라는 이름의 view로 생성하시오.
create view summary as
select c1.code as code, c1.name as co_name, c2.name as ci_name, max(c2.population) as population
from country c1, city c2
where c1.code = c2.countrycode
group by c2.countrycode
union
select code , name as co_name, capital as co_capital, population as co_population
from country
where capital is null;

-- 18. summary에서 KOR의 대표도시를 조회하시오.
select code, co_name, ci_name, population
from summary
where code like 'KOR';
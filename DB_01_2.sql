-- 1. world 데이터베이스를 사용하도록 설정하시오.
use world;

-- 2. city, country, countrylanguage 테이블의 구조를 파악하시오.
select *
from city;

select *
from country;

select *
from countrylanguage;

-- 3. country table에서 code가 KOR인 자료를 조회하시오.
select *
from country
where code like 'KOR';

-- 4. country에서 gnp변동량(gnp-gnpold)이 양수인 국가에 대해 gnp변동량의 오름차순으로 정렬하시오.(115건)
select *
from country
where gnp-gnpold>0
order by gnp-gnpold;

-- 5. country table에서 continent를 중복 없이 조회하시오. continent의 길이로 정렬한다. (7건)
select distinct(continent)
from country
order by length(continent);

-- 6. country에서 asia 대륙에 속하는 국가들의 정보를 아래와 같이 출력하시오. name으로 정렬한다.(51건)
select concat(name,'은 ',region,'에 속하며 인구는 ',population,'명이다.') as "정보"
from country
where continent like 'Asia'
order by name;

-- 7. country에서 독립 년도에 대한 기록이 없고 인구가 10000이상인 국가의 정보를 인구의 오름차순으로 출력하시오.(29건)
select name, continent, gnp, population
from country
where indepYear is null and population>=10000
order by population;

-- 8. country에서 인구가 1억<=x<=2억 인 나라를 인구 기준으로 내림차순 정렬해서 상위 3개만 출력하시오.
select code, name ,population
from country
where population>=100000000 and population<=200000000
order by population desc
limit 3;

-- 9. country에서 800, 1810, 1811, 1901, 1901에 독립한 나라를 독립년 기준으로 오름차순 출력하시오. 단 독립 년이 같다면 code를 기준으로 내림차순 한다.(7건)
select code , name , indepyear
from country
where indepyear in(800,1810,1811,1901)
order by indepyear;

-- 10. country에서 region에 asia가 들어가고 name의 두 번째 글자가 ‘o’인 정보를 출력하시오.(4건)
select code,name, region
from country
where region like '%asia%' and name like '_o%';

-- 11. '홍길동'과 'hong'의 글자 길이를 각각 출력하시오.
select char_length('홍길동')as "한글", length('hong') as "영문";
-- from dual;

-- 12. country에서 governmentform에 republic이 들어있고 name의 길이가 10 이상인 자료를 name 길이의 내림차순으로 상위 10개만 출력하시오. (10건)
select code,name, governmentform
from country
where governmentform like '%republic%' and length(name)>=10
order by length(name) desc
limit 10;

-- 13. country에서 code가 모음으로 시작하는 나라의 정보를 출력하시오. 이때 name의 오름차순으로 정렬하고 3번 부터 3개만 출력한다.
select code,name
from country
where code like 'a%' or code like 'e%' or code like 'i%' or code like 'o%' or code like 'u%'
order by name 
limit 2,3;

-- 14. country에서 name을 맨 앞과 맨 뒤에 2글자를 제외하고 나머지는 *로 처리해서 출력하시오.(239건)
select name, concat(left(name, 2),'*'*length(name-4),right(name,2)) as 'guess'
from country;

savepoint s1;

-- 15. country에서 region을 중복 없이 가져오는데 공백을 _로 대체하시오. region의 길이로 정렬한다.(25건)
select distinct(replace(region,' ','_')) as "지역들"
from country
order by length(region) desc;

-- 16. country에서 인구가 1억 이상인 국가들의 1인당 점유면적(surfacearea/population)을 반올림해서 소숫점 3자리로 표현하시오. 1인당 점유 면적의 오름차순으로 정렬한다.(10건)
select name, surfacearea,population , round((surfacearea/population),3) as "1인당 점유면적"
from country
where population >=100000000
order by round((surfacearea/population),3);

-- 17. 현재 날짜와 올해가 몇 일이 지났는지,100일 후는 몇일인지 출력하시오.(아래는 2020년 기준 예시)
select curdate() as "오늘",  datediff(now(), '2021-01-01')+1 "올해 지난날",date_format(date_add(now(),interval 100 day),'%Y-%m-%d') as "100일 후"
from dual;

-- 18. country에서 asia에 있는 나라 중 희망 수명이 있는 경우에 기대 수명이 80 초과면 장수국가, 60 초과면 일반국가, 그렇지 않으면 단명국가라고 표현하시오. 기대 수명으로 정렬한다.(51건)
select name, continent, lifeexpectancy,case 
										when lifeexpectancy>80 then '장수국가'
										when lifeexpectancy>60 then '일반국가'
										else '단명국가'
									end as '구분'
from country
where continent like 'asia'
order by lifeexpectancy;

-- 19. country에서 (gnp-gnpold)를 gnp 향상이라고 표현하시오. 단 gnpold가 없는 경우 신규라고 출력하고 name으로 정렬한다.(239건)
select name, gnp,gnpold, ifnull((gnp-gnpold),'신규') as "gnp 향상"
from country
order by name;

-- 20. 2020년 어린이 날이 평일이면 행복, 토요일 또는 일요일이면 불행이라고 출력하시오.
select weekday('2020-05-05'), case
								when weekday('2020-05-05')>=1 and weekday('2020-05-05')<=5 then '행복'
								else '불행' 
							end as "행복여부"
select @@autocommit;
set autocommit=false;

-- 1. country에서 전체 자료의 수와 독립 연도가 있는 자료의 수를 각각 출력하시오.
select count(*), count(IndepYear) as "독립 연도 보유"
from country;

-- 2. country에서 기대 수명의 합계, 평균, 최대, 최소를 출력하시오. 평균은 소수점 2자리로 반올림한다
select sum(lifeexpectancy) as "합계", round(avg(lifeexpectancy),2) as "평균",max(lifeexpectancy) as "최대",min(lifeexpectancy) as "최소"
from country;

-- 3. country에서 continent 별 국가의 개수와 인구의 합을 구하시오. 국가 수로 정렬 처리한다.(7건)
select continent, count(name) as "국가수", sum(Population) as "인구 합"
from country
group by continent
order by count(name) desc;

-- 4. country에서 대륙별 국가 표면적의 합을 구하시오. 면적의 합으로 내림차순 정렬하고 상위 3건만 출력한다.
select continent, sum(SurfaceArea) as "표면적 합"
from country
group by continent
order by sum(SurfaceArea) desc
limit 3;

-- 5. country에서 대륙별로 인구가 50,000,000이상인 나라의 gnp 총 합을 구하시오. 합으로 오름차순 정렬한다.(5건)
select Continent, sum(gnp) as "gnp 합"
from country
where Population>= 50000000
group by Continent
order by sum(gnp);

-- 6. country에서 대륙별로 인구가 50,000,000이상인 나라의 gnp 총 합을 구하시오. 이때 gnp의 합이 5,000,000 이상인 것만 구하시오.
select Continent, sum(gnp) as "gnp 합"
from country
where Population>= 50000000
group by Continent
having sum(gnp)>=5000000
order by sum(gnp);

-- 7. country에서 연도별로 10개 이상의 나라가 독립한 해는 언제인가?
select IndepYear, count(name) as "독립 국가 수"
from country
group by IndepYear
having count(name)>=10 and IndepYear is not null;

-- 8. country에서 국가별로 gnp와 함께 전세계 평균 gnp, 대륙 평균 gnp를 출력하시오.(239건) ->> 다시해보기 ,혼자힘으로
select Continent,name, gnp, (select avg(gnp) from country ) as"전세계 평균", 
	(select avg(gnp) from country where Continent= c.Continent) as "대륙평균"
from country c
order by Continent;

savepoint s1;
-- 9. countrylanguage에 countrycode='AAA', language='외계어', isOfficial='F', percentage=10을 추가하시오.
-- 값을 추가할 수 없는 이유를 생각하고 필요한 부분을 수정해서 다시 추가하시오.  ->> 다시해보기 ,혼자힘으로
insert into country(code ,name) values ('AAA', 'ETcountry');
insert into countrylanguage values('AAA','외계어','F',10);
select * 
from countrylanguage;

savepoint s2;
-- 10. countrylanguage에 countrycode='ABW', language='Dutch', isOfficial='F', percentage=10을 추가하시오. 
-- # 값을 추가할 수 없는 이유를 생각하고 필요한 부분을 수정해서 다시 추가하시오.  ->> 다시해보기 ,혼자힘으로

-- >> countrycode와 language는 countrylanguage 테이블의 기본키이므로 유일성을 충족해야한다.
#     하지만 이미 countrycode=ABW, language=Dutch 인 데이터가 존재하므로
#     값을 새로 추가하는 것이 아닌 기존 값 데이터를 수정하는 방식으로 변경해야함.
update countrylanguage
set isofficial = 'F', percentage='10'
where countrycode='ABW' and language='Dutch';

select *
from countrylanguage;

-- 11. country에 다음 자료를 추가하시오. 
# Code='TCode', Region='TRegion',Code2='TC' # 값을 추가할 수 없는 이유를 생각하고 필요한 부분을 수정해서 다시 추가하시오. ->> 다시해보기 ,혼자힘으로
savepoint s3;
insert into country(code, name, region,code2) values('Tco','Tname','TRegion','TC');
select *
from country;

-- 12. city에서 id가 2331인 자료의 인구를 10% 증가시킨 후 조회하시오.

savepoint s4;
update city set population =population*1.1
where id =2331;
select *
from city
where id=2331;

-- 13. country에서 code가 'USA'인 자료를 삭제하시오.
 # 삭제가 안되는 이유를 생각하고 성공하려면 어떤 절차가 필요한지 생각만 하시오.
 savepoint s5;
 -- country 테이블의 code를 외래키이자 기본키로 삼는 countrylanguage 테이블이 존재하기 때문.
-- 따라서 해당 쿼리를 수행하려면, countrylanguage에서 code = 'USA'인 자료 인스턴스를 먼저 지우는 절차를 선행해야 함.

-- 14. 이제 까지의 DML 작업을 모두 되돌리기 위해 rollback 처리하시오.
rollback;
select * from countrylanguage;

-- 15. ssafy_ws_5th라는 이름으로 새로운 schema를 생성하시오.
create schema ssafy_ws_5th;
use ssafy_ws_5th;
savepoint s6;
-- 16. 만약 user라는 테이블이 존재한다면 삭제하시오.
drop table if exists user CASCADE; 

-- 17. ssafy_ws_5th에 다음 조건을 만족하는 테이블을 생성하시오.
savepoint s7;
create table user(
	id varchar(50) not null primary key,
    name varchar(100) not null default '익명',
    pass varchar(100) not null
    );
    
savepoint s8;
insert into user values('ssafy','김싸피','1234');
insert into user values('hong','홍싸피','5678');
insert into user values('test','테스트','test');

-- 19. id가 test인 계정의 pass를 id@pass 형태로 변경하고 조회하시오.

savepoint s9;
update user set pass=concat(id,'@',pass)
where id like 'test';

select *
from user;

rollback to s9;

-- 20. id가 test인 계정의 자료를 삭제하고 조회하시오.

delete from user 
where id like 'test';

select *
from user;

-- 21. 현재까지의 내용을 영구 저장하기 위해서 commit 처리하시오.
commit;
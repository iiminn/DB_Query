DROP DATABASE IF EXISTS hw01;

CREATE DATABASE hw01;

USE hw01;

-- 1. 상품정보를 저장할 수 있는 테이블을 구성하여 보자 (상품코드 , 상품명 , 상품가격 등)
CREATE TABLE Product
(
pcode int(4) PRIMARY KEY,
pname VARCHAR(10),
price int(10)
);

-- 2. 상품 데이터를 5 개 이상 저장하는 SQL 을 작성하여 보자 (상품명에 TV, 노트북 포함 하도록 하여 5 개 이상)
INSERT INTO `Product` VALUES (001, 'TV', 2000000),(002,'라디오', 120000),(003, '냉장고', 5000000), (004, '노트북', 1000000), (005, '컴퓨터', 800000), (006, '스피커', 1000000);

-- 3. 상품을 세일하려고 한다 . 15% 인하된 가격의 상품 정보를 출력하세요
select pcode as 상품코드, pname as 상품명, round(price*0.85, 0) as 가격
from Product;

-- 4. TV 관련 상품을 가격을 20% 인하하여 저장하세요 . 그 결과를 출력하세요
update Product
SET price = price*0.8
where pname like "%TV%";

select *
from Product
where pname like "%TV%";

-- 5. 저장된 상품 가격의 총 금액을 출력하는 SQL 문장을 작성하세요
select sum(price) as "상품 가격의 총 금액"
from Product;

-- Nivel 1 Exercici 2 Join

-- Listado de los países que están realizando compras.
select distinct c.country
from transaction t
inner join company c on t.company_id = c.id
where declined = 0;

-- Desde cuántos países se realizan las compras.
select count(distinct c.country)
from transaction t
inner join company c on t.company_id = c.id
where declined = 0;

-- Identifica a la compañía con la mayor media de ventas.
select c.company_name
from transaction t
inner join company c on t.company_id = c.id
where declined = 0
group by t.company_id
order by avg(t.amount) desc
limit 1;

-- Nivel 1 Exercici 3 subconsultas

-- Muestra todas las transacciones realizadas por empresas de Alemania.
select *, (select country from company where id = company_id) as country
from transaction
where company_id in (
		select id
        from company
        where country = 'Germany');

-- Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
select company_name
from company
where id in (
		select company_id
        from transaction
        where amount > (
					select avg(amount) 
					from transaction
					)
			);
            
-- Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
select company_name
from company
where id not in 
	(select company_id from transaction
    );

-- Nivel 2 Exercici 1

-- Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
-- Muestra la fecha de cada transacción junto con el total de las ventas.

select date(timestamp) as transaction_date, sum(amount) as total_sales
from transaction
where declined = 0
group by transaction_date
order by total_sales desc
limit 5;

-- Nivel 2 Exercici 2

-- ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.
select country, round(avg(t.amount),2) as avg_sales
from company c
inner join transaction t on t.company_id = c.id
where t.declined = 0
group by country
order by avg_sales desc;

-- Nivel 2 Exercici 3

-- En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia
-- a la compañía “Non Institute”. Para ello, te piden la lista de todas las transacciones realizadas por empresas
-- que están ubicadas en el mismo país que esta compañía.

-- Muestra el listado aplicando JOIN y subconsultas.
select *
from transaction t
inner join company c on t.company_id = c.id
where c.country = (
	select country from company
	where company_name = 'Non Institute'
    )
    and c.company_name <> 'Non Institute';
    
-- Muestra el listado aplicando solo subconsultas. 
select *, (select country from company where id = company_id) as country
from transaction
where company_id in (
	select id from company
    where country = (
		select country from company
		where company_name = 'Non Institute'
		)  and company_name <> 'Non Institute'
	);
    
-- Nivel 3 Exercici 1

-- Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones
-- con un valor comprendido entre 100 y 200 euros y en alguna de estas fechas: 29 de abril de 2021,
-- 20 de julio de 2021 y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.

select c.company_name, c.phone, c.country, t.timestamp, t.amount
from company c
inner join transaction t on c.id = t.company_id
where (amount between 100 and 200) and
( date(timestamp) = '2021-04-29' 
or date(timestamp) = '2021-07-20' 
or date(timestamp) = '2022-03-13')
order by amount desc;

-- Nivel 3 Exercici 2

-- Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, 
-- por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, pero el 
-- departamento de recursos humanos es exigente y quiere un listado de las empresas donde especifiques si tienen 
-- más de 4 o menos transacciones.

select 
c.company_name, 
if(count(*) > 4,'más de 4','menos de 4') as range_transactions, 
count(*) as amount
from company c
inner join transaction t on c.id = t.company_id
group by c.company_name
order by amount desc;

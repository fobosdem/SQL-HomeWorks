--(1) сортировка в обратном пор€дке, по количеству людей в отделе
SELECT d.Name, (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id) AS [Employees in departments]
FROM Department d
ORDER BY [Employees in departments] DESC;

--(2)¬ывести список сотрудников, получающих заработную плату большую чем у непосредственного руководител€
SELECT emp.ChiefId, emp.Name, emp.Salary, Chief.Id AS [Chief ID], Chief.Name AS [Chief Name], Chief.Salary AS [Chief Salary]
FROM Employee emp
join Employee Chief on Chief.Id = emp.ChiefId
WHERE emp.Salary > Chief.Salary;

--(3)¬ывести список отделов, количество сотрудников в которых не превышает 3 человек
SELECT d.Name
FROM Department d
WHERE(SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id) < 3;

--(4)¬ывести список сотрудников, получающих максимальную заработную плату в своем отделе
SELECT dp.Name, empl.Name, empl.Salary
FROM Department dp
join Employee empl on empl.DepartmentId = dp.Id
WHERE empl.Salary = (SELECT MAX(emp.Salary) FROM Employee emp WHERE emp.DepartmentId = dp.Id);

--(5)Ќайти список отделов с максимальной суммарной зарплатой сотрудников
SELECT TOP 1 dp.Name, (SELECT SUM(emp.Salary) FROM Employee emp WHERE emp.DepartmentId = dp.Id) AS Sal
FROM Department dp
ORDER BY Sal DESC;

--(6)¬ывести список сотрудников, не имеющих назначенного руководител€, работающего в том-же отделе
SELECT emp.ChiefId, emp.Name, emp.DepartmentId AS [Departm Id of empl]
FROM Employee emp
WHERE emp.ChiefId IS NULL OR emp.DepartmentId != (SELECT chief.DepartmentId FROM Employee chief WHERE chief.Id = emp.ChiefId);


--(7)SQL-запрос, чтобы найти вторую самую высокую зарплату работника
SELECT MAX(emp.Salary) AS SAL
FROM Employee emp
WHERE emp.Salary < ( SELECT MAX(Salary) FROM Employee );
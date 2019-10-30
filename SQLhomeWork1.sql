USE HumanResources
go

--(1) ���������� � �������� �������, �� ���������� ����� � ������
SELECT d.Name, (SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id) AS [Employees in departments]
FROM Department d
ORDER BY [Employees in departments] DESC;

--(2)������� ������ �����������, ���������� ���������� ����� ������� ��� � ����������������� ������������
SELECT emp.ChiefId, emp.Name, emp.Salary, Chief.Id AS [Chief ID], Chief.Name AS [Chief Name], Chief.Salary AS [Chief Salary]
FROM Employee emp
join Employee Chief on Chief.Id = emp.ChiefId
WHERE emp.Salary > Chief.Salary;

--(3)������� ������ �������, ���������� ����������� � ������� �� ��������� 3 �������
SELECT d.Name
FROM Department d
WHERE(SELECT COUNT(1) FROM Employee WHERE DepartmentId = d.Id) < 3;

--(4)������� ������ �����������, ���������� ������������ ���������� ����� � ����� ������
SELECT dp.Name, empl.Name, empl.Salary
FROM Department dp
join Employee empl on empl.DepartmentId = dp.Id
WHERE empl.Salary = (SELECT MAX(emp.Salary) FROM Employee emp WHERE emp.DepartmentId = dp.Id);

--(5)����� ������ ������� � ������������ ��������� ��������� �����������
SELECT d.Name, SUM(e.Salary) AS SalaryOfDep -- ��� ������������ � ������� �������� �� ����
FROM Employee e
LEFT JOIN Department d ON d.Id = e.DepartmentId
GROUP BY d.Name
HAVING SUM(e.Salary) = (SELECT MAX(SalTabl.maxsal) AS hight
			FROM (SELECT SUM(em.Salary) AS maxsal
				FROM Employee em
				GROUP BY em.DepartmentId) SalTabl);

--HAVING SUM(em.Salary) = ALL (SELECT SUM(e.Salary) FROM Employee e GROUP BY e.DepartmentId);

--(6)������� ������ �����������, �� ������� ������������ ������������, ����������� � ���-�� ������
SELECT emp.ChiefId, emp.Name, emp.DepartmentId AS [Departm Id of empl], chief.Name AS [Chief Name], chief.DepartmentId
FROM Employee emp
LEFT JOIN Employee chief ON chief.Id = emp.ChiefId
WHERE emp.ChiefId IS NULL OR emp.DepartmentId != chief.DepartmentId;


--(7)SQL-������, ����� ����� ������ ����� ������� �������� ���������
SELECT MAX(emp.Salary) AS SAL
FROM Employee emp
WHERE emp.Salary < ( SELECT MAX(Salary) FROM Employee );
-- step 1
SELECT 
    л.ИД, 
    с.ДАТА 
FROM Н_ЛЮДИ AS л
INNER JOIN Н_СЕССИЯ AS с 
    ON л.ИД = с.ЧЛВК_ИД
WHERE 
    л.ИМЯ > 'Николай' AND 
    с.УЧГОД = '2011/2012';

-- step 2
SELECT 
    л.ФАМИЛИЯ, 
    в.ДАТА,
    с.ДАТА
FROM Н_ЛЮДИ AS л
INNER JOIN Н_СЕССИЯ AS с 
    ON л.ИД = с.ЧЛВК_ИД
INNER JOIN Н_ВЕДОМОСТИ AS в
    ON в.ИД = л.ИД
WHERE 
    л.ИД > 100865 AND 
    в.ИД < 1250972 AND
    с.ДАТА < '2012-01-25';

-- step 3
SELECT 
    count(*) 
FROM 
    (SELECT 
        ФАМИЛИЯ, 
        ИМЯ,
        count(ИМЯ) 
    FROM Н_ЛЮДИ 
    GROUP BY ФАМИЛИЯ, ИМЯ) aboba;

-- step 4
SELECT 
    * 
FROM 
    (SELECT
        л.ОТЧЕСТВО,
        count(л.ОТЧЕСТВО)
    FROM 
        Н_УЧЕНИКИ AS у
    INNER JOIN 
        Н_ПЛАНЫ AS п
    ON у.ПЛАН_ИД = п.ИД
    INNER JOIN 
        Н_ЛЮДИ AS л
    ON у.ЧЛВК_ИД = л.ИД
    WHERE п.ФО_ИД = 1
    GROUP BY л.ОТЧЕСТВО) aboba
WHERE count > 50;

-- step 5
SELECT DISTINCT
    ФАМИЛИЯ,
    ИМЯ,
    ОТЧЕСТВО,
    AVG(ОЦЕНКА) OVER (PARTITION BY ЧЛВК_ИД) AS ОЦЕНКА
FROM 
    (SELECT 
        у.ЧЛВК_ИД,
        л.ФАМИЛИЯ,
        л.ИМЯ,
        л.ОТЧЕСТВО,
        NULLIF(в.ОЦЕНКА, '')::float4 AS ОЦЕНКА
    FROM Н_УЧЕНИКИ AS у
    INNER JOIN Н_ВЕДОМОСТИ AS в
        ON в.ЧЛВК_ИД = у.ЧЛВК_ИД
    INNER JOIN Н_ЛЮДИ AS л
        ON л.ИД = в.ЧЛВК_ИД
    WHERE у.ГРУППА = '4100'
        AND в.ОЦЕНКА != 'зачет'
        AND в.ОЦЕНКА != 'незач'
        AND в.ОЦЕНКА != 'неявка'
        AND в.ОЦЕНКА != 'осв'
        AND в.ОЦЕНКА != '99'
    ) aboba
WHERE ОЦЕНКА >= (SELECT MIN(ОЦЕНКА) AS МИН_ОЦЕНКА 
    FROM
        (SELECT 
            у.ЧЛВК_ИД,
            NULLIF(в.ОЦЕНКА, '')::INT AS ОЦЕНКА
        FROM Н_УЧЕНИКИ AS у
        INNER JOIN Н_ВЕДОМОСТИ AS в
            ON в.ЧЛВК_ИД = у.ЧЛВК_ИД
        WHERE у.ГРУППА = '3100'
            AND в.ОЦЕНКА != 'зачет'
            AND в.ОЦЕНКА != 'незач'
            AND в.ОЦЕНКА != 'неявка'
            AND в.ОЦЕНКА != 'осв'
            AND в.ОЦЕНКА != '99') t);

-- step 6
SELECT 
    ГРУППА,
    subq.ИД,
    ФАМИЛИЯ,
    ИМЯ,
    ОТЧЕСТВО,
    П_ПРКОК_ИД,
    КОНЕЦ
FROM 
    (SELECT 
        Н_УЧЕНИКИ.ЧЛВК_ИД,
        Н_УЧЕНИКИ.ГРУППА,
        Н_УЧЕНИКИ.ИД,
        Н_УЧЕНИКИ.П_ПРКОК_ИД,
        Н_УЧЕНИКИ.КОНЕЦ,
        Н_ПЛАНЫ.ФО_ИД,
        Н_УЧЕНИКИ.ПРИЗНАК,
        Н_УЧЕНИКИ.СОСТОЯНИЕ
    FROM Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ
    INNER JOIN Н_НАПР_СПЕЦ
        ON Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ.НС_ИД = Н_НАПР_СПЕЦ.ИД
    INNER JOIN Н_ПЛАНЫ 
        ON Н_ПЛАНЫ.НАПС_ИД = Н_НАПРАВЛЕНИЯ_СПЕЦИАЛ.ИД
    INNER JOIN Н_УЧЕНИКИ 
        ON Н_УЧЕНИКИ.ПЛАН_ИД = Н_ПЛАНЫ.ИД
    WHERE Н_НАПР_СПЕЦ.КОД_НАПРСПЕЦ = '230101') subq

    INNER JOIN Н_ЛЮДИ
        ON Н_ЛЮДИ.ИД = subq.ЧЛВК_ИД
    INNER JOIN Н_ФОРМЫ_ОБУЧЕНИЯ
        ON subq.ФО_ИД = Н_ФОРМЫ_ОБУЧЕНИЯ.ИД

WHERE EXISTS (
    SELECT 1 FROM Н_ФОРМЫ_ОБУЧЕНИЯ
    WHERE НАИМЕНОВАНИЕ = 'Заочная' OR 
        НАИМЕНОВАНИЕ = 'Очная')
AND
 subq.ИД in 
    (SELECT subq.ИД FROM Н_УЧЕНИКИ AS у
    WHERE subq.ПРИЗНАК = 'отчисл'
    AND subq.СОСТОЯНИЕ = 'утвержден'
    AND DATE(у.КОНЕЦ) > '2012-09-01'
    );

-- step 7
SELECT 
    -- COUNT(*),
    -- ЧЛВК_ИД, 
    ФАМИЛИЯ,
    ИМЯ,
    ОТЧЕСТВО
FROM 
    (SELECT 
        у.ЧЛВК_ИД,  
        л.ФАМИЛИЯ,
        л.ИМЯ,
        л.ОТЧЕСТВО
        -- , COUNT(*)
    FROM Н_УЧЕНИКИ AS у
    INNER JOIN Н_ЛЮДИ AS л
        ON л.ИД = у.ЧЛВК_ИД
    GROUP BY 
        у.ЧЛВК_ИД, 
        л.ФАМИЛИЯ,
        л.ИМЯ,
        л.ОТЧЕСТВО
    HAVING COUNT(*) >= 2
    ORDER BY л.ФАМИЛИЯ ASC) t
GROUP BY 
    ФАМИЛИЯ,
    ИМЯ,
    ОТЧЕСТВО
HAVING COUNT(*) > 1;


-- step 8
SELECT 
    *
FROM Н_УЧЕНИКИ
JOIN Н_ПЛАНЫ 
    ON Н_ПЛАНЫ.ПЛАН_ИД = Н_УЧЕНИКИ.ПЛАН_ИД
JOIN Н_ОТДЕЛЫ 
    ON Н_ОТДЕЛЫ.ИД = Н_ПЛАНЫ.ОТД_ИД
WHERE Н_ОТДЕЛЫ.КОРОТКОЕ_ИМЯ != 'КТиУ';



-- step 8
SELECT 
    ФАМИЛИЯ,
    ИМЯ,
    ОТЧЕСТВО,
    НАПС_ИД,
    ДАТА_РОЖДЕНИЯ,
    ЧЕЛОЦЕНКА,
    СРОЦЕНКА
FROM (SELECT DISTINCT
    *,
    AVG(ОЦЕНКА) OVER (PARTITION BY ЧЛВК_ИД) AS ЧЕЛОЦЕНКА,
    AVG(ОЦЕНКА) OVER (PARTITION BY НАПС_ИД) AS СРОЦЕНКА
FROM 
    (SELECT 
        у.ЧЛВК_ИД,
        л.ФАМИЛИЯ,
        л.ИМЯ,
        л.ОТЧЕСТВО,
        л.ДАТА_РОЖДЕНИЯ,
        NULLIF(в.ОЦЕНКА, '')::float4 AS ОЦЕНКА,
        Н_ПЛАНЫ.НАПС_ИД
    FROM Н_УЧЕНИКИ AS у
    INNER JOIN Н_ВЕДОМОСТИ AS в
        ON в.ЧЛВК_ИД = у.ЧЛВК_ИД
    INNER JOIN Н_ЛЮДИ AS л
        ON л.ИД = в.ЧЛВК_ИД
    INNER JOIN Н_ПЛАНЫ
        ON Н_ПЛАНЫ.ПЛАН_ИД = у.ПЛАН_ИД
    JOIN Н_ОТДЕЛЫ 
        ON Н_ОТДЕЛЫ.ИД = Н_ПЛАНЫ.ОТД_ИД
    WHERE Н_ОТДЕЛЫ.КОРОТКОЕ_ИМЯ != 'КТиУ'
        AND в.ОЦЕНКА != 'зачет'
        AND в.ОЦЕНКА != 'незач'
        AND в.ОЦЕНКА != 'неявка'
        AND в.ОЦЕНКА != 'осв'
        AND в.ОЦЕНКА != '99'
        AND л.ДАТА_РОЖДЕНИЯ >= NOW() - INTERVAL '27 YEARS'
        AND л.ДАТА_РОЖДЕНИЯ <= NOW() - INTERVAL '21 YEARS'
    ) aboba ) subq
WHERE ЧЕЛОЦЕНКА >= СРОЦЕНКА
ORDER BY ФАМИЛИЯ DESC;
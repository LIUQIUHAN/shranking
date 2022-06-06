
#DROP FUNCTION func_quartile;
CREATE FUNCTION func_quartile(floats JSON) RETURNS JSON
    COMMENT '传入json格式小数数组、整数数组、小数整数交叉数组[1.1,2,3,4,5]，生成json格式的四分位值{“q1”:0.00,"q2":0.00,"q3":0.00}'
BEGIN
    /*

    插入一个小数类型的数组，计算此批数据的四分位；当入参数 floats 长度为0时，各四分位为都为0；
    文档地址：https://github.com/shanghairanking/docs/blob/main/2.%E9%A1%B9%E7%9B%AE%E6%96%87%E6%A1%A3/%E5%A4%A7%E5%AD%A6360%E5%B9%B3%E5%8F%B0/%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98.md

    */

    #1. 获取数据列表长度、各四分位的index位置
    DECLARE len INT DEFAULT JSON_LENGTH(floats);
    DECLARE list JSON DEFAULT floats;
    # 四分位下标位置
    DECLARE qi1 DECIMAL(20,8) DEFAULT 1 + (len - 1) * 0.25;
    DECLARE qi2 DECIMAL(20,8) DEFAULT 1 + (len - 1) * 0.5;
    DECLARE qi3 DECIMAL(20,8) DEFAULT 1 + (len - 1) * 0.75;
    DECLARE result JSON DEFAULT JSON_OBJECT('q1', 0.0, 'q2', 0.0, 'q3', 0.0);

    #2. 当长度等于0时直接返回
    IF len = 0 THEN RETURN result; END IF;
    #3. 将数据按从小到大排序
    SELECT CAST(concat('[',group_concat(val  ORDER BY val),']') AS JSON ) INTO list FROM JSON_TABLE(floats,'$[*]'COLUMNS(val INT PATH '$'))t;

    #4. 开始计算各个位数据
    WITH indexs AS (SELECT qi1 i, 1 ord_no
                    UNION ALL
                    SELECT qi2, 2 ord_no
                    UNION ALL
                    SELECT qi3, 3 ord_no),
         trun AS (SELECT i
                       , ord_no
                       , TRUNCATE(i, 0)     trunI
                       , i - TRUNCATE(i, 0)  diff
                  FROM indexs),
         -- 四分位index为整数时，直接按index取
         val AS (SELECT IF(diff = 0
                            , JSON_EXTRACT(list, CONCAT('$[', truni - 1, ']'))
                            , JSON_EXTRACT(list, CONCAT('$[', truni - 1, ']')) * (1 - diff) +
                              JSON_EXTRACT(list, CONCAT('$[', truni, ']')) * diff
                            )quartile, ord_no
                 FROM trun)
    SELECT JSON_OBJECT(
                   'q1', (SELECT cast(quartile as DECIMAL(20,8) ) FROM val WHERE ord_no = 1),
                   'q2', (SELECT cast(quartile as DECIMAL(20,8) ) FROM val WHERE ord_no = 2),
                   'q3', (SELECT cast(quartile as DECIMAL(20,8) ) FROM val WHERE ord_no = 3)
               ) INTO result;
    RETURN result;
END;




SELECT func_quartile('[1,2,3,4,5]');
/*
2,3,4
*/
SELECT func_quartile('[1 ,2, 3 ,4 ,5 ,6, 7, 8, 9]');
/*
3,5,7
*/
SELECT func_quartile('[2 ,4 ,6 ,8 ,10 ,12]');
/*
4.5, 7, 9.5
*/





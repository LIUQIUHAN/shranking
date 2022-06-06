DELIMITER $$$

CREATE PROCEDURE zqtest()

BEGIN

    DECLARE i int DEFAULT 0;

    SET i = 0;

    START TRANSACTION;

    WHILE i < 80000
        DO //your
            INSERT sql SET i=i + 1;

        END WHILE; COMMIT;

END

$$$

DELIMITER ;

CALL zqtest();

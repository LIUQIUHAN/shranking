USE src_product;

UPDATE raw_220523_dm_admin_user_univ_access_1_0628 A
SET A._univ_cn_code = (
    SELECT DISTINCT B._univ_cn_code
    FROM raw_220523_dm_admin_user_univ_access_1_0624 B
    WHERE A.univ_name = B.univ_name
)
WHERE 1;


-- 获取销售列表
WITH sal AS (SELECT a.id, a.login_name, u.name
             FROM src_product.admin_user a
                      JOIN src_product.src_user u ON a.src_user_id = u.id
             WHERE u.name IN ('俞帅', '朱建梅', '陈慧', '李恩超', '孟晓')
    --   ('王亲', '孟晓')
    --  ('李恩超', '杨谋成')
)
SELECT *
FROM sal;

# 1.查询宝北这个超管
SET @adminId = 0;
SELECT a.id
INTO @adminId
FROM src_product.admin_user a
         JOIN src_product.src_user u ON a.src_user_id = u.id
WHERE u.name = '吕宝北';


# 2.添加销售的产品权限
INSERT INTO src_product.admin_user_product(/*id,*/ admin_user_id, user_group, product_codes, /*remark, created_at, */created_by/*, updated_at, updated_by, deleted_at, deleted_by*/)
WITH sal AS (SELECT a.id, a.login_name, u.name
             FROM src_product.admin_user a
                      JOIN src_product.src_user u ON a.src_user_id = u.id
             WHERE u.name IN ('俞帅', '朱建梅', '陈慧', '李恩超', '孟晓')
    --   ('王亲', '孟晓')
    --  ('李恩超', '杨谋成')
)
SELECT sal.id, 2, '{"all": false, "codes": ["ub", "spm"]}', @adminId
FROM sal
ON DUPLICATE KEY
    UPDATE product_codes=VALUES(product_codes),
           deleted_at=NULL,
           deleted_by=NULL;

# 3. 添加学校权限
INSERT INTO src_product.admin_user_product_univ(/*id, */admin_user_id, user_group, univ_codes,/* created_at,*/
                                                        created_by/*, updated_at, updated_by, deleted_at, deleted_by*/)
WITH base AS (SELECT sales_name,
                     CAST(CONCAT('[', GROUP_CONCAT(DISTINCT CONCAT('"', _univ_cn_code, '"')), ']') AS JSON) univ_codes
              FROM raw_220523_dm_admin_user_univ_access_1_0628
              WHERE _univ_cn_code IS NOT NULL
              GROUP BY sales_name),
     sal AS (SELECT a.id, a.login_name, u.name
             FROM src_product.admin_user a
                      JOIN src_product.src_user u ON a.src_user_id = u.id
             WHERE u.name IN ('俞帅', '朱建梅', '陈慧', '李恩超', '孟晓')
         --   ('王亲', '孟晓')
         --  ('李恩超', '杨谋成')
     )
SELECT sal.id,
       2,
       JSON_SET('{
         "all": false
       }', '$.codes', base.univ_codes) univCodes,
       @adminId
FROM base
         JOIN sal ON base.sales_name = sal.name
ON DUPLICATE KEY UPDATE univ_codes=VALUES(univ_codes),
                        deleted_at=NULL,
                        deleted_by=NULL;


# 4. 检查
SELECT a.id, a.login_name, u.name, pu.univ_codes, p.product_codes
FROM src_product.admin_user a
         JOIN src_product.src_user u ON a.src_user_id = u.id
         JOIN src_product.admin_user_product_univ pu ON pu.admin_user_id = a.id
         JOIN src_product.admin_user_product p ON p.admin_user_id = a.id AND pu.user_group = p.user_group
WHERE u.name IN ('俞帅', '朱建梅', '陈慧', '李恩超', '孟晓')
  --   ('王亲', '孟晓')
  --  ('李恩超', '杨谋成')
  AND pu.deleted_at IS NULL
  AND p.user_group = 2
  AND p.deleted_at IS NULL
ORDER BY u.name;











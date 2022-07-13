# 学科平台客户信息数据迁移
# 客户账号迁移
# 老平台涉及到的表有：gaojilogin_user、t_school_benchmark、t_school_subjects、t_subjects_subrank、user_subrank、institution_subrank、user_gaojiuserlogin
USE src_product;

# 更新institution_subrank.tcode
UPDATE institution_subrank A
SET A.tcode = (SELECT code
               FROM univ_ranking_dev.univ_cn B
               WHERE A.code = B._code_old
               ORDER BY B.outdated = 0 DESC,
                        B.outdated DESC
               LIMIT 1)
WHERE 1;

DELETE
FROM user
WHERE remark = 'subject_user_old';

UPDATE user
SET role_id = 1
WHERE login_name IN ('cqu0926');
-- 数据迁移结束后需还原为普通账号
# 账号信息数据
SET @EmailNum = 2003;
INSERT IGNORE INTO user (user_name, login_name, email, mobile, role_id, user_group, univ_code, name, sex, department,
                         position, title, remark, frozen_at, password_md5, password_salt, password_hash, sms_code,
                         sms_code_upd_at, sms_code_tried, wx_union_id, qq_open_id, wb_uid, created_at, created_by,
                         updated_at,
                         updated_by, deleted_at, deleted_by)
SELECT real_name                                 user_name,
       name                                      login_name,
       IFNULL(email, CONCAT('ranking@rank', @EmailNum := @EmailNum + 1, '.com')),
       IFNULL(mobile, '')                        mo,
       user_type                                 role_id,
       1                                         user_group, -- 原表无法区分账号的类别，绝大多数均为原学科平台真实客户，极少的账号为公司员工创建的测试账号
       (SELECT B.tcode
        FROM institution_subrank B
        WHERE A.school_id = B.subjectCode)       univ_code,
       real_name                              AS name,
       IF(gender = 1, '男', '女')                  sex,
       IF(department IS NULL, '', department) AS department,
       IFNULL(position, '')                      po,
       IFNULL(title, '')                         ti,
       'subject_user_old'                     AS remark,     -- 标识此次原学科平台客户账号信息
       NULL                                      frozen_at,
       password                                  password_md5,
       ''                                        password_salt,
       ''                                        password_hash,
       NULL                                      sms_code,
       NULL                                      sms_code_upd_at,
       0                                         sms_code_tried,
       NULL                                      wx_union_id,
       NULL                                      qq_open_id,
       NULL                                      wb_uid,
       create_time                               created_at,
       -9999                                     created_by,
       IFNULL(update_time, NOW())                updated_at,
       NULL                                      updated_by,
       NULL                                      deleted_at,
       NULL                                      deleted_by
FROM user_subrank A
WHERE 1; -- email NOT IN (SELECT email FROM src_user);

UPDATE user
SET user_group = 2,
    role_id    = 3
WHERE login_name IN (SELECT src_user.login_name FROM src_user)
  AND remark = 'subject_user_old';

# 更新user.create_id（remark='subject_user_old'）,特殊处理：miaoyun0116:146    qinghua456:-51
UPDATE user
SET created_by = 146
WHERE login_name = 'miaoyun0116';
UPDATE user
SET created_by = -51
WHERE login_name = 'qinghua456';

WITH crt_by AS (
    SELECT a.name AS aname, IFNULL(-C.id, -8888) AS cid
    FROM user_subrank a
             LEFT JOIN gaojilogin_user b ON a.create_id = b.id
             LEFT JOIN admin_user c ON b.email_name = c.login_name)
UPDATE user d JOIN crt_by e ON d.login_name = e.aname
SET d.created_by = e.cid
WHERE d.created_by = -9999
  AND d.remark = 'subject_user_old'
;

WITH crt_by AS (
    SELECT a.name AS aname, b.name AS bname, c.id AS cid
    FROM user_subrank a
             JOIN user_subrank b ON a.id = b.create_id
             JOIN user c ON c.login_name = a.name)
UPDATE user d JOIN crt_by e ON d.login_name = e.bname
SET d.created_by = e.cid
WHERE d.created_by = -8888
  AND d.remark = 'subject_user_old'
;

DELETE
FROM subscription
WHERE updated_by = -2 AND product_code = 'spm';
# 学科标杆学校
INSERT INTO subscription (product_code, remark, univ_code, perm, start_date, expire_date, managed_by, created_at,
                          created_by, updated_at, updated_by)
WITH benchmark AS (
    SELECT A.id,
           (SELECT D.tcode FROM institution_subrank D WHERE A.school_id = D.subjectCode)       univ_code,
           member_name                                                                         name,

           (SELECT C.subject_code FROM t_subjects_subrank C WHERE A.subject_id = C.subject_id) subject_code,
           (SELECT D.tcode FROM institution_subrank D WHERE A.benchmark_id = D.subjectCode)    benchmark_univ_code,
           A.status,
           A.update_time,
           A.create_id
    FROM t_school_benchmark A
    UNION ALL
    SELECT B.id,
           (SELECT D.tcode FROM institution_subrank D WHERE B.school_id = D.subjectCode)       univ_code,
           B.member_name                                                                       name,
           (SELECT C.subject_code FROM t_subjects_subrank C WHERE B.subject_id = C.subject_id) subject_code,
           NULL AS                                                                             benchmark_univ_code,
           B.status,
           B.update_time,
           B.create_id
    FROM t_school_subjects B
    WHERE NOT EXISTS(SELECT *
                     FROM t_school_benchmark Z
                     WHERE B.member_name = Z.member_name
                       AND B.subject_id = Z.subject_id))
   , M AS (SELECT name, univ_code, subject_code, create_id, JSON_ARRAYAGG(benchmark_univ_code) benchmark_univ_codes
           FROM benchmark
           GROUP BY name, univ_code, subject_code
           ORDER BY name DESC)
SELECT 'spm'                                                                            product_code,
       name                                                                             remark,
       univ_code,
       CAST(REPLACE(JSON_ARRAYAGG(JSON_OBJECT('subjCode', subject_code, 'benchmark', benchmark_univ_codes)), 'null',
                    '') AS JSON)                                                        perm,
       (SELECT LEFT(create_time, 10)
        FROM user_subrank U
        WHERE U.name = M.name)                                                       AS start_date,
       (SELECT IF(validity_time = '2023-1-1', '2021-01-01', validity_time)
        FROM user_subrank U
        WHERE U.name = M.name)                                                       AS expire_date,
       REPLACE((SELECT created_by FROM user U WHERE U.login_name = M.name), '-', '') AS managed_by,
       NOW()                                                                            created_at,
       REPLACE((SELECT created_by FROM user U WHERE U.login_name = M.name), '-', '') AS created_by,
       NOW()                                                                            updated_at,
       -2                                                                               updated_by
FROM M
WHERE M.name IN (SELECT X.login_name FROM user X WHERE X.role_id = 1)
GROUP BY name, univ_code
;


DELETE
FROM user_subs
WHERE /*updated_by = -2 AND */product_code = 'spm';

INSERT INTO user_subs (user_id, product_code, role_id, remark1, subs_id, perm, remark, created_at, created_by,
                       updated_at,
                       updated_by)
WITH benchmark AS (
    SELECT A.id,
           (SELECT D.tcode FROM institution_subrank D WHERE A.school_id = D.subjectCode)       univ_code,
           member_name                                                                         name,
           (SELECT C.subject_code FROM t_subjects_subrank C WHERE A.subject_id = C.subject_id) subject_code,
           (SELECT D.tcode FROM institution_subrank D WHERE A.benchmark_id = D.subjectCode)    benchmark_univ_code,
           A.status,
           A.update_time,
           A.create_id
    FROM t_school_benchmark A
    UNION ALL
    SELECT B.id,
           (SELECT D.tcode FROM institution_subrank D WHERE B.school_id = D.subjectCode)       univ_code,
           B.member_name                                                                       name,
           (SELECT C.subject_code FROM t_subjects_subrank C WHERE B.subject_id = C.subject_id) subject_code,
           NULL AS                                                                             benchmark_univ_code,
           B.status,
           B.update_time,
           B.create_id
    FROM t_school_subjects B
    WHERE NOT EXISTS(SELECT *
                     FROM t_school_benchmark Z
                     WHERE B.member_name = Z.member_name
                       AND B.subject_id = Z.subject_id))
   , M AS (SELECT name,
                  univ_code,
                  subject_code,
                  create_id,
                  JSON_ARRAYAGG(benchmark_univ_code) benchmark_univ_codes,
                  update_time
           FROM benchmark
           GROUP BY name, univ_code, subject_code
           ORDER BY name DESC)
SELECT (SELECT id FROM user U WHERE U.login_name = M.name)                       user_id,
       'spm'                                                                     product_code,
       IFNULL((SELECT u.user_type FROM user_subrank u WHERE M.name = u.name), 2) role_id,
       name                                                                      remark1,
       -999                                                                      subs_id,
       CAST(REPLACE(JSON_ARRAYAGG(JSON_OBJECT('subjCode', subject_code, 'benchmark', benchmark_univ_codes)), 'null',
                    '') AS JSON)                                                 perm,
       'subject_user_old'                                                        remark,
       update_time                                                               created_at,
       (SELECT created_by FROM user U WHERE U.login_name = M.name) AS            created_by,
       update_time                                                               updated_at,
       -2                                                                        updated_by
FROM M
WHERE M.name IN (SELECT X.login_name FROM user X)
GROUP BY name, univ_code
;



WITH c AS (SELECT e.id AS id, a.name AS aname, b.name AS bname
           FROM user_subrank a
                    JOIN user_subrank b ON a.id = b.create_id
                    JOIN subscription e ON a.name = e.remark AND e.product_code = 'spm')
UPDATE user_subs f JOIN c ON f.remark1 = c.bname
SET f.subs_id = c.id
WHERE f.subs_id = -999;

UPDATE user_subs a JOIN subscription b ON a.remark1 = b.remark AND b.product_code = 'spm'
SET a.subs_id = b.id
WHERE a.subs_id = -999;

WITH c AS (SELECT e.id AS id, a.name AS aname, b.name AS bname
           FROM user a
                    JOIN user b ON a.id = b.created_by
                    JOIN subscription e ON a.name = e.remark AND e.product_code = 'spm')
UPDATE user_subs f JOIN c ON f.remark1 = c.bname
SET f.subs_id = c.id
WHERE f.subs_id = -999;

UPDATE user
SET role_id = 2
WHERE login_name = 'cqu0926';
-- 数据迁移结束还原为普通账号

# 添加普通账户（非管理员账号）的页面权限
INSERT INTO spm_product.user_menu(user_id, menus, created_at, created_by, updated_at, updated_by, deleted_at,
                                  deleted_by)
SELECT id                                                      user_id,
       '[1, 2, 3, 26, 4, 5, 7, 9, 12, 13, 21, 22, 23, 14, 15]' menus,
       created_at,
       created_by,
       updated_at,
       updated_by,
       deleted_at,
       deleted_by
FROM user
WHERE role_id = 2
  AND remark = 'subject_user_old'
;


# 公司员工的账号无有效期设定
UPDATE user A
SET user_group = 2
WHERE EXISTS(SELECT * FROM src_user B WHERE A.email = B.email);

UPDATE subscription A
SET expire_date = '3022-01-01'
WHERE EXISTS(SELECT * FROM src_user B WHERE A.remark = B.email);

UPDATE subscription A
SET expire_date = '3022-01-01'
WHERE EXISTS(SELECT * FROM src_user B WHERE A.remark = B.login_name);


# 使用 user_gaojiuserlogin 表的数据更新客户账号密码
UPDATE user A JOIN user_gaojiuserlogin B ON A.login_name = B.account
SET A.password_md5 = B.password
WHERE remark =  'subject_user_old';


SELECT *
FROM user_subs
WHERE subs_id = -999;




# 学科平台客户信息数据迁移
# 客户账号迁移
# 老平台涉及到的表有：gaojilogin_user、t_school_benchmark、t_school_subjects、t_subjects_subrank、user_subrank、institution_subrank
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

# 账号信息数据
/*INSERT INTO user ( user_name, login_name, email, mobile, role_id, user_group, univ_code, name, sex, department,
                   position, title, remark, frozen_at, password_md5, password_salt, password_hash, sms_code,
                   sms_code_upd_at, sms_code_tried, wx_union_id, qq_open_id, wb_uid, created_at, created_by,
                   updated_at,
                   updated_by, deleted_at, deleted_by )
SELECT user_name,
       email_name                                login_name,
       email,
       IFNULL(mobile, '')                        mo,
       user_type                                 role_id,
       1                                         user_group, -- 1.原表无法区分账号的类别，绝大多数均为老版360真实客户，部分为公司员工创建的测试账号(已过滤)；2.已离职员工账号需要相关同事补充到过滤条件中去
       func_school_code_tr_now_code(jianxie)     univ_code,
       real_name                                 name,
       IF(gender = 1, '男', '女')                  sex,
       IF(department IS NULL, '', department) AS department,
       IFNULL(position, '')                      po,
       IFNULL(title, '')                         ti,
       '360_user_old'                            remark,
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
       create_id                                 created_by,
       update_time                               updated_at,
       NULL                                      updated_by,
       NULL                                      deleted_at,
       NULL                                      deleted_by
FROM user_subrank;*/



# 学科的标杆学校
WITH benchmark AS (
    SELECT A.id,
           (SELECT D.tcode FROM institution_subrank D WHERE A.school_id = D.subjectCode)       univ_code,
           member_name                                                                         name,
           (SELECT C.subject_code FROM t_subjects_subrank C WHERE A.subject_id = C.subject_id) subject_code,
           (SELECT D.tcode FROM institution_subrank D WHERE A.benchmark_id = D.subjectCode)    benchmark_univ_code,
           A.status,
           A.update_time
    FROM t_school_benchmark A
    UNION ALL
    SELECT B.id,
           (SELECT D.tcode FROM institution_subrank D WHERE B.school_id = D.subjectCode)       univ_code,
           B.member_name                                                                       name,
           (SELECT C.subject_code FROM t_subjects_subrank C WHERE B.subject_id = C.subject_id) subject_code,
           '' AS                                                                               benchmark_univ_code,
           B.status,
           B.update_time
    FROM t_school_subjects B
    WHERE NOT EXISTS(SELECT *
                     FROM t_school_benchmark Z
                     WHERE B.member_name = Z.member_name AND B.subject_id = Z.subject_id))
   , M AS (SELECT name, univ_code, subject_code, JSON_ARRAYAGG(benchmark_univ_code) benchmark_univ_codes
           FROM benchmark
           GROUP BY name, univ_code, subject_code
           ORDER BY name DESC)
SELECT name, univ_code, JSON_ARRAYAGG(JSON_OBJECT('subjCode', subject_code, 'benchmark', benchmark_univ_codes)) perm
FROM M
GROUP BY name, univ_code;

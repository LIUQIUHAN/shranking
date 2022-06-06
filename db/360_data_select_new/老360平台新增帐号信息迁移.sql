# 老360平台客户帐号信息、标杆数据迁移至新360平台

/*USE src_product;
# 更新user_360表中create_id
UPDATE user_360
SET create_id = 51 -- 51 = 'baobei.yu'
WHERE 1;
UPDATE user_360 A JOIN admin_user B ON A.create_name = B.user_name
SET A.create_id = B.id
WHERE 1;
UPDATE user_360 SET update_time = '2022-05-17 17:22:41' WHERE update_time IS NULL;*/


# 用户账号
INSERT INTO user ( user_name, login_name, email, mobile, role_id, user_group, univ_code, name, sex, department,
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
       ub_ranking_a.func_school_code_tr_now_code(jianxie)     univ_code,
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
FROM user_360
WHERE email IN ('shurao@cuhk.edu.cn', 'wuhongli@cuhk.edu.cn', 'daisysun@cuhk.edu.cn')
;

# 更新user.created_by
WITH c AS ( SELECT e.id AS id, a.email AS aemail, b.email AS bemail
            FROM user_360      a
                 JOIN user_360 b ON a.id = b.create_id_user
                 JOIN user     e ON a.email = e.email )
UPDATE user f JOIN c ON f.email = c.bemail
SET f.created_by = c.id
WHERE email IN ('shurao@cuhk.edu.cn', 'wuhongli@cuhk.edu.cn', 'daisysun@cuhk.edu.cn');

# 用户标杆
INSERT INTO subscription ( product_code, remake, univ_code, perm, start_date, expire_date, managed_by, created_at,
                           created_by, updated_at, updated_by, deleted_at, deleted_by )
SELECT 'ub'                                  product_code,
       email                                 remake,
       ub_ranking_a.func_school_code_tr_now_code(jianxie) univ_code,
       ( SELECT CONCAT('[', GROUP_CONCAT(CONCAT('"', uc.code, '"') ORDER BY FIND_IN_SET(uc._code_old, a.compareInst)),
                       ']') k
         FROM univ_ranking_a.univ_cn uc
         WHERE FIND_IN_SET(uc._code_old, a.compareInst)
           AND NOT uc.outdated )             perm,
       LEFT(create_time, 10)                 start_date,
       expiration_time                       expire_date,
       create_id                             managed_by,
       create_time                           created_at,
       create_id                             created_by, -- 通过user_id 更新
       update_time                           updated_at,
       NULL                                  updated_by,
       NULL                                  deleted_at,
       NULL                                  deleted_by
FROM user_360 a
WHERE email IN ('shurao@cuhk.edu.cn', 'wuhongli@cuhk.edu.cn', 'daisysun@cuhk.edu.cn');


INSERT INTO user_subs ( user_id, product_code, remake1, subs_id, perm, remark, created_at, created_by, updated_at,
                        updated_by, deleted_at, deleted_by )
SELECT -99999                    user_id,
       'ub'                      product_code,
       email                     remake1,
       -99999                    subs_id,
       ( SELECT CONCAT('[', GROUP_CONCAT(CONCAT('"', uc.code, '"') ORDER BY FIND_IN_SET(uc._code_old, a.compareInst)),
                       ']') k
         FROM univ_ranking_a.univ_cn uc
         WHERE FIND_IN_SET(uc._code_old, a.compareInst)
           AND NOT uc.outdated ) perm,
       NULL                      remark,
       create_time               created_at,
       1                         created_by,
       update_time               updated_at,
       NULL                      updated_by,
       NULL                      deleted_at,
       NULL                      deleted_by
FROM user_360 a
WHERE email IN ('shurao@cuhk.edu.cn', 'wuhongli@cuhk.edu.cn', 'daisysun@cuhk.edu.cn');

UPDATE user_subs a JOIN user b ON a.remake1 = b.email
SET a.user_id    = b.id,
    a.created_by = b.created_by
WHERE remake1 IN ('shurao@cuhk.edu.cn', 'wuhongli@cuhk.edu.cn', 'daisysun@cuhk.edu.cn');

WITH c AS ( SELECT e.id AS id, a.email AS aemail, b.email AS bemail
            FROM user_360          a
                 JOIN user_360     b ON a.id = b.create_id_user
                 JOIN subscription e ON a.email = e.remake )
UPDATE user_subs f JOIN c ON f.remake1 = c.bemail
SET f.subs_id = c.id
WHERE remake1 IN ('shurao@cuhk.edu.cn', 'wuhongli@cuhk.edu.cn', 'daisysun@cuhk.edu.cn');

UPDATE user_subs a JOIN subscription b ON a.remake1 = b.remake
SET a.subs_id = b.id
WHERE remake1 IN ('shurao@cuhk.edu.cn', 'wuhongli@cuhk.edu.cn', 'daisysun@cuhk.edu.cn');

# 添加普通账户（非管理员账号）的页面权限
INSERT INTO ub_product.user_menu( user_id, menus, created_at, created_by, updated_at, updated_by, deleted_at,
                                  deleted_by )
SELECT id                                               user_id,
       '[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]' menus,
       created_at,
       created_by,
       updated_at,
       updated_by,
       deleted_at,
       deleted_by
FROM user
WHERE email IN ('shurao@cuhk.edu.cn', 'wuhongli@cuhk.edu.cn', 'daisysun@cuhk.edu.cn')
      AND role_id = 2;


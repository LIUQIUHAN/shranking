#

INSERT INTO rank_tbl_batch_update_record ( edition_year, target_code, target_data_year, is_new_edition, target_status,
                                           is_inform_app, is_inform_app_test, update_type )
SELECT edition_year,
       target_code,
       target_data_year,
       is_new_edition,
       target_status,
       is_inform_app,
       is_inform_app_test,
       update_type
FROM `rank_tbl_batch_update_record_re`
WHERE target_code IN ('','');
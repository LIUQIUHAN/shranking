# 更新版本号：@Edition_year

SET @Edition_year = '202206';

DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'b171' AND data_year = '2015-2020';
DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'b172' AND data_year = '2015-2020';

DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'i41' AND data_year = '2016-2021';
DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'i42' AND data_year = '2016-2021';

DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'b145' AND data_year = '2016-2021';
DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'b146' AND data_year = '2016-2021';

DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'i51b' AND data_year = '2019';
DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'i52b' AND data_year = '2019';

DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'i49b' AND data_year = '2019';
DELETE FROM temporary_rank_tbl_school_target_info WHERE target_code = 'i50b' AND data_year = '2019';

INSERT INTO temporary_rank_tbl_school_target_info ( school_code,
                                                    target_code,
                                                    data_year,
                                                    data_source_id,
                                                    target_val,
                                                    target_rank,
                                                    type_score_rank,
                                                    target_rank_range,
                                                    target_score,
                                                    data_source_mu,
                                                    data_source_mu_year,
                                                    original_year,
                                                    original_source )
SELECT school_code,
       target_code,
       data_year,
       data_source_id,
       target_val,
       target_rank,
       type_score_rank,
       target_rank_range,
       target_score,
       data_source_mu,
       data_source_mu_year,
       original_year,
       original_source
FROM rank_tbl_school_target_info_rank_2022
WHERE edition_year = @Edition_year
  AND target_code IN ('b171', 'b172', 'i41', 'i42', 'b145', 'b146', 'i51b', 'i52b', 'i49b', 'i50b');
 
DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'b171' AND data_year = '2015-2020';
DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'b172' AND data_year = '2015-2020';

DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'i41' AND data_year = '2016-2021';
DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'i42' AND data_year = '2016-2021';

DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'b145' AND data_year = '2016-2021';
DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'b146' AND data_year = '2016-2021';

DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'i51b' AND data_year = '2019';
DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'i52b' AND data_year = '2019';

DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'i49b' AND data_year = '2019';
DELETE FROM temporary_rank_tbl_school_target_info_zero WHERE target_code = 'i50b' AND data_year = '2019';

INSERT INTO temporary_rank_tbl_school_target_info_zero ( target_code,
                                                         data_year,
                                                         target_val,
                                                         target_rank,
                                                         target_rank_range,
                                                         original_year,
                                                         data_source_id,
                                                         data_source_mu,
                                                         data_source_mu_year,
                                                         original_source )
SELECT target_code,
       data_year,
       target_val,
       target_rank,
       target_rank_range,
       original_year,
       data_source_id,
       data_source_mu,
       data_source_mu_year,
       original_source
FROM rank_tbl_school_target_info_zero
WHERE edition_year = @Edition_year
  AND target_code IN ('b171', 'b172', 'i41', 'i42', 'b145', 'b146', 'i51b', 'i52b', 'i49b', 'i50b');
		
DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'b171' AND data_year = '2015-2020';
DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'b172' AND data_year = '2015-2020';

DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'i41' AND data_year = '2016-2021';
DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'i42' AND data_year = '2016-2021';

DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'b145' AND data_year = '2016-2021';
DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'b146' AND data_year = '2016-2021';

DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'i51b' AND data_year = '2019';
DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'i52b' AND data_year = '2019';

DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'i49b' AND data_year = '2019';
DELETE FROM temporary_rank_tbl_school_target_info_type_zero WHERE target_code = 'i50b' AND data_year = '2019';

INSERT INTO temporary_rank_tbl_school_target_info_type_zero ( type_code,
                                                              target_code,
                                                              data_year,
                                                              target_val,
                                                              target_rank,
                                                              target_rank_range,
                                                              original_year,
                                                              data_source_id,
                                                              data_source_mu,
                                                              data_source_mu_year,
                                                              original_source )
SELECT type_code,
       target_code,
       data_year,
       target_val,
       target_rank,
       target_rank_range,
       original_year,
       data_source_id,
       data_source_mu,
       data_source_mu_year,
       original_source
FROM rank_tbl_school_target_info_type_zero
WHERE edition_year = @Edition_year
  AND target_code IN ('b171', 'b172', 'i41', 'i42', 'b145', 'b146', 'i51b', 'i52b', 'i49b', 'i50b');

UPDATE rank_tbl_school_target_info_rank_2022
SET target_val = NULL
WHERE edition_year = @Edition_year
  AND target_code = 'b41'
  AND target_val = '0';

INSERT INTO `rank_tbl_school_target_info_zero` ( edition_year, target_code, data_year, target_val, target_rank,
                                                 original_year, data_source_id, original_source )
VALUES ( @Edition_year, 'i102', '截至2020', '0', '1', '截至2020', '0', '0' );
SELECT * FROM `rank_tbl_school_target_info_zero` WHERE target_code = 'i102';

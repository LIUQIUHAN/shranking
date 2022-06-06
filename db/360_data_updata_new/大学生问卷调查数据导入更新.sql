# 1.建表

/*DROP TABLE IF EXISTS univ_satisfaction_question;
CREATE TABLE univ_satisfaction_question
(
    id          INT AUTO_INCREMENT PRIMARY KEY,
    pid         INT         DEFAULT 0                 NOT NULL COMMENT '从属问题id',
    ver_no      INT                                   NOT NULL COMMENT '调查问卷版本号',
    code        VARCHAR(20) DEFAULT ''                NOT NULL COMMENT '代码',
    title       VARCHAR(500)                          NULL COMMENT '问题',
    target_type INT                                   NOT NULL COMMENT '回答对象类型：1=本科、2=专科、3=本科和专科',
    ord_no      INT                                   NOT NULL COMMENT '问题序号，仅非用户基础信息题',
    created_at  DATETIME    DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE (ver_no, code)
) COMMENT '软科满意度调查题目';


DROP TABLE IF EXISTS univ_satisfaction_stats;
CREATE TABLE univ_satisfaction_stats
(
    id                   INT AUTO_INCREMENT PRIMARY KEY,
    ver_no               INT                                NOT NULL COMMENT '问卷版本:调查结果年月：202204',
    target_type          INT                                NOT NULL COMMENT '回答对象类型：1=本科、2=专科',
    q_id                 INT                                NOT NULL COMMENT '题目id：univ_satisfaction_question.id',
    q_code               VARCHAR(20)                        NOT NULL COMMENT '题目code:univ_satisfaction_question.code',
    univ_cn_id           INT                                NOT NULL COMMENT '学校id（因为使用了不同的学校表，所有学校id会出现相同的情况）',
    univ_cn_code         VARCHAR(20)                        NOT NULL COMMENT '院校编码：RC00001',
    satisfaction_ratio   VARCHAR(20)                        NOT NULL COMMENT '选择“非常满意”和“满意”的比例:85%-90%',
    percentile_order     VARCHAR(20)                        NOT NULL COMMENT '百分段位:前5%',
    questionnaires_scale VARCHAR(20)                        NOT NULL COMMENT '问卷规模',
    created_at           DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at           DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP,
    _univ_cn_name        VARCHAR(150)                       NOT NULL COMMENT '学校名称',
    _q_name              VARCHAR(50)                        NOT NULL COMMENT '题目名称',
    UNIQUE (ver_no, q_code, univ_cn_code)
) COMMENT '软科大学生满意度问卷表现结果表';*/


# 2.更新指标code、指标id,学校code、学校id
USE univ_ranking_dev;

UPDATE univ_ranking_raw.ub_220427_univ_satisfaction_stats A
    LEFT JOIN univ_satisfaction_question B ON A._q_name = B.title AND A.target_type = B.target_type
    LEFT JOIN univ_cn C ON A._univ_cn_name = C.name_cn AND C.outdated = 0
SET A.q_id         = B.id,
    A.q_code       = B.code,
    A.univ_cn_id   = C.id,
    A.univ_cn_code = C.code
WHERE 1;

UPDATE univ_ranking_raw.ub_220427_univ_satisfaction_stats A
    LEFT JOIN univ_cn_academy C ON A._univ_cn_name = C.name_cn AND C.outdated = 0
SET
    A.univ_cn_id   = C.id,
    A.univ_cn_code = C.code
WHERE A.target_type = 2;

# 3.将数据导入univ_ranking_dev表中
TRUNCATE TABLE univ_satisfaction_stats;
INSERT INTO univ_satisfaction_stats ( ver_no, target_type, q_id, q_code, univ_cn_id, univ_cn_code,
                                      satisfaction_ratio, percentile_order, questionnaires_scale, created_at,
                                      updated_at, _univ_cn_name,
                                      _q_name )
SELECT ver_no,
       target_type,
       q_id,
       q_code,
       univ_cn_id,
       univ_cn_code,
       satisfaction_ratio,
       percentile_order,
       questionnaires_scale,
       created_at,
       updated_at,
       _univ_cn_name,
       _q_name
FROM univ_ranking_raw.ub_220427_univ_satisfaction_stats;

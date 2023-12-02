/*
	Build infrastructure for sample data in 'member_scans.csv'
*/

CREATE SCHEMA IF NOT EXISTS sample_data;

DROP TABLE IF EXISTS member_scans;
CREATE TABLE IF NOT EXISTS member_scans (
    id                      float,
    age                     float,
    bmr                     float,
    body_age                float,
    bone_slim               float,
    bone_slim_low           float,
    bone_slim_top           float,
    ecf                     float,
    height                  float,
    icf                     float,
    lbm_low_limit           float,
    lbm_quantity            float,
    lbm_top_limit           float,
    mbf_low_limit           float,
    mbf_quantity            float,
    mbf_top_limit           float,
    mineral_low_limit       float,
    mineral_quantity        float,
    mineral_top_limit       float,
    msf_quantity            float,
    mvf_quantity            float,
    protein_low_limit       float,
    protein_quantity        float,
    protein_top_limit       float,
    sex                     float,
    tbw_low_limit           float,
    tbw_quantity            float,
    tbw_top_limit           float,
    total_score             float,
    weight                  float,
    whr_level               float,
    macro_goal              varchar(100),
    macro_bodytype          varchar(100),
    macro_activitylevel     varchar(100),
    macro_activitytype      varchar(100),
    macro_fatloss           varchar(100)
);

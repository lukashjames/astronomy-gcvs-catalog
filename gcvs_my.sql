create table gcvs (
    id int not null auto_increment primary key,
    varnum char(6) comment 'Numeric designation, made from constellation and star names (codes in file "constel.txt")',
    m_varnum char(1) comment 'Component identification (1)',
    gcvs varchar(10) comment 'Variable star designation (G1)',
    n_gcvs char(1) comment '[*] indicates a remark in "gcvs_rem.dat" file',
    rah tinyint comment '? Hours RA, equinox J2000.0 (2)',
    ram tinyint comment '? Minutes RA, equinox J2000.0 (2)',
    ras numeric(4, 1) comment '? Seconds RA, equinox J2000.0 (2)',
    de_sign char(1) comment '? Sign Dec, equinox J2000.0 (2)',
    ded tinyint unsigned comment '? Degrees Dec, equinox J2000.0 (2)',
    dem tinyint unsigned comment '? Minutes Dec, equinox J2000.0 (2)',
    des tinyint unsigned comment '? Seconds Dec, equinox J2000.0 (2)',
    u_dEs char(1) comment '[:*] position accuracy flags (3)',
    vartype varchar(10) comment 'Type of variability (see file "vartype.txt")',
    l_magmax char(1) comment '[<>(] Limit or amplitude symbol on magMax (G3)',
    magmax numeric(6, 3) comment '? Magnitude at maximum brightness',
    u_magmax char(1) comment 'Uncertainty flag (:) on magMax',
    magmax_ampl char(1) comment '[)] ")" if magMax is an amplitude',
    l_min1 char(1) comment '[<(] Limit or amplitude symbol on Min1 (G3)',
    min1 numeric(6, 3) comment '? Minimum magnitude or amplitude',
    u_min1 char(1) comment 'Uncertainty flag (:) on Min1',
    n_min1 char(2) comment 'Alternative photometric system for Min1 (G4)',
    min1_ampl char(1) comment '[)] ")" if Min1 is an amplitude',
    l_min2 char(1) comment '[<(] Limit or amplitude symbol on Min2 (G3)',
    min2 numeric(6, 3) comment '? Secondary minimum magnitude or amplitude',
    u_min2 char(1) comment 'Uncertainty flag (:) on Min2',
    n_min2 char(2) comment 'Alternative photometric system for Min2 (G4)',
    min2_ampl char(1) comment '[)] ")" if Min2 is an amplitude',
    flt char(2) comment 'The photometric system for magnitudes (G4)',
    epoch numeric(13, 5) comment '? Epoch for maximum light, Julian days (G5)',
    u_epoch char(1) comment '[:±] Uncertainty flag on Epoch (4)',
    `year` year comment 'Year of outburst for nova or supernova',
    u_year char(1) comment '[:] Uncertainty flag on Year of outburst',
    l_period char(1) comment '[<>(] Code for upper or lower limits (5)',
    period numeric(16, 10) comment '? Period of the variable star',
    u_period char(3) comment '[*/N)2: ] Uncertainties on Period (6)',
    mmd tinyint comment '? Rising time or duration of eclipse (G6)',
    u_mmd char(1) comment 'Uncertainty flag (:) on M-m/D',
    n_mmd char(1) comment '[*] Note for eclipsing variable (G6)',
    sptype varchar(17) comment 'MK Spectral type',
    ref1 varchar(5) comment 'Reference to a study of the star (G7)',
    ref2 varchar(5) comment 'Reference to a chart or photograph (G7)',
    f_gcvs char(1) comment '[=N+] "N" if the star does not exist (7)',
    varname varchar(10) comment 'Alternative name of the variable (G8)'
);

-- update gcvs set gcvs = replace(gcvs, '  ', ' ');
-- update gcvs set vartype = replace(vartype, '  ', ' ');
-- update gcvs set sptype = replace(sptype, '  ', ' ');
-- update gcvs set ref1 = replace(ref1, '  ', ' ');
-- update gcvs set ref2 = replace(ref2, '  ', ' ');
-- update gcvs set varname = replace(varname, '  ', ' ');

-- update gcvs set gcvs = trim(gcvs);
-- update gcvs set vartype = trim(vartype);
-- update gcvs set sptype = trim(sptype);
-- update gcvs set ref1 = trim(ref1);
-- update gcvs set ref2 = trim(ref2);
-- update gcvs set varname = trim(varname);

-- update gcvs set varname = '' where varname is null;


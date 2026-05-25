Capstone Project Preliminary Analysis
Chris Canty
Project Title: Does Superhero Power Level Impact Property Damage? A Data-Driven Analysis of Superhero Destruction
________________________________________
Project Objective
The goal of this project is to determine whether a superhero's official power level rating correlates with the amount of property damage they cause on screen. Using scene-level property damage data collected from 71 superhero films/tv, merged with official Marvel power grid ratings and comic book character appearance data, this analysis will test whether stronger heroes consistently cause more destruction — or whether other factors like scale of conflict, villain involvement, and narrative context are better predictors.
Audience: Data science students, superhero fans, and content creators interested in the intersection of pop culture and data analysis
________________________________________
Data Collection Sources
Dataset 1 — Superhero Property Damage Dataset (Primary) Manually curated dataset of 300 scene-level property damage observations across 31 superhero films spanning DC, Marvel, and Image Comics universes. Data collected through direct viewing and analysis of each film, documenting asset type, severity, scale, power class, scene score, and damage responsibility per scene.
Dataset 2 — Marvel Power Grid Ratings Official Marvel character power grid ratings sourced from Marvel's published character databases. Covers 1,054 characters across multiple groups including Avengers, Asgardians, Elders of the Universe, Celestials, and more. Variables include Intelligence, Strength, Speed, Durability, Energy Projection, Fighting Skills, and Overall rating. Source: Marvel Comics official character database.
Dataset 3 — DC/Marvel Comic Characters Export Comprehensive character dataset covering 21,144 DC and Marvel comic book characters. Variables include character name, identity type, alignment, physical attributes, number of comic appearances, first appearance date, home planet, and universe. Source: Exported from comic character database, April 19, 2026.
Invincible Addition -  Invincible (Mark Grayson) from Image Comics was manually added to the power grid dataset. Power ratings were assigned based on documented abilities from the Invincible comic series (144 issues, 2003-2018) and the Amazon animated series. Invincible was already present in the property damage dataset with the highest scene scores recorded.
________________________________________
Methodology
Preprocessing Techniques:
Dataset 1 — Property Damage:
•	The Notes column contained 285 missing values (95% of rows). These were excluded from analysis as they represented optional supplementary descriptions rather than required variables.
•	Two entries for Black Panther were found with trailing whitespace ('Black Panther' and 'Black Panther ') creating what appeared to be duplicate hero entries. These were standardized by stripping whitespace from all hero name fields.
•	Batman had a trailing space in the name field ('Batman ') and was corrected to 'Batman' for consistent merging.
•	No duplicate scene rows were detected.
•	All core analytical columns (Scene Score, Severity Score, Scale Score, Tier Level) contained zero missing values.
Dataset 2 — Marvel Power Grid:
•	13 missing values detected across Real Name (5), Sex (1), Year First Appeared (1), and individual power stat columns (6 total).
•	Missing power stats were replaced with the median value for that attribute to preserve row count without skewing averages. Removing these rows would eliminate valid characters from the power analysis.
•	Column headers contained newline characters (e.g., 'Year First\nAppeared', 'Energy\nProjection') which were cleaned to single-line format for readability.
•	Year First Appeared ranges from 1937 to 2016.
•	Invincible needs to be manually appended with the following ratings: Intelligence 85, Strength 95, Speed 90, Durability 92, Energy Projection 70, Fighting Skills 85, Overall 88.
Dataset 3 — DC/Marvel Comic Characters:
•	No missing values detected across all 21,144 rows and 12 columns.
•	No duplicate rows detected.
•	First_appeared column stored as a string in 'YYYY, Month' format. This was converted to a datetime-compatible format for date range analysis.
•	Universe column confirmed two values only: Marvel (14,665 rows) and DC (6,479 rows).
•	Appearances column ranges from 1 to 4,043 comic appearances.
•	First appearances range from October 1935 to October 2013.
Workflow:
1.	I’ll load all three datasets using pandas
2.	I’ll clean column names and standardized hero name formatting across datasets
3.	I’ll manually Invincible to power grid dataset
4.	I’ll merge property damage dataset with power grid on hero name as the join key
5.	I’ll merge resulting dataset with comic characters on name for appearance count enrichment
6.	I’ll flag unmatched heroes (team entries like 'The Avengers', 'X-Men' and Image Comics characters not in Marvel/DC datasets) for exclusion or manual handling
7.	I’ll merge datasets used for correlation analysis between power level and scene score
Tools I’ll Use: MySQL, Python, pandas
________________________________________
Findings
1. Data Size
Dataset	Rows	Columns
Property Damage	300	28
Marvel Power Grid (Main Sheet)	1,054	13
DC/Marvel Comic Characters	21,144	12
Combined (post-merge)	~21,000+	TBD

2. Missing Values
Dataset	Missing Values	Action
Property Damage	285 (Notes column only)	Excluded — optional field
Marvel Power Grid	13 (minor fields)	Median replacement for power stats, excluded from non-critical fields
DC/Marvel Comic Characters	0	No action needed

3. Duplicates No duplicate rows were detected in any of the three datasets. However, hero name inconsistencies in the property damage dataset (trailing whitespace in 'Batman ' and 'Black Panther ') functioned as near-duplicates during merging and were corrected by stripping whitespace from all name fields before joining.
4. Dates
•	Marvel Power Grid: Character first appearances range from 1937 to 2016. No modification needed — this serves as historical context rather than an analytical variable.
•	DC/Marvel Comic Characters: First appearance dates range from October 1935 to October 2013. The string format ('1935, October') was converted to a structured date format for consistency.
•	Property Damage Dataset: Films range from 2005 (Batman Begins) to present. Year column was already in integer format and required no conversion.
5. Additional Findings and Outliers
•	Invincible produced the three highest scene scores in the entire dataset (1,440 — The Invincible War; 1,200 — Omni Ends The Flaxans; 864 — It's Chicago!). These are legitimate extreme values reflecting the scale of destruction depicted in the animated series, not data errors.
•	The Scene Score distribution is heavily right-skewed. Mean of 127.45 vs. median of 48.00 indicates most scenes produce moderate damage while a small number of catastrophic events pull the average significantly higher.
•	Maximum scene score of 1,440 is 11x the mean, confirming significant outlier presence at the high end.
•	Several hero entries in the damage dataset represent teams rather than individuals (The Avengers, X-Men, Justice League, Fantastic Four, Guardians of the Galaxy). These will be handled separately in analysis — either disaggregated to individual heroes or analyzed as a team category.
•	The Marvel Power Grid dataset covers Marvel characters only. DC characters in the damage dataset (Batman, Superman, Wonder Woman, The Flash, Aquaman) will require supplementary DC power data or manual power rating assignment for complete cross-universe analysis.
________________________________________
Python & SQL analysis code will be attached as separate file


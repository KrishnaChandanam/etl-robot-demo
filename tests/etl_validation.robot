*** Settings ***
Library    OperatingSystem
Library    ../libraries/csv_etl_keywords.py

*** Variables ***
${SOURCE_FILE}    data/orders_source.csv
${TARGET_FILE}    data/orders_target.csv

*** Test Cases ***
Validate Target File Generated
    File Should Exist    ${TARGET_FILE}

Validate Row Count After ETL
    ${source_count}=    Get Row Count    ${SOURCE_FILE}
    ${target_count}=    Get Row Count    ${TARGET_FILE}
    Should Be True    ${target_count} < ${source_count}

Validate No Null Customer In Target
    ${rows}=    Read Csv    ${TARGET_FILE}
    Validate No Null Customer    ${rows}

Validate Business Rule Total Amount
    ${rows}=    Read Csv    ${TARGET_FILE}
    Validate Total Amount    ${rows}

Validate Date Format
    ${rows}=    Read Csv    ${TARGET_FILE}
    Validate Date Format    ${rows}

Validate No Duplicate Orders
    ${rows}=    Read Csv    ${TARGET_FILE}
    Validate No Duplicate Orders    ${rows}

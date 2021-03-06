SELECT
date_month 日期,
sum(case when Main_Acct_Desc='財務費用-利息收入' then amount_RMB else 0 end) 利息收入,
sum(case when Main_Acct_Desc='財務費用-集团内部利息收入' then amount_RMB else 0 end) 集团内部利息收入,
sum(case when Main_Acct_Desc='財務費用-利息費用' then amount_RMB else 0 end) 贷款利息支出,
sum(case when Main_Acct_Desc='財務費用-集团内部利息支出' then amount_RMB else 0 end) 集团内部利息支出,
sum(case when Main_Acct_Desc='財務費用-其他' then amount_RMB else 0 end) 金融机构手续费,
sum(case when Main_Acct_Desc='財務費用-兌換損失' then amount_RMB else 0 end)+sum(case when Main_Acct_Desc='財務費用-兌換利益' then amount_RMB else 0 end) 汇兑损益,
sum(case when Main_Acct_Desc='財務費用-财务顾问费' then amount_RMB else 0 end) 财务顾问费,
sum(case when Main_Acct_Desc='財務費用-担保费' then amount_RMB else 0 end) 担保费,
sum(case when Main_Acct_Desc='財務費用-贴现利息支出' then amount_RMB else 0 end) 贴现利息支出,
sum(case when Main_Acct_Desc='財務費用-融资租赁利支出' then amount_RMB else 0 end) 融资租赁利支出,
sum(case when Main_Acct_Desc='財務費用-利息支出资本化' then amount_RMB else 0 end) 利息支出资本化
FROM (SELECT
o271918.COMPANY_ACCT,
TO_CHAR(o271918.EFFECTIVE_DATE,'yyyy-mm') as date_month,
o271918.EFFECTIVE_DATE,o271918.VOUCHER_NUMBER,o271918.CURRENCY,
o271918.SOURCE,o271918.EXPENSE_ATTR_DESC as Expense_Attr_Desc,
o271918.DEPT_ACCT,o271918.DEPT_ACCT_DESC,
o271918.MAIN_ACCT,o271918.MAIN_ACCT_DESC as Main_Acct_Desc,
o271918.SUB_ACCT,o271918.SUB_ACCT_DESC,
NVL(o271918.ACCOUNTED_DR,0)-NVL(o271918.ACCOUNTED_CR,0) as amount_org,
NVL(o271918.ACCOUNTED_DR,0)-NVL(o271918.ACCOUNTED_CR,0) as amount_RMB,
o271918.LINE_DESCRIPTION,
o271918.JOURNAL_DESC,
o271918.CURRENCY_CONVERSION_RATE
FROM (
    select gjh.je_source Source
        ,gjh.period_name
        ,gjh.name Journal_Name
        ,gjh.currency_code Currency
        ,gjh.default_effective_date Effective_Date
        ,gjh.creation_date
        ,gjh.description Journal_Desc
        ,(case  when gjcl.USER_JE_CATEGORY_NAME in ( 'Purchase Invoices','Payments',                  'Sales Invoices','Credit Memos') then gjl.subledger_doc_sequence_value
        else
        gjh.doc_sequence_value end) Voucher_Number
        ,gjcl.USER_JE_CATEGORY_NAME gl_category
        ,gcc.account_type
        ,gcc.segment1   company_acct
        ,asr.parent_flex_value expense_attr
        ,asr.parent_flex_Desc expense_attr_desc
        ,gcc.segment2   dept_acct
        ,gcc.segment3   main_acct
        ,gcc.segment4   sub_acct
        ,gcc.segment5   project_acct
        ,gcc.segment1||'.'||gcc.segment2||'.'||gcc.segment3||'.'||gcc.segment4||'.'||gcc.segment5||'.'||gcc.segment6||'.'||gcc.segment7 acct_no
        ,gjh.currency_conversion_rate
        ,gjh.currency_conversion_type
        ,gjl.je_line_num
        ,gjl.description line_description
        ,NVL(gjl.entered_dr,0) Entered_DR
        ,NVL(gjl.entered_cr,0) Entered_CR
        ,NVL(gjl.accounted_dr,0) Accounted_DR
        ,NVL(gjl.accounted_cr,0) Accounted_CR
        ,gjl.subledger_doc_sequence_value
        ,gjl.status
        ,gjl.ledger_id
        ,gjl.code_combination_id
        ,apps.ygl_info_pkg.get_acct_desc(gcc.chart_of_accounts_id,gcc.code_combination_id) acct_desc
        ,apps.ygl_info_pkg.get_segment_desc(gcc.chart_of_accounts_id,gcc.code_combination_id,2) dept_acct_desc
        ,apps.ygl_info_pkg.get_segment_desc(gcc.chart_of_accounts_id,gcc.code_combination_id,3) main_acct_desc
        ,apps.ygl_info_pkg.get_segment_desc(gcc.chart_of_accounts_id,gcc.code_combination_id,4) sub_acct_desc
        ,mag.parent_flex_value main_acct_grp_code
        ,mag.parent_flex_Desc  main_acct_grp_desc
        ,fu.user_name  created_by
        ,fu.description created_by_name
        ,fu1.user_name  posted_by
        ,fu1.description posted_by_name
    from apps.gl_je_headers gjh
        ,apps.gl_je_lines gjl
        ,apps.gl_code_combinations gcc
        ,apps.ygl_acct_segment_rollup_v asr
        ,apps.ygl_acct_segment_rollup_v mag
        ,apps.fnd_user fu
        ,apps.fnd_user fu1
        ,apps.GL_JE_CATEGORIES_TL  gjcl
    where gjh.je_header_id=gjl.je_header_id
        and gjl.code_combination_id=gcc.code_combination_id
        and gcc.chart_of_accounts_id = asr.id_flex_num(+)
        and gcc.segment2 = asr.child_flex_value(+)
        and asr.segment_num(+)=2
        and gcc.chart_of_accounts_id = mag.id_flex_num(+)
        and gcc.segment3 = mag.child_flex_value(+)
        and mag.segment_num(+) = 3
        and gjh.je_category not in ('Budget')
        and gjl.created_by = fu.user_id  and gjl.last_updated_by=fu1.user_id
        and gjh.je_category=gjcl.je_category_name
 ) o271918
WHERE o271918.COMPANY_ACCT in（ '01','02','03')
and TO_CHAR(o271918.EFFECTIVE_DATE,'yyyy-mm')='thismonth'
and o271918.EXPENSE_ATTR_DESC is NULL
    --AND (o271918.MAIN_ACCT BETWEEN '5410' AND '5579' AND o271918.MAIN_ACCT <> '5491')
ORDER BY o271918.EFFECTIVE_DATE ASC)
GROUP BY date_month
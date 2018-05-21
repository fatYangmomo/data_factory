#!/usr/bin/python
# -*- coding: UTF-8 -*-


import pandas


from dataprocess.oracleprocess.erp.app.accounts_payable_aging \
    import AccountsPayableAging
from dataprocess.oracleprocess.erp.app.accounts_receivable \
    import AccountsReceivable
from dataprocess.oracleprocess.erp.app.amount_of_temporary_assessment_payable \
    import AmountOfTemporaryAssessmentPayable
from dataprocess.oracleprocess.erp.app.construction_in_progress \
    import ConstructionInProgress
from dataprocess.oracleprocess.erp.app.expenses_for_the_period \
    import ExpensesForThePeriod
from dataprocess.oracleprocess.erp.app.inventory_details_interim_inventory \
    import InventoryDetailsInterimInventory
from dataprocess.oracleprocess.erp.app.inventory_details_into_the_consumption \
    import InventoryDetailsIntoTheConsumption
from dataprocess.oracleprocess.erp.app.inventory_details_inventory_name \
    import InventoryDetailsInventoryName
from dataprocess.oracleprocess.erp.app.inventory_details_work_in_progress \
    import InventoryDetailsWorkInProgress
from dataprocess.oracleprocess.erp.app.main_business_cost \
    import MainBusinessCost
from dataprocess.oracleprocess.erp.app.main_business_income \
    import MainBusinessIncome


################
#  test
################


def write_excel(data):
    writer = pandas.ExcelWriter("./tmp.xlsx")
    data.to_excel(writer, sheet_name="sheet1")
    writer.save()


def main():
    m = MainBusinessIncome()
    df = m()
    write_excel(df)


if __name__ == "__main__":
    main()
